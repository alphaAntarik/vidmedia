// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:vidmedia/authform.dart';

// class LoginSignup extends StatefulWidget {
//   const LoginSignup({super.key});

//   @override
//   State<LoginSignup> createState() => _LoginSignupState();
// }

// class _LoginSignupState extends State<LoginSignup> {
//   final _auth = FirebaseAuth.instance;
//   var _isLoading = false;

//   void _submitAuthForm(
//     String email,
//     String name,
//     String password,
//     String phonenumber,
//     File? image,
//     bool isLogin,
//     BuildContext ctx,
//   ) async {
//     UserCredential authResult;

//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       if (isLogin) {
//         authResult = await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       } else {
//         authResult = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('user_image')
//             .child(authResult.user!.uid + '.jpg');

//         await ref.putFile(image!);

//         final url = await ref.getDownloadURL();

//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(authResult.user!.uid)
//             .set({
//           'email': email,
//           'image_url': url,
//           'name': name,
//           'password': password,
//           'phone_number': phonenumber,
//         });
//       }
//     } on PlatformException catch (err) {
//       var message = 'An error occurred, pelase check your credentials!';

//       if (err.message != null) {
//         message = err.message!;
//       }

//       ScaffoldMessenger.of(ctx).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Theme.of(ctx).errorColor,
//         ),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (err) {
//       print(err);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AuthForm(_submitAuthForm, _isLoading);
//   }
// }
