import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/bloc/phone_credential_bloc.dart';
import 'package:vidmedia/models/usermodel.dart';
import 'package:vidmedia/screens/authentication%20screens/loginscreen.dart';
import 'package:vidmedia/widgets/profile.dart';

class UserDetails extends StatefulWidget {
  final bool? isloggedinbyphone;
  const UserDetails({required this.isloggedinbyphone});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? username;
  String? userdp;
  String? useremail;
  List? videoLinks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<PhoneCredentialBloc, PhoneCredentialState>(
            builder: (context, state) {
      if (state is PhoneCredentialloaded) {
        return FutureBuilder<UserModel?>(
            future: AuthMethods().getPhoneUserDetails(state.credential),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData) {
                return Text("No data found.");
              } else {
                UserModel? documents = snapshot.data;

                return Profile(
                  email: documents!.email,
                  userdp: documents.image_url,
                  username: documents.name,
                );
              }
            });
      } else {
        FutureBuilder<UserModel?>(
            future: AuthMethods().getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData) {
                return Text("No data found.");
              } else {
                UserModel? documents = snapshot.data;

                return Profile(
                  email: documents!.email,
                  userdp: documents.image_url,
                  username: documents.name,
                );
              }
            });
      }
      return Container();
    }));
  }
}
                            
                            

          // List<DocumentSnapshot>? documents = snapshot.data;
          // return PageView.builder(
          //   itemCount: documents!.length,
          //   scrollDirection: Axis.vertical,
          //   itemBuilder: (context, index) {
          //     if (widget.selectedValue == "Oldest first") {
          //       return ListTile(
          //         title: VideoPlayerScreen(
          //           videoUrl: documents[index]['video_link'],
          //           videoTitle: documents[index]['title'],
          //           userdp: documents[index]['user_dp_link'],
          //           location: documents[index]['location'],
          //           genre: documents[index]['genre'],
          //           day: documents[index]['dayadded'],
          //         ),
          //       );
          //     }

          //     return ListTile(
          //       title: VideoPlayerScreen(
          //         videoUrl: documents[documents.length - 1 - index]
          //             ['video_link'],
          //         videoTitle: documents[documents.length - 1 - index]['title'],
          //         userdp: documents[documents.length - 1 - index]
          //             ['user_dp_link'],
          //         location: documents[documents.length - 1 - index]['location'],
          //         genre: documents[documents.length - 1 - index]['genre'],
          //         day: documents[documents.length - 1 - index]['dayadded'],
          //       ),
          //     );
          //   },
          // );
      //   }
      //  },
      // builder: (context, snapshot) {
      //   if (snapshot.connectionState == ConnectionState.waiting) {
      //     return Scaffold(body: CircularProgressIndicator());
      //   } else if (snapshot.hasError) {
      //     return Text("Error: ${snapshot.error}");
      //   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //     return Text("No data found.");
      //   } else {
      //     List<DocumentSnapshot>? documents = snapshot.data;
      //     return PageView.builder(
      //       itemCount: documents!.length,
      //       scrollDirection: Axis.vertical,
      //       itemBuilder: (context, index) {
      //         if (widget.selectedValue == "Oldest first") {
      //           return ListTile(
      //             title: VideoPlayerScreen(
      //               videoUrl: documents[index]['video_link'],
      //               videoTitle: documents[index]['title'],
      //               userdp: documents[index]['user_dp_link'],
      //               location: documents[index]['location'],
      //               genre: documents[index]['genre'],
      //               day: documents[index]['dayadded'],
      //             ),
      //           );
      //         }

      //         return ListTile(
      //           title: VideoPlayerScreen(
      //             videoUrl: documents[documents.length - 1 - index]
      //                 ['video_link'],
      //             videoTitle: documents[documents.length - 1 - index]['title'],
      //             userdp: documents[documents.length - 1 - index]
      //                 ['user_dp_link'],
      //             location: documents[documents.length - 1 - index]['location'],
      //             genre: documents[documents.length - 1 - index]['genre'],
      //             day: documents[documents.length - 1 - index]['dayadded'],
      //           ),
      //         );
      //       },
      //     );
      //   }
      // },
  //  );
            
            
          //   TextButton(
          //       onPressed: () async {
          //         final details =
          //             await AuthMethods().getPhoneUserDetails(state.credential);

          //         setState(() {
          //           userdp = details!.image_url;
          //           username = details.name;
          //           useremail = details.email;
          //           videoLinks = details.videos;
          //         });
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => Profile(
          //                     email: useremail!,
          //                     userdp: userdp!,
          //                     username: username!,
          //                   )),
          //         );
          //       },
          //       child: Text("Press here"));
          // } else {
          //   return TextButton(
          //       onPressed: () async {
          //         final details = await AuthMethods().getUserDetails();

          //         setState(() {
          //           userdp = details!.image_url;
          //           username = details.name;
          //           useremail = details.email;
          //           videoLinks = details.videos;
          //         });

          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => Profile(
          //                     email: useremail!,
          //                     userdp: userdp!,
          //                     username: username!,
          //                   )),
          //         );
          //       },
          //       child: Text("Press here2"));
//           }
//         },
//       ),
//     );
//   }
// }
