import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/models/usermodel.dart';
import 'package:vidmedia/screens/homepage.dart';

class SignupWithPhone extends StatefulWidget {
  final String? mobilenumber;
  final String? id;

  SignupWithPhone({required this.mobilenumber, required this.id});

  @override
  _SignupWithPhoneState createState() => _SignupWithPhoneState();
}

class _SignupWithPhoneState extends State<SignupWithPhone> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //String? _phoneNumber;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    //mobileController.dispose();
    passwordController.dispose();
  }

  bool _isLoading = false;
  File? _userImageFile;
  String? downloadURL;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (_userImageFile != null) {
        await uploadPhoto(
          _userImageFile,
        );
      }

      try {
        if (emailController.text.trim().isNotEmpty ||
            nameController.text.trim().isNotEmpty ||
            passwordController.text.trim().isNotEmpty) {
          UserModel userModel = UserModel(
            email: emailController.text.trim(),
            name: nameController.text.trim(),
            uid: widget.id!,
            phoneNumber: widget.mobilenumber!,
            image_url: await AuthMethods().uploadPhoto(_userImageFile),
            videos: [],
          );

          await _firestore.collection('users').doc(widget.id).set(
                userModel.toJson(),
              );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        isloggedinviaphonenumber: true,
                      )));
        }
      } catch (err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$err")));
      }
      // Logging in the user w/ Firebase
      // String result = await AuthMethods().signUpUser(
      //     name: nameController.text.trim(),
      //     email: emailController.text.trim(),
      //     password: passwordController.text.trim(),
      //     phoneNumber: _phoneNumber,
      //     image_url: _userImageFile);
      // if (result != 'success') {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(result)));
      //   //showSnackBar(result, context);
      // } else {
      //   Navigator.pop(context);
      // }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _userImageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadPhoto(File? imageFile) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('user_profile_images/${DateTime.now()}.jpg');

      await storageRef.putFile(imageFile!);
      setState(() async {
        downloadURL = await storageRef.getDownloadURL();
      });

      // Here, you can update the user's profile with the downloadURL
      // For example, you can store this URL in Firestore to associate it with the user.
      // Update the Firestore document with the URL as needed.
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => _pickImage(),
                  child: _userImageFile == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 50,
                          child: Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_userImageFile!),
                          radius: 50,
                        ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    textFeld(
                        hintText: "Jhon Smith",
                        icon: Icons.account_circle_outlined,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: TextFormField(
                        enabled: false,
                        maxLines: 1,
                        cursorColor: Colors.purple,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.mobilenumber,
                          fillColor: Colors.purple.shade50,
                          filled: true,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          // prefixIcon: Container(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: InkWell(
                          //     onTap: () {
                          //       showCountryPicker(
                          //           context: context,
                          //           countryListTheme:
                          //               const CountryListThemeData(
                          //             bottomSheetHeight: 550,
                          //           ),
                          //           onSelect: (value) {
                          //             setState(() {
                          //               selectedCountry = value;
                          //             });
                          //           });
                          //     },
                          //     child: Text(
                          //       "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          //       style: const TextStyle(
                          //         fontSize: 18,
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 30.0,
                    //     vertical: 10.0,
                    //   ),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(labelText: 'Phone number'),
                    //     validator: (input) => input!.trim().isEmpty
                    //         ? 'Please enter a valid Phone number'
                    //         : null,
                    //     onSaved: (input) => _phoneNumber = input!,
                    //   ),
                    // ),
                    textFeld(
                        hintText: "xys@gmail.com",
                        icon: Icons.email_outlined,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController),
                    textFeld(
                        hintText: "xys1234@#",
                        icon: Icons.password,
                        inputType: TextInputType.visiblePassword,
                        maxLines: 1,
                        controller: passwordController),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 30.0,
                    //     vertical: 10.0,
                    //   ),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(labelText: 'Email'),
                    //     validator: (input) => !input!.contains('@')
                    //         ? 'Please enter a valid email'
                    //         : null,
                    //     onSaved: (input) => _email = input!,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 30.0,
                    //     vertical: 10.0,
                    //   ),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(labelText: 'Password'),
                    //     validator: (input) => input!.length < 6
                    //         ? 'Must be at least 6 characters'
                    //         : null,
                    //     onSaved: (input) => _password = input!,
                    //     obscureText: true,
                    //   ),
                    // ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                      ),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  // color: Colors.white,
                                  ),
                            )
                          : TextButton(
                              onPressed: () => _signUp(),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
}
