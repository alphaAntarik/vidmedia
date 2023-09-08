// import 'dart:io';

// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AuthForm extends StatefulWidget {
//   AuthForm(this.submitFn, this.isLoading);

//   final bool isLoading;
//   final void Function(
//     String email,
//     String name,
//     String password,
//     String phonenumber,
//     File image,
//     bool isLogin,
//     BuildContext ctx,
//   ) submitFn;

//   @override
//   State<AuthForm> createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm> {
//   final _formKey = GlobalKey<FormState>();
//   var _isLogin = true;
//   var _userEmail = '';
//   var _userName = '';
//   var _userPassword = '';
//   var _usernumber = '';
//   File? _userImageFile;

//   bool? nkey;

//   Country selectedCountry = Country(
//     phoneCode: "91",
//     countryCode: "IN",
//     e164Sc: 0,
//     geographic: true,
//     level: 1,
//     name: "India",
//     example: "India",
//     displayName: "India",
//     displayNameNoCountryCode: "IN",
//     e164Key: "",
//   );
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final mobileController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     passwordController.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     nkey = true;
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _userImageFile = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   void _trySubmit() {
//     final isValid = _formKey.currentState!.validate();
//     FocusScope.of(context).unfocus();

//     if (_userImageFile == null && !_isLogin) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please pick an image.'),
//           backgroundColor: Theme.of(context).errorColor,
//         ),
//       );
//       return;
//     }

//     if (isValid) {
//       _formKey.currentState!.save();
//       widget.submitFn(
//         _userEmail.trim(),
//         _userName.trim(),
//         _userPassword.trim(),
//         _usernumber.trim(),
//         _userImageFile!,
//         _isLogin,
//         context,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     mobileController.selection = TextSelection.fromPosition(
//       TextPosition(
//         offset: mobileController.text.length,
//       ),
//     );
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: [
//                 if (nkey == false)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: InkWell(
//                       onTap: () => _pickImage(),
//                       child: _userImageFile == null
//                           ? const CircleAvatar(
//                               backgroundColor: Colors.purple,
//                               radius: 50,
//                               child: Icon(
//                                 Icons.account_circle,
//                                 size: 50,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CircleAvatar(
//                               backgroundImage: FileImage(_userImageFile!),
//                               radius: 50,
//                             ),
//                     ),
//                   ),
//                 if (nkey == false)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: TextFormField(
//                       cursorColor: Colors.purple,
//                       controller: nameController,
//                       onSaved: (value) {
//                         _userName = value!;
//                       },
//                       keyboardType: TextInputType.name,
//                       maxLines: 1,
//                       decoration: InputDecoration(
//                         prefixIcon: Container(
//                           margin: const EdgeInsets.all(8.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.purple,
//                           ),
//                           child: Icon(
//                             Icons.account_circle,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Colors.transparent,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Colors.transparent,
//                           ),
//                         ),
//                         hintText: "Jhon Smith",
//                         alignLabelWithHint: true,
//                         border: InputBorder.none,
//                         fillColor: Colors.purple.shade50,
//                         filled: true,
//                       ),
//                     ),
//                   ),
//                 if (nkey == false)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: TextFormField(
//                       maxLines: 1,
//                       cursorColor: Colors.purple,
//                       controller: mobileController,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           mobileController.text = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: "9876543210",
//                         fillColor: Colors.purple.shade50,
//                         filled: true,
//                         hintStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.grey.shade600,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.black12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.black12),
//                         ),
//                         prefixIcon: Container(
//                           padding: const EdgeInsets.all(8.0),
//                           child: InkWell(
//                             onTap: () {
//                               showCountryPicker(
//                                   context: context,
//                                   countryListTheme: const CountryListThemeData(
//                                     bottomSheetHeight: 550,
//                                   ),
//                                   onSelect: (value) {
//                                     setState(() {
//                                       selectedCountry = value;
//                                     });
//                                   });
//                             },
//                             child: Text(
//                               "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         suffixIcon: mobileController.text.length > 9
//                             ? Container(
//                                 height: 30,
//                                 width: 30,
//                                 margin: const EdgeInsets.all(10.0),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.green,
//                                 ),
//                                 child: const Icon(
//                                   Icons.done,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               )
//                             : null,
//                       ),
//                       onSaved: (value) {
//                         _usernumber = selectedCountry.phoneCode + value!;
//                       },
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: TextFormField(
//                     cursorColor: Colors.purple,
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     maxLines: 1,
//                     onSaved: (value) {
//                       _userEmail = value!;
//                     },
//                     decoration: InputDecoration(
//                       prefixIcon: Container(
//                         margin: const EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.purple,
//                         ),
//                         child: Icon(
//                           Icons.mail,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           color: Colors.transparent,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           color: Colors.transparent,
//                         ),
//                       ),
//                       hintText: "abc@gmail.com",
//                       alignLabelWithHint: true,
//                       border: InputBorder.none,
//                       fillColor: Colors.purple.shade50,
//                       filled: true,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: TextFormField(
//                     cursorColor: Colors.purple,
//                     controller: passwordController,
//                     keyboardType: TextInputType.name,
//                     maxLines: 1,
//                     onSaved: (value) {
//                       _userPassword = value!;
//                     },
//                     decoration: InputDecoration(
//                       prefixIcon: Container(
//                         margin: const EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.purple,
//                         ),
//                         child: Icon(
//                           Icons.password,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           color: Colors.transparent,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           color: Colors.transparent,
//                         ),
//                       ),
//                       hintText: "Abc123@#",
//                       alignLabelWithHint: true,
//                       border: InputBorder.none,
//                       fillColor: Colors.purple.shade50,
//                       filled: true,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                       onPressed: _trySubmit,
//                       //  () {
//                       // _trySubmit
//                       // (
//                       //     "antarik@gmail.com",
//                       //     //emailController.text.trim(),
//                       //     "alpha",
//                       //     // nameController.text.trim(),
//                       //     "antarik1234",
//                       //     // passwordController.text.trim(),
//                       //     "1234567890",
//                       //     // selectedCountry.flagEmoji +
//                       //     //     selectedCountry.phoneCode,
//                       //     image,
//                       //     nkey ?? true,
//                       //     context)
//                       // ;
//                       // }

//                       child: Text(nkey == false ? "Signup" : "Login")),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           nkey = !nkey!;
//                         });
//                       },
//                       child: Text(nkey == true
//                           ? "Don't have an account? Signup"
//                           : "Already have an account?Login")),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
