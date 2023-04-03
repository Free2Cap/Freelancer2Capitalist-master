import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancer2capitalist/main.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/UIHelper.dart';
import '../../models/project_model.dart';
import '../../models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:mime/mime.dart';

class ProjectForm extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String? projectId;

  const ProjectForm(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      this.projectId});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  static ProjectModel? project;
  final TextEditingController aimController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController scopeController = TextEditingController();
  final TextEditingController fieldController = TextEditingController();
  final TextEditingController feasibilityController = TextEditingController();
  List<XFile> _selectedImages = [];
  String dropdownValue = 'Select a field';
  RangeValues _budgetRangeValues = const RangeValues(0, 10000);

  void checkValues() async {
    String aim = aimController.text.trim();
    String objective = objectiveController.text.trim();
    String scope = scopeController.text.trim();
    String field = dropdownValue.trim();
    String feasibility = feasibilityController.text.trim();

    if (aim.isEmpty ||
        objective.isEmpty ||
        scope.isEmpty ||
        field.isEmpty ||
        feasibility.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields and select images'),
          backgroundColor: Colors.pinkAccent,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
        ),
      );
      return;
    }

    // log('$aim \n $objective \n $scope \n $field \n $feasibility \n ${_budgetRangeValues.start.roundToDouble()} \n ${_budgetRangeValues.end.roundToDouble()}');
    // All fields are filled, so upload the data
    uploadData(aim, objective, scope, field, feasibility);
  }

  void uploadData(
    String aim,
    String objective,
    String scope,
    String field,
    String feasibility,
  ) async {
    UIHelper.showLoadingDialog(context, "Adding Project Information...");

    double budgetStart = _budgetRangeValues.start.roundToDouble();
    double budgetEnd = _budgetRangeValues.end.roundToDouble();
    List<File> images =
        _selectedImages.map((image) => File(image.path)).toList();
    List<String> imagesUrl = [];

    // Upload the images to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid; // log(userId);

    for (int i = 0; i < images.length; i++) {
      File imageFile = images[i];
      String imageName = 'image_$i.jpg';
      String imagePath = 'projectpictures/${userId + aim}/$imageName';
      UploadTask uploadTask = storage.ref().child(imagePath).putFile(imageFile);
      await uploadTask;
      String imageUrl = await storage.ref().child(imagePath).getDownloadURL();
      imagesUrl.add(imageUrl);
    }
    String uid = uuid.v1();
    ProjectModel projectModel = ProjectModel(
      uid: uid,
      aim: aim,
      scope: scope,
      creator: userId,
      objective: objective,
      field: field,
      feasiility: feasibility,
      budgetStart: budgetStart,
      budgetEnd: budgetEnd,
      projectImages: imagesUrl,
    );
    try {
      await FirebaseFirestore.instance
          .collection("projects")
          .doc(uid)
          .set(projectModel.toMap());
    } on FirebaseException catch (ex) {
      log(ex.toString());
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<ProjectModel> getProject(String uid) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('projects').doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return ProjectModel.fromMap(data)..uid = uid;
    } else {
      throw Exception('No project found with uid $uid');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      getProject(widget.projectId!.toString()).then((value) {
        setState(() {
          project = value;
        });
        aimController.text = project!.aim.toString();
        scopeController.text = project!.scope.toString();
        objectiveController.text = project!.objective.toString();
        feasibilityController.text = project!.feasiility.toString();
        _budgetRangeValues =
            RangeValues(project!.budgetStart!, project!.budgetEnd!);
        dropdownValue = project!.field.toString();
        // int numImagesFetched = 0;
        // for (final imageName in project!.projectImages!) {
        //   _fetchImage(imageName).then((_) {
        //     numImagesFetched++;
        //     if (numImagesFetched == project!.projectImages!.length) {
        //       setState(() {});
        //     }
        //   });
        // }
      }).catchError((error) {
        log(error.toString());
      });
    }
  }

  // Future<void> _fetchImage(String imageName) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref().child(imageName);
  //     final tempDir = await getTemporaryDirectory();
  //     final tempFile = File('${tempDir.path}/$imageName');
  //     await ref.writeToFile(tempFile);

  //     setState(() {
  //       _selectedImages.add(XFile(tempFile.path));
  //     });
  //   } catch (e) {
  //     log('Error fetching image: $imageName');
  //     log(e.toString());
  //   }
  // }

  Future<String> _getDataUrl(XFile file) async {
    const mime = 'image/jpeg';
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);
    return 'data:$mime;base64,$base64';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: null,
                controller: aimController,
                decoration: const InputDecoration(
                  labelText: 'Aim',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: objectiveController,
                decoration: const InputDecoration(
                  labelText: 'Objective',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: scopeController,
                decoration: const InputDecoration(
                  labelText: 'Scope',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'Select a field',
                  'Science',
                  'Technology',
                  'Engineering',
                  'Mathematics'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: feasibilityController,
                decoration: const InputDecoration(
                  labelText: 'Feasibility',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Your Budget'),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\u{20B9}${_budgetRangeValues.start.round()}',
                    style: TextStyle(color: Theme.of(context).indicatorColor),
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _budgetRangeValues,
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.black.withOpacity(0.5),
                      labels: RangeLabels(
                        '\u{20B9}${_budgetRangeValues.start.round().toString()}',
                        '\u{20B9}${_budgetRangeValues.end.round().toString()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _budgetRangeValues = values;
                        });
                      },
                    ),
                  ),
                  Text(
                    '\u{20B9}${_budgetRangeValues.end.round()}',
                    style: TextStyle(color: Theme.of(context).indicatorColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  List<XFile>? result = await ImagePicker().pickMultiImage(
                    imageQuality: 30,
                  );
                  if (result != null && result.length <= 5) {
                    setState(() {
                      _selectedImages = result;
                    });
                  } else {
                    const snackdemo = SnackBar(
                      content: Text('Please select 5 or less images'),
                      backgroundColor: Colors.pinkAccent,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  }
                },
                child: const Text('Select Images'),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return kIsWeb
                        ? FutureBuilder<String>(
                            future:
                                _getDataUrl(XFile(_selectedImages[index].path)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return const Placeholder();
                              }
                            },
                          )
                        : Image.file(
                            File(_selectedImages[index].path),
                            fit: BoxFit.cover,
                          );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  checkValues();
                  // UIHelper.showAlertDialog(
                  //     context, 'Submitting Project', "Work in progress");
                }, //checkValues(),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
