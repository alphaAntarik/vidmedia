import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/widgets/mobilrvarifypage.dart';
import 'package:vidmedia/screens/authentication%20screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailIdController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isLoading = false;

  var _textStyleBlack = new TextStyle(fontSize: 12.0, color: Colors.black);
  var _textStyleGrey = new TextStyle(fontSize: 12.0, color: Colors.grey);
  var _textStyleBlueGrey =
      new TextStyle(fontSize: 12.0, color: Colors.blueGrey);

  void _logInUser() async {
    if (_emailIdController.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else if (_passwordController.text.isEmpty) {
      _showEmptyDialog("Type something");
    }
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().logInUser(
      email: _emailIdController.text,
      password: _passwordController.text,
    );
    if (result == 'successs') {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      // showSnackBar(result, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // bottomNavigationBar: _bottomBar(),
      body: SingleChildScrollView(child: _body()),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }

  // Widget _userIDEditContainer() {
  //   return new Container(
  //     child: new TextField(
  //       controller: _emailIdController,
  //       decoration: new InputDecoration(
  //           hintText: 'Phone number, email or username',
  //           border: new OutlineInputBorder(
  //             borderSide: new BorderSide(color: Colors.black),
  //           ),
  //           isDense: true),
  //       style: _textStyleBlack,
  //     ),
  //   );
  // }

  // Widget _passwordEditContainer() {
  //   return Container(
  //     padding: EdgeInsets.only(top: 5.0),
  //     child: TextField(
  //       controller: _passwordController,
  //       obscureText: true,
  //       decoration: InputDecoration(
  //           hintText: 'Password',
  //           border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.black),
  //           ),
  //           isDense: true),
  //       style: _textStyleBlack,
  //     ),
  //   );
  // }

  Widget _loginContainer() {
    return ElevatedButton(
      onPressed: _logInUser,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  //  color: Colors.white,
                  ),
            )
          : Text(
              "Log In",
              // style: TextStyle(color: Colors.white),
            ),
    );
  }

  // Widget _facebookContainer() {
  //   return Container(
  //     alignment: Alignment.center,
  //     margin: EdgeInsets.only(top: 10.0),
  //     width: 500.0,
  //     height: 40.0,
  //     child: GestureDetector(
  //       onTap: null,
  //       child: Text(
  //         "Log in with facebook",
  //         style: TextStyle(
  //             color: Colors.purpleAccent, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }

  // Widget _bottomBar() {
  //   return Container(
  //     alignment: Alignment.center,
  //     height: 49.5,
  //     child: Column(
  //       children: <Widget>[
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Container(
  //               height: 1.0,
  //               color: Colors.grey.withOpacity(0.7),
  //             ),
  //             Padding(
  //                 padding: EdgeInsets.only(bottom: 0.5),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Text('Don\'t have an account?', style: _textStyleGrey),
  //                     Container(
  //                       child: TextButton(
  //                         onPressed: () =>
  //                             Navigator.pushNamed(context, SignupScreen.id),
  //                         child: Text('Sign Up.', style: _textStyleGrey),
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _body() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade50,
                ),
                child: Center(
                    child: Text(
                  "VM",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ))),
          ),
          const Text(
            "VideoMedia",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          textFeld(
              hintText: 'xyz@gmail.com',
              icon: Icons.email,
              inputType: TextInputType.emailAddress,
              maxLines: 1,
              controller: _emailIdController),
          textFeld(
              hintText: 'xyz1234@#',
              icon: Icons.password,
              inputType: TextInputType.text,
              maxLines: 1,
              controller: _passwordController),
          _loginContainer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Forgot your login details?',
                style: _textStyleGrey,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Get help logging in.',
                  style: _textStyleBlueGrey,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width / 2.7,
                color: Colors.grey,
                child: ListTile(),
              ),
              Text(
                ' OR ',
                style: TextStyle(color: Colors.blueGrey),
              ),
              Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width / 2.7,
                color: Colors.grey,
              ),
            ],
          ),
          MobileVarifyPage(),
          // _facebookContainer()
        ],
      ),
    );
  }

  _showEmptyDialog(String title) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          content: Text("$title can't be empty"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    } else if (Platform.isIOS) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Text("$title can't be empty"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    }
  }
}
