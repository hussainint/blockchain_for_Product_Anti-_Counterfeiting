import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie/DB/db.dart';
import 'package:genie/screens/user/prodModel.dart';

import '../constants/textStyleconst.dart';

class ProductDetails extends StatelessWidget {
  ProdModel product;
  bool canTransfer;
  ProductDetails({
    required this.product,
    required this.canTransfer,
  });
  @override
  Widget build(BuildContext context) {
    TextEditingController trasferTo = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  '${product.image}',
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 40),
              Text('${product.name}', style: h1),
              Text('${product.identification}', style: wc),
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sender', style: h1),
                    Text('Address: ${product.senderAddress}', style: wc),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Owner',
                      style: h1,
                    ),
                    Text('Address: ${product.transferAddress}', style: wc),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Details', style: h1),
                    Text(
                      '${product.otherDetails}',
                      style: wc,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              if (canTransfer)
                Center(
                  child: MaterialButton(
                    child: Text('Transfer'),
                    color: Colors.white,
                    minWidth: MediaQuery.of(context).size.width / 2,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0)), //this right here
                              child: Container(
                                height: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Transfer to',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 30),
                                      TextField(
                                        controller: trasferTo,
                                        decoration: InputDecoration(
                                          hintText: 'Enter address',
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Center(
                                        child: SizedBox(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              final FirebaseAuth auth =
                                                  FirebaseAuth.instance;
                                              final User? user =
                                                  auth.currentUser;
                                              final uid = user!.uid;

                                              print('1');

                                              ///
                                              await DB().tranferTo(
                                                  uid,
                                                  trasferTo.text.trim(),
                                                  product);
                                              print('2');

                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Transfer",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
