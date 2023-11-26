import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User user;
  const SearchPage({
    super.key,
    required this.userModel,
    required this.user,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                color: Theme.of(context).colorScheme.primary,
                child: const Text('Search'),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              // StreamBuilder(stream: stream, builder: builder)
            ],
          ),
        ),
      ),
    );
  }
}
