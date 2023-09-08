import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:vidmedia/homepage.dart';
import 'package:vidmedia/login_screen.dart';
import 'package:vidmedia/loginscreen.dart';
import 'package:vidmedia/mobilrvarifypage.dart';
import 'package:vidmedia/signup_screen.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//     return FutureBuilder(
//       future: _initialization,
//       builder: (context, snapshot) {
//         return MaterialApp(
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             //textTheme: TextTheme(),
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           home: snapshot.connectionState != ConnectionState.done
//               ? Scaffold(body: CircularProgressIndicator())
//               : StreamBuilder(
//                   stream: FirebaseAuth.instance.authStateChanges(),
//                   builder: (context, userSnapshot) {
//                     if (userSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Scaffold(body: Center(child: Text("Loading...")));
//                     }
//                     if (userSnapshot.hasData) {
//                       return HomePage();
//                     }
//                     return LoginSignup();
//                   }),

//           //LoginSignup(),
//           // MobileVarifyPage(),
//         );
//       },
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //textTheme: TextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomePage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
      },
    );
  }
}

// class SignInScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = _emailController.text.trim();
//                 final password = _passwordController.text.trim();

//                 final user = await _authService.signInWithEmailAndPassword(
//                     email, password);
//                 if (user != null) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => ProfileScreen()),
//                   );
//                 } else {
//                   // Handle sign-in errors
//                 }
//               },
//               child: Text('Sign In'),
//             ),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 // Navigate to registration screen
//               },
//               child: Text('Create an Account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
