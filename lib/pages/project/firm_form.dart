import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:freelancer2capitalist/models/firm_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../models/UIHelper.dart';

class FirmForm extends StatefulWidget {
  const FirmForm({super.key});

  @override
  State<FirmForm> createState() => _FirmFormState();
}

class _FirmFormState extends State<FirmForm> {
  final TextEditingController company_name = TextEditingController();
  final TextEditingController company_background = TextEditingController();
  final TextEditingController company_age = TextEditingController();
  final TextEditingController company_mission = TextEditingController();
  RangeValues _budgetRangeValues = const RangeValues(0, 10000);
  String dropdownValue = 'Select a field';
  XFile? _selectedImage;
  static FirmModel? firm = FirmModel();

  Future<String> _getDataUrl(XFile image) async {
    final bytes = await image.readAsBytes();
    return Uri.dataFromBytes(bytes, mimeType: 'image/jpeg').toString();
  }

  void checkValues() async {
    String name = company_name.text.trim();
    String background = company_background.text.trim();
    String age = company_age.text.trim();
    String field = dropdownValue.trim();
    String mission = company_mission.text.trim();

    if (name.isEmpty ||
        background.isEmpty ||
        age.isEmpty ||
        field.isEmpty ||
        _selectedImage == null) {
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

    uploadData(name, background, age, field, mission);
  }

  void uploadData(
    String name,
    String background,
    String age,
    String field,
    String mission,
  ) async {
    UIHelper.showLoadingDialog(context, "Updating Firm Information...");

    double budgetStart = _budgetRangeValues.start.roundToDouble();
    double budgetEnd = _budgetRangeValues.end.roundToDouble();
    String imageUrl = '';
    File selectedImage = File(_selectedImage!.path);
    String uid = uuid.v1();

    // Upload the images to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid; // log(userId);
    Reference ref = storage.ref().child("firm_images/$uid.jpg");
    try {
      UploadTask uploadTask = ref.putFile(selectedImage);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log(e.toString());
    }

    FirmModel firmModel = FirmModel(
      uid: userId,
      mission: mission,
      background: background,
      age: age,
      name: name,
      field: field,
      budgetStart: budgetStart,
      budgetEnd: budgetEnd,
      firmImage: imageUrl,
    );
    try {
      await FirebaseFirestore.instance
          .collection("firm")
          .doc(userId)
          .set(firmModel.toMap());
    } on FirebaseException catch (ex) {
      log(ex.toString());
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<FirmModel?> getFirm(String uid) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('firm').doc(uid).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return FirmModel.fromMap(data)..uid = uid;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    String dropdownValue = 'Select a field';
    getFirm(FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        firm = value;
        if (firm != null) {
          company_name.text = firm!.name.toString();
          company_age.text = firm!.age.toString();
          company_background.text = firm!.background.toString();
          company_mission.text = firm!.mission.toString();
          _budgetRangeValues =
              RangeValues(firm!.budgetStart!, firm!.budgetEnd!);
          dropdownValue = firm!.field.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Firm", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 184, 4, 208), // purple color
        iconTheme: IconThemeData(
            color: Colors
                .white), // set the color of the icons in the app bar to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: null,
                controller: company_name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: company_background,
                decoration: InputDecoration(
                  labelText: 'Background',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: company_mission,
                decoration: InputDecoration(
                  labelText: 'Mission',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                controller: company_age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'How many years old is your Firm',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PopupMenuButton<String>(
                initialValue: dropdownValue,
                onSelected: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Science',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Science'),
                        Icon(Icons.science),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Technology',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Technology'),
                        Icon(Icons.computer),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Engineering',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Engineering'),
                        Icon(Icons.engineering),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Mathematics',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mathematics'),
                        Icon(Icons.calculate),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dropdownValue,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your budget',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u{20B9}0',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.grey[300],
                          ),
                          child: RangeSlider(
                            values: _budgetRangeValues,
                            min: 0,
                            max: 10000,
                            divisions: 100,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Colors.grey[400],
                            onChanged: (RangeValues values) {
                              setState(() {
                                _budgetRangeValues = values;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        '\u{20B9}10K',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u{20B9}${_budgetRangeValues.start.round()}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\u{20B9}${_budgetRangeValues.end.round()}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  XFile? result = await ImagePicker().pickImage(
                    imageQuality: 30,
                    source: ImageSource.gallery,
                  );
                  if (result != null) {
                    setState(() {
                      _selectedImage = result;
                    });
                  } else {
                    const snackdemo = SnackBar(
                      content: Text('Please select an image'),
                      backgroundColor: Colors.pinkAccent,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  }
                },
                icon: Icon(Icons.image_outlined),
                label: Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_selectedImage != null)
                kIsWeb
                    ? FutureBuilder<String>(
                        future: _getDataUrl(_selectedImage!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.network(
                              snapshot.data!,
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // set width to screen width
                              height: MediaQuery.of(context).size.height /
                                  2, // set height to half of screen height
                              fit: BoxFit
                                  .contain, // set fit to contain, which will resize the image to fit within the frame
                            );
                          } else {
                            return const Placeholder();
                          }
                        },
                      )
                    : Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  checkValues();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20), // set the font size to 20
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 184, 4, 208),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(300, 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
