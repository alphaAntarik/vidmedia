import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String videotitle;
  final String name;
  final String uid;
  final String user_dp_link;
  final String video_link;
  final String location;
  final String? title;
  final String? genre;
  final String? dayadded;

  FeedModel({
    required this.videotitle,
    required this.name,
    required this.uid,
    required this.user_dp_link,
    required this.video_link,
    required this.location,
    required this.title,
    required this.genre,
    required this.dayadded,
  });

  Map<String, dynamic> toJson() => {
        "videotitle": videotitle,
        "name": name,
        "uid": uid,
        "user_dp_link": user_dp_link,
        "video_link": video_link,
        "location": location,
        "title": title,
        "genre": genre,
        "dayadded": dayadded
      };

  static FeedModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FeedModel(
      videotitle: snapshot['videotitle'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      user_dp_link: snapshot['user_dp_link'],
      video_link: snapshot['video_link'],
      location: snapshot['location'],
      title: snapshot['title'],
      genre: snapshot['genre'],
      dayadded: snapshot['dayadded'],
    );
  }
}
