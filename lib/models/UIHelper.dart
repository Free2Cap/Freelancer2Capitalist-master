import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/models/project_model.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 30,
            ),
            Text(title),
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"))
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  static void showConfirmationAlertDialog(BuildContext context, String title,
      String content, Function(bool) onConfirmed) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmed(true);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmed(false);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          child: const Text(
            "No",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}

class ProjectDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsDialog({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Objective: ${project['objective'] ?? ''}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Scope: ${project['scope'] ?? ''}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Budget Range: ${(project['budgetStart']?.toStringAsFixed(2) ?? '')} - ${(project['budgetEnd']?.toStringAsFixed(2) ?? '')}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Field: ${project['field'] ?? ''}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Feasibility: ${project['feasibility'] ?? ''}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Images:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: project["projectImages"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      project["projectImages"][index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class dynamicInformatoinViewer extends StatelessWidget {
  const dynamicInformatoinViewer(
      {Key? key, required this.uid, required this.infoType})
      : super(key: key);

  final String uid;
  final String infoType;

  Future<Map<String, dynamic>> _getInfo(String userType) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      if (userType == "Freelancer") {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('firm').doc(uid).get();
        return snapshot.data() ?? {};
      } else {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('projects').doc(uid).get();
        return snapshot.data() ?? {};
      }
    } catch (e) {
      log('Error getting information: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getInfo(infoType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Map<String, dynamic> information = snapshot.data!;
          return Dialog(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infoType == 'Investor'
                          ? 'Aim: ${information['aim'] ?? ''}'
                          : 'Name: ${information['name'] ?? ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      infoType == 'Investor'
                          ? 'Objective: ${information['objective'] ?? ''}'
                          : 'Background: ${information['background'] ?? ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      infoType == 'Investor'
                          ? 'Scope: ${information['scope'] ?? ''}'
                          : 'Mission: ${information['mission'] ?? ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Budget Range: \u{20B9}${(information['budgetStart']?.toStringAsFixed(2) ?? '')} - \u{20B9}${(information['budgetEnd']?.toStringAsFixed(2) ?? '')}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Field: ${information['field'] ?? ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    if (infoType == 'Investor')
                      Text(
                        'Feasibility: ${information['feasiility'] ?? ''}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Images:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    if (infoType == 'Investor')
                      SizedBox(
                        height: information["projectImages"].length <= 3
                            ? 90
                            : 180, // set the height dynamically
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: information["projectImages"].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              information["projectImages"][index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    else
                      SizedBox(
                        height: 90,
                        child: Image.network(
                          information["firmImage"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error getting information'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
