import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie/DB/db.dart';
import 'package:genie/screens/productDetails.dart';
import 'package:genie/screens/user/prodModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/textStyleconst.dart';

class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? email;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<ProdModel> product = [];
  getInit() async {
    /// Set sub domain
    final prefs = await SharedPreferences.getInstance();
    final String? e = prefs.getString('email');
    print('emaillllll $email');
    final User? user = auth.currentUser;
    final uid = user!.uid;

    List<ProdModel> prod = await DB().getMyProducts(uid);
    print('get reponseeeee');
    print(prod);
    setState(() {
      email = e;
      product = prod;
    });
  }

  refresh() async {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    List<ProdModel> prod = await DB().getMyProducts(uid);

    setState(() {
      product = prod;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInit();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Blockchain'),
        actions: [
          FlatButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              final success = await prefs.remove('email');
              FirebaseAuth.instance.signOut();
            },
            child: Text('Logout'),
            textColor: Colors.red,
          ),
          FlatButton(
            onPressed: () async {
              refresh();
            },
            child: Text('Refresh'),
            textColor: Colors.red,
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () async {
          Future.delayed(const Duration(seconds: 3), () {
            return;
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: kToolbarHeight,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Email :',
                      style: h1,
                    ),
                    Text(
                      ' $email',
                      style: p2,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        'ID : ',
                        style: h1,
                      ),
                      FittedBox(
                        child: Text(
                          '$uid',
                          style: p2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 75),
                Center(
                  child: Text(
                    'Your Assets',
                    style: h1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: product.length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ProductDetails(
                                canTransfer: true,
                                product: product[i],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          // height: height * 0.65,
                          decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(15),
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.network(
                                  '${product[i].image}',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product[i].name}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${product[i].identification}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
