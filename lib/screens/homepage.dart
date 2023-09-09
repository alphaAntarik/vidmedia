import 'package:flutter/material.dart';
import 'package:vidmedia/screens/addpost_screen.dart';

import 'package:vidmedia/screens/feed_screen.dart';
import 'package:vidmedia/screens/searchscreen.dart';

import 'package:vidmedia/screens/user_details.screen.dart';

class HomePage extends StatefulWidget {
  final bool? isloggedinviaphonenumber;

  HomePage({required this.isloggedinviaphonenumber});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedValue;
  bool isDropdownOpen = false;

  List<String> dropdownItems = ['Newest first', 'Oldest first'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            TextButton(
              child: isDropdownOpen
                  ? Container(
                      width: 200,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                            isDropdownOpen = !isDropdownOpen;
                          });
                        },
                        items: dropdownItems.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    )
                  : Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
              },
            ),
          ],
          title: Text("Vidmedia"),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.list_rounded), text: "Feed"),
            Tab(icon: Icon(Icons.add), text: "upload"),
            Tab(icon: Icon(Icons.account_circle_sharp), text: "profile"),
          ]),
        ),
        body: TabBarView(children: [
          FeedScreen(
            selectedValue: selectedValue,
          ),
          AddPost(
            isloggedinbyphone: widget.isloggedinviaphonenumber,
          ),
          UserDetails(
            isloggedinbyphone: widget.isloggedinviaphonenumber,
          )
        ]),
      ),
    );
  }
}
