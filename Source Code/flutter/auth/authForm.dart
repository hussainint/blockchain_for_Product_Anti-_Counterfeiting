import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_push_test/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  TextEditingController cemail = TextEditingController();
  TextEditingController cusername = TextEditingController();
  TextEditingController cpass = TextEditingController();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    print(
        'valid in ${cemail.text.trim()} ${cpass.text.trim()} ${cusername.text.trim()}');

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        cemail.text.trim(),
        cpass.text.trim(),
        cusername.text.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //         top: MediaQuery.of(context).padding.top + 15),
              //     child: Image.asset(
              //       'assets/doc1.png',
              //     ),
              //   ),
              // ),
              Container(
                  width: double.infinity,
                  // height: height * 0.65,
                  decoration: BoxDecoration(
                    color: Color(0xffE4F0FE),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          'Welcome Back,',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        _isLogin
                            ? 'Log in  to continue!'
                            : 'Sign up to continue',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(top: 5),
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: cemail,
                              key: ValueKey('email'),
                              showCursor: true,
                              decoration: const InputDecoration(
                                fillColor: Colors.black,
                                // border: NoInputBorder(),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      if (!_isLogin)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(top: 5),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                controller: cusername,
                                key: ValueKey('name'),
                                showCursor: true,
                                decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  // border: NoInputBorder(),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  if (value.contains('.')) {
                                    return 'Name cannot contain \'.\' ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(top: 5),
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: cpass,
                              // textAlign: TextAlign.center,
                              showCursor: true,
                              decoration: const InputDecoration(
                                fillColor: Colors.black,
                                // border: NoInputBorder(),

                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password must be at least 5 characters long.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        height: 60,
                        minWidth: double.infinity,
                        onPressed: _trySubmit,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          _isLogin ? 'Login' : 'Signup',
                        ),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Center(
                          child: Text(
                            _isLogin
                                ? 'I\'m a new user, Sign up'
                                : 'Already a user, Log in',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
