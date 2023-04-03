// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/common/theme_helper.dart';
import 'package:freelancer2capitalist/models/user_model.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:email_otp/email_otp.dart';

import '../utils/constants.dart';

class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage(
      {Key? key, required this.myAuth, required this.email, this.password})
      : super(key: key);
  final EmailOTP myAuth;
  final String email;
  final String? password;
  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordVerificationPageState createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  // EmailOTP myAuth = EmailOTP();

  // Future<void> sendOtp(String email) async {
  //   myAuth.setConfig(
  //       appEmail: "freelancer2capitalist@gmail.com",
  //       appName: "Freelancer2Capitalist",
  //       userEmail: email,
  //       otpLength: 4,
  //       otpType: OTPType.digitsOnly);
  //   try {
  //     if (await myAuth.sendOTP() == true) {
  //       print("otp sent");
  //     } else {
  //       print("falied");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  void signUp(String email, String password) async {
    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        // Constants.prefs?.setBool("loggedIn", true);
      }).onError((error, stackTrace) {
        print("Error ${error.toString()}");
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = true;
  // ignore: prefer_typing_uninitialized_variables
  var otp;

  @override
  Widget build(BuildContext context) {
    double headerHeight = 300;
    // final List<dynamic> args =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    // final String password = args[1];
    TextEditingController otpController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: headerHeight,
                // child: HeaderWidget(
                //     headerHeight, true, Icons.privacy_tip_outlined),
              ),
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              'Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                                  // textAlign: TextAlign.center,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // const Text(

                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextField(
                                controller: otpController,
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Password', 'Enter your password'),
                              ),
                            ),
                            // OTPTextField(
                            //   length: 4,
                            //   width: 300,
                            //   fieldWidth: 50,
                            //   style: const TextStyle(fontSize: 30),
                            //   textFieldAlignment: MainAxisAlignment.spaceAround,
                            //   fieldStyle: FieldStyle.underline,
                            //   onCompleted: (pin) {
                            //     try {
                            //       setState(() {
                            //         otp = pin;
                            //         _pinSuccess = true;
                            //       });
                            //     } catch (e) {
                            //       print(e);
                            //     }
                            //   }, //{
                            //   //},
                            // ),
                            const SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                                "Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              decoration: _pinSuccess
                                  ? ThemeHelper().buttonBoxDecoration(context)
                                  : ThemeHelper().buttonBoxDecoration(
                                      context, "#AAAAAA", "#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: _pinSuccess
                                    ? () async {
                                        bool verfied_otp = await widget.myAuth
                                            .verifyOTP(otp: otpController.text);
                                        if (await widget.myAuth.verifyOTP(
                                            otp: otpController.text)) {
                                          if (widget.password != null) {
                                            signUp(
                                                widget.email, widget.password!);
                                            // Navigator.of(context)
                                            //     .pushAndRemoveUntil(
                                            //         MaterialPageRoute(
                                            //         //     builder: (context) =>
                                            //         //         const LoginPage()),
                                            //         // (Route<dynamic> route) =>
                                            //             false);
                                            // print("new user created");
                                          } else {
                                            // Navigator.of(context)
                                            //     .pushAndRemoveUntil(
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 ResetPassword()),
                                            //         (Route<dynamic> route) =>
                                            //             false);
                                          }
                                        } else {
                                          print("otp not valid");
                                          print(otpController.text.runtimeType);
                                        }
                                      }
                                    : null,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
