import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String uid;
  final String image_url;
  final String phoneNumber;
  final List videos;

  UserModel(
      {required this.email,
      required this.name,
      required this.image_url,
      required this.uid,
      required this.phoneNumber,
      required this.videos});

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "name": name,
        "image_url": image_url,
        "phoneNumber": phoneNumber,
        "videos": videos,
      };

  static UserModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      image_url: snapshot['image_url'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      videos: snapshot['videos'],
      phoneNumber: snapshot['phoneNumber'],
      email: snapshot['email'],
    );
  }
}
