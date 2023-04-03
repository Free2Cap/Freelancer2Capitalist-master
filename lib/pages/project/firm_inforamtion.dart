import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/pages/project/firm_form.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/firm_model.dart';
import '../widgets/header_widget.dart';

class FirmInformation extends StatefulWidget {
  const FirmInformation({super.key});

  @override
  State<FirmInformation> createState() => _FirmInformationState();
}

class _FirmInformationState extends State<FirmInformation> {
  TextEditingController firmImage = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   final documentSnapshot =
  //       await FirebaseFirestore.instance.collection('firm').doc(userId).get();
  //   if (documentSnapshot.exists) {
  //     setState(() {
  //       firmModel = FirmModel.fromMap(documentSnapshot.data()!);
  //       firmImage.text = firmModel.firmImage!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Firm Information",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            InkWell(
              child: const Icon(Icons.business, color: Colors.white),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirmForm()),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection('firm')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                DocumentSnapshot firmModel = snapshot.data as DocumentSnapshot;

                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      const SizedBox(
                        height: 100,
                        child: HeaderWidget(100, false, Icons.house_rounded),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 40,
                                  child: firmModel['firmImage'] != ''
                                      ? FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: firmModel['firmImage'],
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.grey.shade300,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              firmModel['name'] ?? '',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              firmModel['mission'] ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "Firm Information",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Card(
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              ...ListTile.divideTiles(
                                                color: Colors.grey,
                                                tiles: [
                                                  ListTile(
                                                    leading:
                                                        const Icon(Icons.email),
                                                    title: const Text("About"),
                                                    subtitle: Text(firmModel[
                                                            'background'] ??
                                                        ''),
                                                  ),
                                                  ListTile(
                                                    leading:
                                                        const Icon(Icons.phone),
                                                    title: const Text("Budget"),
                                                    subtitle: Text(
                                                        "from \u{20B9}${firmModel['budgetStart'] ?? 'NA'} to \u{20B9}${firmModel['budgetEnd'] ?? 'NA'}"),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.person),
                                                    title: const Text("Field"),
                                                    subtitle: Text(
                                                        firmModel['field'] ??
                                                            ''),
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 12,
                                                            vertical: 4),
                                                    leading: const Icon(
                                                        Icons.person_outlined),
                                                    title:
                                                        const Text("Firm Age"),
                                                    subtitle: Text(
                                                        '${firmModel['age'] ?? ''} years'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else {
              return const Text('Stream closed');
            }
          }),
    );
  }
}
