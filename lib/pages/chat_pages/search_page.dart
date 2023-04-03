import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/main.dart';
import 'package:freelancer2capitalist/models/chat_room_model.dart';
import 'package:freelancer2capitalist/pages/chat_pages/chat_room.dart';
import 'package:freelancer2capitalist/pages/chat_pages/widgets/chat_helper.dart';

import '../../models/user_model.dart';
import '../../utils/applifecycle.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ChatVisitedNotifier _isChatRoomVisited = ChatVisitedNotifier(false);
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Email Address",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                setState(() {});
              },
              child: const Text("Search"),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: searchController.text)
                  .where("email", isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                    if (dataSnapshot.docs.isNotEmpty) {
                      Map<String, dynamic> userMap =
                          dataSnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchedUser = UserModel.fromMap(userMap);
                      final ChatVisitedNotifierId _isChatRoomVisitedId =
                          ChatVisitedNotifierId(
                              widget.userModel.uid.toString());
                      return ListTile(
                        onTap: () async {
                          ChatHelper chatHelper = ChatHelper();
                          ChatRoomModel? chatroomModel = await chatHelper
                              .getChatRoomModel(searchedUser, widget.userModel);

                          if (chatroomModel != null) {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChatRoom(
                                chatVisitedNotifierId: _isChatRoomVisitedId,
                                chatVisitedNotifier: _isChatRoomVisited,
                                targetUser: searchedUser,
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                chatRoom: chatroomModel,
                              );
                            }));
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilepic!),
                        ),
                        title: Text(searchedUser.fullname!),
                        subtitle: Text(searchedUser.email!),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return const Text("No results Found");
                    }
                  } else if (snapshot.hasError) {
                    return Text("An error occured ${snapshot.error}");
                  } else {
                    return const Text("No results Found");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
