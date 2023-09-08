import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:vidmedia/models/usermodel.dart';
import 'package:vidmedia/screens/authentication%20screens/sIgnup_with_phone.dart';
import 'package:vidmedia/screens/homepage.dart';

import '../../bloc/phone_credential_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  String? phonenumber;

  OtpScreen({required this.verificationId, required this.phonenumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool? _isLoading;

  @override
  Widget build(BuildContext context) {
    final isLoading = false;
    // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
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
                              style: TextStyle(
                                  fontSize: 60, fontWeight: FontWeight.bold),
                            ))),
                        const SizedBox(height: 20),
                        const Text(
                          "Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter the OTP send to your phone number",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.purple.shade200,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text("Verify"),
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(
                                    context, widget.phonenumber!, otpCode!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Enter 6-Digit code")));
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Resend New Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // verify otp
  void verifyOtp(
      BuildContext context, String phonenumber, String userOtp) async {
    setState(() {
      _isLoading = true;
    });
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: userOtp);

    BlocProvider.of<PhoneCredentialBloc>(context).add(
        PhoneCredentialReceivingEvent(credential: credential.verificationId));

    try {
      await auth.signInWithCredential(credential);

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(credential.verificationId)
          .get();

      //String? email = UserModel.fromSnap(snap)!.email;

      // if (snap.e == null) {

      // }
      if (snap['email'] != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      isloggedinviaphonenumber: true,
                    )),
            (route) => false);
      }
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignupWithPhone(
                    mobilenumber: phonenumber,
                    id: credential.verificationId,
                  )),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    //final ap = Provider.of<AuthProvider>(context, listen: false);
    // ap.verifyOtp(
    //   context: context,
    //   verificationId: widget.verificationId,
    //   userOtp: userOtp,
    //   onSuccess: () {
    //     // checking whether user exists in the db
    //     ap.checkExistingUser().then(
    //       (value) async {
    //         if (value == true) {
    //           // user exists in our app
    //           ap.getDataFromFirestore().then(
    //                 (value) => ap.saveUserDataToSP().then(
    //                       (value) => ap.setSignIn().then(
    //                             (value) => Navigator.pushAndRemoveUntil(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) => const HomeScreen(),
    //                                 ),
    //                                 (route) => false),
    //                           ),
    //                     ),
    //               );
    //         } else {
    //           // new user
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => const UserInfromationScreen()),
    //               (route) => false);
    //         }
    //       },
    //     );
    //},
    //);
  }
}
