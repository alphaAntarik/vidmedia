import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidmedia/models/feedmodel.dart';
import 'package:vidmedia/models/usermodel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user details
  Future<UserModel?> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<UserModel?> getPhoneUserDetails(String id) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(id).get();
    return UserModel.fromSnap(snap);
  }

  //get feed details
  Future<List<DocumentSnapshot>> getCollectionData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('video_feed').get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      return documents;
    } catch (e) {
      print("Error retrieving data: $e");
      return [];
    }
  }

  //upload dp
  Future<String> uploadPhoto(File? imageFile) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('user_profile_images/${DateTime.now()}.jpg');

      await storageRef.putFile(imageFile!);
      final String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return ('Error uploading image: $e');
    }
  }

  //upload video
  Future<String> uploadVideo(
      File? videoFile,
      String? name,
      String? title,
      String? genre,
      String? dayadded,
      String cityname,
      String uid,
      UserModel? usermodel) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('users_video_folder/$title+${DateTime.now()}.mp4');

      await storageRef.putFile(videoFile!);
      final String downloadURL = await storageRef.getDownloadURL();
      FeedModel feedModel = FeedModel(
          videotitle: name!,
          name: usermodel!.name,
          uid: uid,
          user_dp_link: usermodel.image_url,
          video_link: downloadURL,
          location: cityname,
          title: title,
          genre: genre,
          dayadded: dayadded);

      await _firestore
          .collection('video_feed')
          .doc(uid + '${DateTime.now()}')
          .set(
            feedModel.toJson(),
          );

      return downloadURL;
    } catch (e) {
      return ('Error uploading image: $e');
    }
  }

  Future<String> signUpUser({
    required String? name,
    required String? email,
    required String? password,
    required String? phoneNumber,
    required File? image_url,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email!.isNotEmpty || name!.isNotEmpty || password!.isNotEmpty) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password!);
        print(user.user!.uid);

        UserModel userModel = UserModel(
          email: email,
          name: name!,
          uid: user.user!.uid,
          phoneNumber: phoneNumber!,
          image_url: await uploadPhoto(image_url),
          videos: [],
        );

        await _firestore.collection('users').doc(user.user!.uid).set(
              userModel.toJson(),
            );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> update(
      File? videofile,
      String? name,
      String? title,
      String? genre,
      String? dayadded,
      String cityname,
      String userid,
      UserModel? userModel) async {
    String result = 'Some error occurred';

    userModel!.videos.add(await uploadVideo(
        videofile, name, title, genre, dayadded, cityname, userid, userModel));

    try {
      await _firestore.collection('users').doc(userid).update({
        'videos': userModel.videos,
      });

      result = "success";
    } catch (e) {
      result = "$e";
    }
    return result;
  }

  Future<String> signOut() async {
    await _auth.signOut();
    return "signed out";
  }
}
