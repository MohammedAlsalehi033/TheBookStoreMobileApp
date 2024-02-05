import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thebookstoreapp/DataFromFireStore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SingingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey:'AIzaSyDcrairSv8Odb-Rxr6MEFn359FUg4qY9NU',appId:'1:749157065262:android:9ecc6ae851a367187775bf',messagingSenderId:'749157065262',projectId:'fir-cdba5'));
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Run the app with the appropriate initial route
  runApp(currentUser == null ? SignningWidget() : MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:DataFromFireStore()
    );
  }
}

