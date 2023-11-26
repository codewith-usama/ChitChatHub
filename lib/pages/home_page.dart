import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User user;
  const HomePage({
    super.key,
    required this.userModel,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print('home');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text('ChitChatHub'),
      ),
      body: SafeArea(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  SearchPage(userModel: widget.userModel, user: widget.user),
            ),
          );
        },
        child: const Icon(
          Icons.search,
        ),
      ),
    );
  }
}
