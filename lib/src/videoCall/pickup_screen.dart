import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../call_methods.dart';
import '../callModel.dart';

import 'call_screen.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  PickupScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.network(
              call.callerPic!,
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              call.callerName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                  icon: const Icon(Icons.call_end),
                  color: Colors.redAccent,
                ),
                const SizedBox(
                  width: 25,
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CallScreen(call: call)),
                  ),
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
