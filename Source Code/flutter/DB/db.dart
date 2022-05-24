import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:genie/screens/user/prodModel.dart';

class DB {
  Future<void> upload({
    required String admin_uid,
    required File image,
    required String qr,
    required String prodname,
    required String identification,
    required String transfer_Address,
    required String otherDetails,
  }) async {
    var dtt = DateTime.now();
    var dt = '$dtt'.split('.')[0];
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('products')
        .child('$admin_uid $dt.jpg');

    await ref.putFile(image);

    String imagelink = await ref.getDownloadURL();

    ///
    await FirebaseFirestore.instance.collection('products').doc('$qr').set(
      {
        'name': prodname,
        'identification': identification,
        'Sender address': admin_uid,
        'ownder address': transfer_Address,
        'other details': otherDetails,
        'image': imagelink,
      },
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$transfer_Address')
        .update(
      {
        '$qr': {
          'name': prodname,
          'identification': identification,
          'transfer address': transfer_Address,
          'other details': otherDetails,
          'image': imagelink,
          'Sender address': admin_uid,
        }
      },
    );
    return;
  }

  Future<List<ProdModel>> getMyProducts(String uid) async {
    List<ProdModel> prod = [];
    await FirebaseFirestore.instance.doc('users/$uid').get().then((value) {
      value.data()!.forEach((key, value) {
        print('key $key');
        if (key == 'dateTime' ||
            key == 'email' ||
            key == 'name' ||
            value == 'once owned') {
        } else {
          print('values');
          print(value);
          print(value['identification']);
          print(value['image']);
          print(value['name']);
          print(key);
          print(value['transfer address']);

          ProdModel k = ProdModel(
            identification: value['identification'],
            image: value['image'],
            name: value['name'],
            otherDetails: value['other details'],
            qr: key,
            transferAddress: value['transfer address'],
            senderAddress: value['Sender address'],
          );
          prod.add(k);
        }
      });
    });
    return prod;
  }

  Future<void> tranferTo(
    String from_id,
    String to_id,
    ProdModel prod,
  ) async {
    print('in');

    await FirebaseFirestore.instance
        .collection('products')
        .doc('${prod.qr}')
        .update(
      {
        'Sender address': from_id,
        'ownder address': to_id,
      },
    );
    await FirebaseFirestore.instance.collection('users').doc('$from_id').update(
      {'${prod.qr}': 'once owned'},
    );

    ///
    await FirebaseFirestore.instance.collection('users').doc('$to_id').update(
      {
        '${prod.qr}': {
          'name': prod.name,
          'identification': prod.identification,
          'transfer address': to_id,
          'other details': prod.otherDetails,
          'image': prod.image,
          'Sender address': from_id,
        }
      },
    );
  }

  Future<ProdModel> productDetails(String qr) async {
    ProdModel prod = ProdModel(
        identification: '',
        image: 'image',
        name: 'name',
        otherDetails: 'otherDetails',
        qr: 'qr',
        transferAddress: 'transferAddress',
        senderAddress: '');
    await FirebaseFirestore.instance.doc('products/$qr').get().then((val) {
      print('anssss');
      print(val['image']);
      Map? value = val.data();
      print(value);
      print('======');
      print(value!['identification']);
      print(value['image']);
      print(value['name']);
      print(value['other details']);

      print(value['ownder address']);

      ProdModel k = ProdModel(
        identification: value['identification'],
        image: value['image'],
        name: value['name'],
        otherDetails: value['other details'],
        qr: qr,
        transferAddress: value['Sender address'],
        senderAddress: value['ownder address'],
      );
      print('complete');
      prod = k;
    });
    return prod;
  }
}
