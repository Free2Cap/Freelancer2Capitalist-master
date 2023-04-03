import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacementNamed(context, "/login");
          });
        },
        child: Text("back"),
      )),
    );
  }
}
