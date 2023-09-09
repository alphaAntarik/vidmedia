import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/widgets/videoPlayer.dart';

class FeedScreen extends StatefulWidget {
  final String? selectedValue;
  const FeedScreen({required this.selectedValue});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: AuthMethods().getCollectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No data found.");
        } else {
          List<DocumentSnapshot>? documents = snapshot.data;
          return PageView.builder(
            itemCount: documents!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (widget.selectedValue == "Oldest first") {
                return ListTile(
                  title: VideoPlayerScreen(
                    videoUrl: documents[index]['video_link'],
                    videoTitle: documents[index]['title'],
                    userdp: documents[index]['user_dp_link'],
                    location: documents[index]['location'],
                    genre: documents[index]['genre'],
                    day: documents[index]['dayadded'],
                  ),
                );
              }

              return ListTile(
                title: VideoPlayerScreen(
                  videoUrl: documents[documents.length - 1 - index]
                      ['video_link'],
                  videoTitle: documents[documents.length - 1 - index]['title'],
                  userdp: documents[documents.length - 1 - index]
                      ['user_dp_link'],
                  location: documents[documents.length - 1 - index]['location'],
                  genre: documents[documents.length - 1 - index]['genre'],
                  day: documents[documents.length - 1 - index]['dayadded'],
                ),
              );
            },
          );
        }
      },
    );
  }
}
