import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie/screens/admin/adminHome.dart';
import 'package:genie/screens/productDetails.dart';
import 'package:genie/screens/qrdisplay.dart';
import 'package:genie/screens/user/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/textStyleconst.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? email;
  final FirebaseAuth auth = FirebaseAuth.instance;

  getInit() async {
    /// Set sub domain
    final prefs = await SharedPreferences.getInstance();
    final String? e = prefs.getString('email');
    setState(() {
      email = e;
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
    // return QRdisplay(
    //     data:
    //         'bfad31e0ec72fa5ffc17e185185b4ec946adf22b2d1afc464a430bd182cd1b1a',
    //     name: 'Adapter Mac');
    if (email == null) {
      return Scaffold(
        body: Container(),
      );
    } else if (email!.contains('admin')) {
      return AdminHome();
    }
    return MyHome();
  }
}
