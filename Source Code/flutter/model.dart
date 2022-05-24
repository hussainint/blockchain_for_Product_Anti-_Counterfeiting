import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Model extends ChangeNotifier {
  bool isLoading = true;
  int taskCount = 0;

  final String _rpcURL = "http://192.168.1.243:7545";
  final String _wsURL = "ws://192.168.1.243:7545/";

  final String _privatekey =
      "81142a9c3f54d9e1f7e7d7a283a7105482acacc6429e6bb8a6e70b551e636230";

  late final Web3Client _client;

  String? _abiCode;

  EthereumAddress? _contractAddress;

  Credentials? _credential;

  EthereumAddress? _ownaddress;

  DeployedContract? _contract;

  ContractFunction? _addProductOwnership;
  ContractFunction? _getProductDetails;
  ContractFunction? _transferOwnership;

  ContractEvent? _taskCreatedEvent;

  Model() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(
      _rpcURL,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsURL).cast<String>();
      },
    );
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String getabistring =
        await rootBundle.loadString('build/contracts/Genie.json');
    var jsonAbi = jsonDecode(getabistring);

    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credential = await EthPrivateKey.fromHex(_privatekey);
    _ownaddress = await _credential!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    print('end');

    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode!, "Genie"),
      _contractAddress!,
    );
    print('end2');

    _addProductOwnership = await _contract!.function("addProductOwnership");
    print('end3');

    _getProductDetails = await _contract!.function("getProductDetails");
    print('end4');

    _transferOwnership = await _contract!.function("transferOwnership");
    print('end5');
  }

  addProdOwnership(String qr, String uid) async {
    await _client.sendTransaction(
        _credential!,
        Transaction.callContract(
            contract: _contract!,
            function: _addProductOwnership!,
            parameters: [qr, uid, _ownaddress]));
    print('success');
  }
}
