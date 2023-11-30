import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_mode.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final UserModel targetUser;
  final UserModel userModel;
  final User user;
  const ChatRoomPage({
    super.key,
    required this.chatRoomModel,
    required this.targetUser,
    required this.userModel,
    required this.user,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    String msg = _messageController.text.trim();
    _messageController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        text: msg,
        sender: widget.userModel.uid,
        createdOn: DateTime.now(),
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatRoomId)
          .set(widget.chatRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 20),
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  NetworkImage(widget.targetUser.profilePicUrl.toString()),
            ),
            const SizedBox(width: 10),
            Text(
              widget.targetUser.fullName.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // this is where chat will go
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatRoomModel.chatRoomId)
                        .collection("messages")
                        .orderBy("createdOn", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);

                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: TextStyle(
                                      color: (currentMessage.sender ==
                                              widget.userModel.uid)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSecondary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onTertiary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'An error occured. Please check your Internet connection'));
                      } else {
                        return const Center(
                            child: Text('Say hi to your new friend'));
                      }
                    },
                  ),
                ),
              ),

              Container(
                color: Colors.grey.shade200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        maxLines: null,
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
