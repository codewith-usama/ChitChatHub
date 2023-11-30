import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                color: Theme.of(context).colorScheme.tertiary,
                child: const Text('Search'),
                onPressed: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: _searchController.text)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        Map<String, dynamic> data = snapshot.data!.docs[0]
                            .data() as Map<String, dynamic>;
                        UserModel searchUserModel = UserModel.fromMap(data);

                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ChatRoomPage(),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade400,
                            backgroundImage:
                                NetworkImage(searchUserModel.profilePicUrl!),
                          ),
                          title: Text(searchUserModel.fullName.toString()),
                          subtitle: Text(searchUserModel.email.toString()),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return const Center(child: Text("No results found"));
                      }
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("An error occurred"));
                    } else {
                      return const Center(child: Text("No results found"));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
