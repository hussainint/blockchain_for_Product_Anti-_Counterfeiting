import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:genie/DB/db.dart';
import 'package:genie/screens/admin/transfer.dart';
import 'package:genie/screens/productDetails.dart';
import 'package:genie/screens/user/prodModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model.dart';

class AdminHome extends StatelessWidget {
  Future<String> scanQrCode() async {
    print('in');
    try {
      String qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666',
        'CANCEL',
        true,
        ScanMode.QR,
      );
      print(qrCode);
      if (qrCode != '-1') {
        //no error
        return qrCode;
      } else {
        return '';
      }
    } catch (e) {
      print('out');
      return 'err';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Admin',
        ),
      ),
      body: Column(
        children: [
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TransferAdmin(),
                    ),
                  );
                },
                child: Card(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.assignment, color: Colors.white),
                      Text('Assign product Ownership',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.cyan,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.qr_code, color: Colors.white),
                    Text('Assing Land Ownership',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  String qr = await scanQrCode();
                  ProdModel prod = await DB().productDetails(qr);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProductDetails(
                        canTransfer: false,
                        product: prod,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.cyan,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, color: Colors.white),
                      Text('Product Details',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Card(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, color: Colors.white),
                      Text('Others', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();

              final success = await prefs.remove('email');
              FirebaseAuth.instance.signOut();
            },
            child: Text('L O G O U T',
                style: TextStyle(
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }
}
