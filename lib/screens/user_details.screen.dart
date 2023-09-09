import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/bloc/phone_credential_bloc.dart';
import 'package:vidmedia/screens/authentication%20screens/loginscreen.dart';
import 'package:vidmedia/widgets/profile.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PhoneCredentialBloc, PhoneCredentialState>(
        builder: (context, state) {
          if (state is PhoneCredentialloaded) {
            return TextButton(
                onPressed: () async {
                  final details =
                      await AuthMethods().getPhoneUserDetails(state.credential);

                  setState(() {
                    userdp = details!.image_url;
                    username = details.name;
                    useremail = details.email;
                    videoLinks = details.videos;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              email: useremail!,
                              userdp: userdp!,
                              username: username!,
                            )),
                  );
                },
                child: Text("Press here"));
          } else {
            return TextButton(
                onPressed: () async {
                  final details = await AuthMethods().getUserDetails();

                  setState(() {
                    userdp = details!.image_url;
                    username = details.name;
                    useremail = details.email;
                    videoLinks = details.videos;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              email: useremail!,
                              userdp: userdp!,
                              username: username!,
                            )),
                  );
                },
                child: Text("Press here2"));
          }
        },
      ),
    );
  }
}
