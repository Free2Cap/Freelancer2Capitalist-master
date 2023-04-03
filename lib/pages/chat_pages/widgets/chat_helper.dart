import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../models/chat_room_model.dart';
import '../../../models/user_model.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;

  const CustomCircleAvatar({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}

class ChatHelper {
  Future<ChatRoomModel?> getChatRoomModel(
      UserModel targetUser, UserModel currentUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshotDocs = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentUser.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshotDocs.docs.isNotEmpty) {
      //Fetch the existing one
      log("there is chat room");
      var docData = snapshotDocs.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatRoom;
    } else {
      //create a new one
      ChatRoomModel newChatRoom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage: "",
          participants: {
            currentUser.uid.toString(): true,
            targetUser.uid.toString(): true
          },
          sequnece: DateTime.now(),
          users: [currentUser.uid.toString(), targetUser.uid.toString()]);
      try {
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newChatRoom.chatroomid)
            .set(newChatRoom.toMap());
      } on FirebaseException catch (ex) {
        log(ex.toString());
      }
      chatRoom = newChatRoom;
      log("new chatroom created");
    }

    return chatRoom;
  }
}
