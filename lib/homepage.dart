import 'package:flutter/material.dart';
import 'package:vidmedia/addpost_screen.dart';

import 'package:vidmedia/feed_screen.dart';

import 'package:vidmedia/user_details.screen.dart';

class HomePage extends StatefulWidget {
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
        body: TabBarView(children: [FeedScreen(), AddPost(), UserDetails()]),
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
