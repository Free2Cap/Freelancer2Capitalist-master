import 'dart:math';

import 'package:flutter/material.dart';
import 'callModel.dart';
import 'videoCall/call_screen.dart';
import 'call_methods.dart';

import '../models/user_model.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required UserModel from, required UserModel to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.fullname,
      callerPic: from.profilepic,
      receiverId: to.uid,
      receiverName: to.fullname,
      receiverPic: to.profilepic,
      channelId: Random().nextInt(1000).toString(),
      hasDialled: true,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}
