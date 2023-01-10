import 'package:chatapp/Theme.dart';
import 'package:chatapp/backend/service/helper.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
     await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBLJbaOfwLw2E77lrBNe4EqL_P9IaWfsbE",
            authDomain: "chatapp-66cbe.firebaseapp.com",
            projectId: "chatapp-66cbe",
            storageBucket: "chatapp-66cbe.appspot.com",
            messagingSenderId: "499638840489",
            appId: "1:499638840489:web:acd57a12d79b949efccdb8"
        )
     );
  }
  else{
      await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groupie',
      theme: myTheme,
      debugShowCheckedModeBanner: false,

      home: splash(),

    );
  }
}

