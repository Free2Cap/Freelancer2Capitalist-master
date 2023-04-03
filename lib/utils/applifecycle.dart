import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    // Update the user's activity status and last seen timestamp
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      if (state == AppLifecycleState.resumed) {
        userRef.update({'isActive': true});
      } else if (state == AppLifecycleState.paused) {
          userRef.update({
            'isActive': false,
          'lastseen': FieldValue.serverTimestamp(),
        });
      }
    }
  }
}

class ChatVisitedNotifier extends ValueNotifier<bool> {
  ChatVisitedNotifier(bool value) : super(value);
}

class ChatVisitedNotifierId extends ValueNotifier<String> {
  ChatVisitedNotifierId(String value) : super(value);
}
