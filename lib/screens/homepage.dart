import 'package:flutter/material.dart';
import 'package:vidmedia/screens/addpost_screen.dart';

import 'package:vidmedia/screens/feed_screen.dart';

import 'package:vidmedia/screens/user_details.screen.dart';

class HomePage extends StatefulWidget {
  final bool? isloggedinviaphonenumber;

  HomePage({required this.isloggedinviaphonenumber});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vidmedia"),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.list_rounded), text: "Feed"),
            Tab(icon: Icon(Icons.add), text: "upload"),
            Tab(icon: Icon(Icons.account_circle_sharp), text: "profile"),
          ]),
        ),
        body: TabBarView(children: [
          FeedScreen(),
          AddPost(
            isloggedinbyphone: widget.isloggedinviaphonenumber,
          ),
          UserDetails(
            isloggedinbyphone: widget.isloggedinviaphonenumber,
          )
        ]),
        // Center(
        //     child: Column(
        //   children: [
        //     Text("Home page"),
        //     ElevatedButton(onPressed: _signOut, child: Text("Log out"))
        //   ],
        // ))),
      ),
    );
  }
}
