import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genie/screens/admin/adminHome.dart';
import 'package:genie/screens/mainPage.dart';
import 'package:genie/screens/user/home.dart';
import 'package:genie/screens/admin/transfer.dart';
import 'package:provider/provider.dart';

import 'auth/authScreen.dart';
import 'firebase_options.dart';
import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          if (appSnapshot.hasError) {
            print('errrrrrrrrrrrrrrrrr');
            return MyHome(); // add loading screen
          }
          if (appSnapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
                create: (context) => Model(),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Genie Blockchain',
                  theme: ThemeData(
                    primarySwatch: Colors.indigo,
                  ),
                  home: appSnapshot.connectionState != ConnectionState.done
                      ? AuthScreen() // add loading screeen
                      : StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (ctx, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return AuthScreen(); // add loading screeen
                            }
                            if (userSnapshot.hasData) {
                              return MainPage();
                            }
                            return AuthScreen();
                          }),
                ));
          }
          return AuthScreen();
        });
  }
}
