import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../call_methods.dart';

import '../callModel.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  const CallScreen({super.key, required this.call});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  CallMethods callMethods = CallMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Call has been made"),
            MaterialButton(
              onPressed: () {
                callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              },
              color: Colors.red,
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
