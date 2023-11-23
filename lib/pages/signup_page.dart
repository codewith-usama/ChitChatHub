import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/complete_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void checkValue() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email == "" || password == "" || confirmPassword == "") {
      print('please fill all the fields');
    } else if (password != confirmPassword) {
      print("both password do not match");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel userModel = UserModel(
        uid: uid,
        email: email,
        fullName: "",
        profilePicUrl: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(userModel.toMap())
          .then(
        (value) {
          print('new user created');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompleteProfilePage(
                  userModel: userModel, firebaseUser: credential!.user!),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'ChitChatHub',
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    onPressed: () {
                      checkValue();
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const CompleteProfilePage(),
                      //   ),
                      // );
                    },
                    color: Theme.of(context).colorScheme.primary,
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              child: const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
