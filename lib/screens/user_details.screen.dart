import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/bloc/phone_credential_bloc.dart';
import 'package:vidmedia/screens/authentication%20screens/loginscreen.dart';

class UserDetails extends StatefulWidget {
  final bool? isloggedinbyphone;
  const UserDetails({required this.isloggedinbyphone});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? username;
  String? userdp;
  String? useremail;
  List? videoLinks;
  @override
  // void initState() {
  //   super.initState();
  //   //final details = await AuthMethods().getUserDetails();

  //   setState(() {
  //     _userdetails(widget.isloggedinbyphone!);

  //     // userdp = details!.image_url;
  //     // username = details.name;
  //     // useremail = details.email;
  //     // videoLinks = details.videos;
  //   });
  // }

  // void _userdetails(bool isphone) async {
  //   final details = isphone
  //       ? await AuthMethods().getPhoneUserDetails()
  //       : await AuthMethods().getUserDetails();

  //   setState(() {
  //     userdp = details!.image_url;
  //     username = details.name;
  //     useremail = details.email;
  //     videoLinks = details.videos;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      // Logging out the user w/ Firebase
      String result = await AuthMethods().signOut();
      if (result != 'success') {
        LoginScreen();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
        //showSnackBar(result, context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    }

    return Scaffold(
      body: BlocBuilder<PhoneCredentialBloc, PhoneCredentialState>(
        builder: (context, state) {
          if (state is PhoneCredentialloaded) {
            return TextButton(
                onPressed: () async {
                  final details =
                      await AuthMethods().getPhoneUserDetails(state.credential);

                  //: await AuthMethods().getUserDetails();

                  setState(() {
                    userdp = details!.image_url;
                    username = details.name;
                    useremail = details.email;
                    videoLinks = details.videos;
                  });
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child:
                                  // CircleAvatar(
                                  //           backgroundColor: Colors.purple,
                                  //           radius: 50,
                                  //           child: Icon(
                                  //             Icons.account_circle,
                                  //             size: 50,
                                  //             color: Colors.white,
                                  //           ),
                                  //         )
                                  //       :

                                  CircleAvatar(
                                // backgroundImage: NetworkImage(userdp!),
                                radius: 60,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(username!),
                                  // Text(useremail!),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Image.network('$userdp'),

                        ElevatedButton(
                            onPressed: _signOut, child: Text("Log out"))
                      ],
                    ),
                  );
                },
                child: Text("Press here"));
          } else {
            return TextButton(
                onPressed: () async {
                  final details = await AuthMethods().getUserDetails();

                  //: await AuthMethods().getUserDetails();

                  setState(() {
                    userdp = details!.image_url;
                    username = details.name;
                    useremail = details.email;
                    videoLinks = details.videos;
                  });
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child:
                                  // CircleAvatar(
                                  //           backgroundColor: Colors.purple,
                                  //           radius: 50,
                                  //           child: Icon(
                                  //             Icons.account_circle,
                                  //             size: 50,
                                  //             color: Colors.white,
                                  //           ),
                                  //         )
                                  //       :

                                  CircleAvatar(
                                backgroundImage: NetworkImage(userdp!),
                                radius: 60,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(username!),
                                  Text(useremail!),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Image.network('$userdp'),

                        ElevatedButton(
                            onPressed: _signOut, child: Text("Log out"))
                      ],
                    ),
                  );
                },
                child: Text("Press here2"));
          }
          // return CircularProgressIndicator();
        },
      ),
    );
  }
}
