import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:vidmedia/screens/authentication%20screens/otp_screen.dart';

import 'package:vidmedia/screens/authentication%20screens/signup_screen.dart';

class MobileVarifyPage extends StatefulWidget {
  const MobileVarifyPage({super.key});

  @override
  State<MobileVarifyPage> createState() => _MobileVarifyPageState();
}

class _MobileVarifyPageState extends State<MobileVarifyPage> {
  final TextEditingController phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isloading = false;

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

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 35, right: 25),
            child: Column(
              children: [
                const Text(
                  "Enter your registered phone number. We'll send you a verification code",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.purple,
                  controller: phoneController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
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
                              countryListTheme: const CountryListThemeData(
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
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (phoneController.text != "") {
                          setState(() {
                            _isloading = true;
                          });
                          auth.verifyPhoneNumber(
                              phoneNumber:
                                  '+${selectedCountry.phoneCode}${phoneController.text.trim()}',
                              verificationCompleted: (_) {
                                setState(() {
                                  _isloading = false;
                                });
                              },
                              verificationFailed: (e) {
                                setState(() {
                                  _isloading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$e")));
                              },
                              codeSent: (String verificationId, int? Token) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                              verificationId: verificationId,
                                              phonenumber:
                                                  '+${selectedCountry.phoneCode}${phoneController.text.trim()}',
                                            )));
                                setState(() {
                                  _isloading = false;
                                });
                              },
                              codeAutoRetrievalTimeout: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$e")));
                                setState(() {
                                  _isloading = false;
                                });
                              });
                          //sendPhoneNumber()
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please enter your mobile number")));
                        }
                      },
                      child: _isloading
                          ? CircularProgressIndicator()
                          : Text("Varify your number")),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: Text("Don't have an account? Register now!")),
                )
                //   child: CustomButton(
                //       text: "Login", onPressed: () => sendPhoneNumber()),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    // BlocProvider.of<UserAuthBloc>(context).add(UserAuthEvent(
    //     context: context,
    //     isSignedIn: false,
    //     phoneNumber: "+${selectedCountry.phoneCode}$phoneNumber"));
  }
}
