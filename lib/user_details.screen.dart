import 'package:flutter/material.dart';
import 'package:vidmedia/authmethods.dart';
import 'package:vidmedia/loginscreen.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? username;
  String? userdp;
  String? useremail;
  List? videoLinks;
  @override
  void initState() {
    super.initState();
    //final details = await AuthMethods().getUserDetails();

    setState(() {
      _userdetails();
      // userdp = details!.image_url;
      // username = details.name;
      // useremail = details.email;
      // videoLinks = details.videos;
    });
  }

  void _userdetails() async {
    final details = await AuthMethods().getUserDetails();

    setState(() {
      userdp = details!.image_url;
      username = details.name;
      useremail = details.email;
      videoLinks = details.videos;
    });
  }

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
      body: SingleChildScrollView(
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

            ElevatedButton(onPressed: _signOut, child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
