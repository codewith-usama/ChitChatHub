import 'package:chat_app/models/firebase_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel userModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    MyAppLoggedIn(userModel: userModel, user: currentUser);
  } else {
    runApp(const MainApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User user;
  const MyAppLoggedIn({
    super.key,
    required this.userModel,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(userModel: userModel, user: user),
    );
  }
}
