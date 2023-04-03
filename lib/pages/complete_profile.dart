import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/pages/profile_page.dart';

import 'package:freelancer2capitalist/common/theme_helper.dart';

import 'package:freelancer2capitalist/pages/widgets/genderRadio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:freelancer2capitalist/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/UIHelper.dart';
import '../models/user_model.dart';
import 'navigator/widgets/curved_navigation.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? selectedGender;
  String? selectedUserType;

  @override
  void initState() {
    super.initState();
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload profile picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera),
                title: const Text("Take a photo"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> fetchImage(String imageUrl) async {
  //   // Get reference to the Firebase storage file
  //   final ref = FirebaseStorage.instance.ref().child(imageUrl);
  //   // Download the image and store it in a temporary file
  //   final bytes = await ref.getData();
  //   final tempFile = File('${(await getTemporaryDirectory()).path}/image.jpg');
  //   await tempFile.writeAsBytes(bytes!);
  //   setState(() {
  //     // Assign the temporary file to the _imageFile variable
  //     imageFile = tempFile;
  //   });
  // }

  void checkValues() async {
    String fullName = fullNameController.text.trim();
    String bio = bioController.text.trim();
    String? gender = selectedGender;
    String? userType = selectedUserType;
    // if (widget.userModel.profilepic != '') {
    //   fetchImage(widget.userModel.profilepic.toString());
    // }
    if (fullName.isEmpty ||
        // imageFile == null ||
        gender == null ||
        userType == null) {
      const snackdemo = SnackBar(
        content: Text('Please fill all the fields'),
        backgroundColor: Colors.pinkAccent,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
      log("Please fill all the fields");
    } else {
      uploadData(fullName, bio, gender, userType);
    }
  }

  void uploadData(
      String fullName, String bio, String gender, String userType) async {
    UIHelper.showLoadingDialog(context, "Registering...");
    String imageUrl = '';
    if (imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    widget.userModel.fullname = fullName;
    widget.userModel.profilepic =
        (widget.userModel.profilepic != '' && imageFile == null)
            ? widget.userModel.profilepic.toString()
            : imageUrl;
    widget.userModel.gender = gender;
    widget.userModel.userType = userType;
    widget.userModel.bio = bio;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CurveNavigationWidget(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 300;
    if (widget.userModel.fullname != "") {
      fullNameController.text = widget.userModel.fullname.toString();
    }
    if (widget.userModel.bio != "") {
      bioController.text = widget.userModel.bio.toString();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.account_circle,
            //   size: 32,
            //   color: Colors.white,
            // ),
            SizedBox(width: 8),
            Text(
              "Complete Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              CupertinoButton(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: (imageFile != null)
                          ? FileImage(imageFile!)
                          : (widget.userModel.profilepic != "")
                              ? NetworkImage(
                                  widget.userModel.profilepic.toString())
                              : null as ImageProvider<Object>?,
                      child: (imageFile == null &&
                              widget.userModel.profilepic == "")
                          ? const Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(1.0),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey[800],
                          ),
                          onPressed: () {
                            showPhotoOptions();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showPhotoOptions();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: Icon(Icons.person),
                          counterText:
                              '${fullNameController.text.length} characters',
                          counterStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GenderRadioGroup(
                                  defaultValue: widget.userModel.gender != ''
                                      ? widget.userModel.gender.toString()
                                      : null,
                                  value1: "Male",
                                  value2: "Female",
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "User Type",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Investor",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "I want to invest in projects",
                                  style: TextStyle(fontSize: 14),
                                ),
                                leading: Icon(
                                  Icons.attach_money,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedUserType = "Investor";
                                  });
                                },
                                selected: selectedUserType == "Investor",
                                selectedTileColor: Colors.grey[200],
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[400],
                              ),
                              ListTile(
                                title: Text(
                                  "Freelancer",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "I am a freelancer looking for work",
                                  style: TextStyle(fontSize: 14),
                                ),
                                leading: Icon(
                                  Icons.computer,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedUserType = "Freelancer";
                                  });
                                },
                                selected: selectedUserType == "Freelancer",
                                selectedTileColor: Colors.grey[200],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: bioController,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          hintText: 'Write something about yourself',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: Icon(Icons.description),
                          counterText:
                              '${bioController.text.length} characters',
                          counterStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        maxLength: 100,
                        maxLines: 3,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: false,
                        onChanged: (value) {
                          print('Bio changed to: $value');
                        },
                        onSubmitted: (value) {
                          print('Bio submitted: $value');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 184, 4, 208),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(100, 50),
                  ),
                ),
                onPressed: () {
                  checkValues();
                },
                child: SizedBox(
                  height: 30,
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
