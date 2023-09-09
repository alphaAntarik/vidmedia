import 'package:flutter/material.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/screens/authentication%20screens/loginscreen.dart';

class Profile extends StatefulWidget {
  String userdp, username, email;
  Profile({required this.email, required this.userdp, required this.username});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      String result = await AuthMethods().signOut();
      if (result != 'signed out') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.userdp),
                    radius: 60,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username),
                      Text(widget.email),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(onPressed: _signOut, child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
