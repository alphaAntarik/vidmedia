import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/models/feedmodel.dart';
import 'package:vidmedia/widgets/videoPlayer.dart';

class SearchResult extends StatefulWidget {
  final String? search;
  SearchResult({required this.search});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('showing results for "${widget.search}"'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
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
            return ListView.builder(
              itemCount: documents!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (widget.search == documents[index]['title'] ||
                    widget.search == documents[index]['genre']) {
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

                return Container();
              },
            );
          }
        },
      ),
    );
  }
}
