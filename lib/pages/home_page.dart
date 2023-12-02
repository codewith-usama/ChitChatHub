// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/firebase_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'ChitChatHub',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .orderBy("created_on", descending: true)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot? chatRoomSnapshot =
                    snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);
                    Map<String, dynamic>? participants =
                        chatRoomModel.participants;
                    List<String> participantsKeys = participants!.keys.toList();

                    participantsKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantsKeys[0]),
                      builder: (BuildContext context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUser = userData.data as UserModel;

                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                      chatRoomModel: chatRoomModel,
                                      targetUser: targetUser,
                                      userModel: widget.userModel,
                                      user: widget.user,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    NetworkImage(userData.data!.profilePicUrl!),
                              ),
                              title: Text(targetUser.fullName.toString()),
                              subtitle: (chatRoomModel.lastMessage
                                      .toString()
                                      .isEmpty)
                                  ? Text(
                                      "Say Hi to your new Friend",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : Text(chatRoomModel.lastMessage.toString()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              } else {
                return const Center(child: Text('No chats'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return SearchPage(
                    userModel: widget.userModel, user: widget.user);
              },
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
