import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/utils/colors.dart';
import '../../../models/user_model.dart';
import '../../chat_pages/chat_user_card.dart';
import '../../profile_page.dart';
import '../../swipe/swipe.dart';

class CurveNavigationWidget extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CurveNavigationWidget({
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<CurveNavigationWidget> createState() => _CurveNavigationWidgetState();
}

class _CurveNavigationWidgetState extends State<CurveNavigationWidget> {
  int index = 0;
  final _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();

  @override
  Widget build(BuildContext context) {
    final screens = [
      // ChatUserCard(
      //     userModel: widget.userModel, firebaseUser: widget.firebaseUser),
      SwipeCard(
          userType: widget.userModel.userType
              .toString()), //due to this line the error_patch.dart
      ChatUserCard(
          userModel: widget.userModel, firebaseUser: widget.firebaseUser),
      ProfilePage(
          firebaseUser: widget.firebaseUser, usermodel: widget.userModel),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.purple,
        backgroundColor: Colors.white,
        height: 70,
        index: index,
        items: const [
          Icon(Icons.favorite_rounded, size: 30, color: Colors.white),
          Icon(Icons.chat_rounded, size: 30, color: Colors.white),
          Icon(Icons.person_rounded, size: 30, color: Colors.white),
        ],
        key: _bottomNavigationKey,
        onTap: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }
}
