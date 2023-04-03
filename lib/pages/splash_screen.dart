import 'dart:async';
import 'dart:developer';
import 'package:freelancer2capitalist/pages/navigator/widgets/curved_navigation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/pages/onboarding/onBoarding.dart';
import 'package:freelancer2capitalist/pages/profile_page.dart';
import '../models/FirebaseHelper.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  UserModel? newUserModel;
  // bool checkLogInState = false;

  // Future<void> checkLogIn() async {
  //   if (currentUser != null) {
  //     UserModel? thisUserModel =
  //         await FirebaseHelper.getUserModelById(currentUser!.uid);
  //     if (thisUserModel != null) {
  //       newUserModel = thisUserModel;
  //       checkLogInState = true;
  //     } else {
  //       checkLogInState = false;
  //     }
  //   } else {
  //     checkLogInState = false;
  //   }
  // }

  _SplashScreenState() {
    Timer(const Duration(milliseconds: 2000), () async {
      if (currentUser != null) {
        newUserModel = await FirebaseHelper.getUserModelById(currentUser!.uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({'isActive': true});
      }
      setState(() {
        // checkLogIn();
        // var snackBar = SnackBar(
        //   content: Text(newUserModel.toString()),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => //ChatUserCard()),
                    // checkLogInState == true
                    currentUser != null
                        ? CurveNavigationWidget(
                            userModel: newUserModel!,
                            firebaseUser: currentUser!,
                          )
                        : OnBoarding()),
            (route) => false);
      });
    });

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    offset: const Offset(5.0, 3.0),
                    spreadRadius: 2.0,
                  )
                ]),
            child: const Center(
              child: ClipOval(
                child: Icon(
                  Icons.android_outlined,
                  size: 128,
                ), //put your logo here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
