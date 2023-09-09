import 'dart:io';
import 'dart:typed_data';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/screens/homepage.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  String? _phoneNumber;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
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

      String result = await AuthMethods().signUpUser(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phoneNumber: _phoneNumber,
          image_url: _userImageFile);
      if (result != 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      isloggedinviaphonenumber: false,
                    )),
            (route) => false);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
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
                        maxLines: 1,
                        cursorColor: Colors.purple,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "9876543210",
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
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          _phoneNumber =
                              "+" + selectedCountry.phoneCode + value!;
                        },
                      ),
                    ),
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
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                      ),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : TextButton(
                              onPressed: () => _signUp(),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
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
