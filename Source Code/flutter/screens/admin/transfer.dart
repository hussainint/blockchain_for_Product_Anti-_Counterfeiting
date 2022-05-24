import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import 'package:genie/DB/db.dart';
import 'package:genie/screens/qrdisplay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model.dart';

class TransferAdmin extends StatefulWidget {
  @override
  State<TransferAdmin> createState() => _TransferAdminState();
}

class _TransferAdminState extends State<TransferAdmin> {
  List<String>? additionalDetails;

  TextEditingController prodName = TextEditingController();

  TextEditingController prodIden = TextEditingController();

  TextEditingController address = TextEditingController();
  File? _image;
  File? _imageFull;
  Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      //print('No image selected.');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // var listmodel = Provider.of<Model>(context);

    final FirebaseAuth auth = FirebaseAuth.instance;

    var height = MediaQuery.of(context).size.height - kToolbarHeight;
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Transfer Ownership'),
          actions: [
            Container(
              margin: EdgeInsets.all(12),
              child: MaterialButton(
                color: Colors.white,
                child: Text('Transfer'),
                onPressed: () async {
                  print(prodName.text);
                  print(prodIden.text);
                  print(address.text);
                  print(additionalDetails);

                  ///
                  final User? user = auth.currentUser;
                  final uid = user!.uid;

                  ///
                  String other = '';
                  for (var item in additionalDetails!) {
                    other = other + '\n' + item;
                  }

                  ///
                  var appleInBytes = utf8.encode("${prodName.text}-");
                  Digest qr = sha256.convert(appleInBytes);
                  print(qr.toString());

                  ///
                  await DB().upload(
                    admin_uid: uid,
                    image: _image!,
                    qr: qr.toString(),
                    prodname: prodName.text,
                    identification: prodIden.text,
                    transfer_Address: address.text,
                    otherDetails: other,
                  );

                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => QRdisplay(
                        data: qr.toString(),
                        name: prodName.text,
                      ),
                    ),
                  );
                  //
                  print('adding to blockchain');
                  // listmodel.addProdOwnership(
                  //     qr.toString(), address.text.trim());
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image != null
                    ? Center(
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          height: height * 0.2,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          File? temp = await getImageFromGallery();
                          setState(() {
                            _image = temp;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: height * 0.28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(Icons.camera_alt_rounded),
                          ),
                        ),
                      ),
                SizedBox(height: 40),
                Text('Product Name', style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                TextField(
                  controller: prodName,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                ///
                ///
                ///
                Text('Product Identification',
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                TextField(
                  controller: prodIden,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                ///
                ///
                ///
                Text('Transfer Address', style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                TextField(
                  controller: address,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                ///
                ///
                ///
                Text('Additional Product Details',
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                MultipleFields(
                  totalAns: ((allAns) => additionalDetails = allAns),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MultipleFields extends StatefulWidget {
  final void Function(List<String> allAns)? totalAns;
  MultipleFields({this.totalAns});
  @override
  State<MultipleFields> createState() => _MultipleFieldsState();
}

class _MultipleFieldsState extends State<MultipleFields> {
  int textfieldcount = 2;
  List<String> ans = ["", ""];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: textfieldcount,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                  onChanged: (val) {
                    ans[i] = val;

                    widget.totalAns!(ans);
                  },
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              textfieldcount = textfieldcount + 1;
              ans.add('');
            });
          },
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
