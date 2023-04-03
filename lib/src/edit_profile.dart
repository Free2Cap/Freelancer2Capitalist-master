// import 'dart:developer';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:freelancer2capitalist/pages/profile_page.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import '../models/user_model.dart';

// class CompleteProfile extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   const CompleteProfile(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<CompleteProfile> createState() => _CompleteProfileState();
// }

// class _CompleteProfileState extends State<CompleteProfile> {
//   File? imageFile;
//   TextEditingController fullNameController = TextEditingController();
//   String? gender;
//   String? userType;

//   void selectImage(ImageSource source) async {
//     XFile? pickedFile = await ImagePicker().pickImage(source: source);

//     if (pickedFile != null) {
//       cropImage(pickedFile);
//     }
//   }

//   void cropImage(XFile file) async {
//     CroppedFile? croppedImage = await ImageCropper().cropImage(
//       sourcePath: file.path,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: 10,
//     );

//     if (croppedImage != null) {
//       setState(() {
//         imageFile = File(croppedImage.path);
//       });
//     }
//   }

//   void showPhotoOptions() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("upload profile picture"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 onTap: () {
//                   Navigator.pop(context);
//                   selectImage(ImageSource.gallery);
//                 },
//                 leading: const Icon(Icons.photo_album),
//                 title: const Text("Select from gallery"),
//               ),
//               ListTile(
//                 onTap: () {
//                   Navigator.pop(context);
//                   selectImage(ImageSource.camera);
//                 },
//                 leading: const Icon(Icons.camera),
//                 title: const Text("Take a Photo"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void checkValues() {
//     String fullname = fullNameController.text.trim();
//     if (fullname == "" || imageFile == null) {
//       const snackdemo = SnackBar(
//         content: Text('please fill all the fields'),
//         backgroundColor: Colors.pinkAccent,
//         elevation: 10,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(5),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackdemo);
//       log("please fill all the fields");
//     } else {
//       uploadData();
//     }
//   }

//   void uploadData() async {
//     UploadTask uploadTask = FirebaseStorage.instance
//         .ref("profilepictures")
//         .child(widget.userModel.uid.toString())
//         .putFile(imageFile!);

//     TaskSnapshot snapshot = await uploadTask;

//     String imageUrl = await snapshot.ref.getDownloadURL();
//     String fullname = fullNameController.text.trim();
//     String bio = '';
//     String location = '';

//     widget.userModel.fullname = fullname;
//     widget.userModel.profilepic = imageUrl;
//     widget.userModel.bio = bio;
//     widget.userModel.location = location;
//     widget.userModel.gender = gender;
//     widget.userModel.userType = userType;

//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(widget.userModel.uid)
//         .set(widget.userModel.toMap())
//         .then((value) {
//       log("Data Uploaded");
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return ProfilePage(
//             usermodel: widget.userModel, firebaseUser: widget.firebaseUser);
//       }));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//       title: const Text("Complete Profile"),
//     ),
//     body: SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child: ListView(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             CupertinoButton(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage:
//                     (imageFile != null) ? FileImage(imageFile!) : null,
//                 child: (imageFile == null)
//                     ? const Icon(
//                         Icons.person,
//                         size: 60,
//                       )
//                     : null,
//               ),
//               onPressed: () {
//                 showPhotoOptions();
//               },
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: fullNameController,
//               decoration: const InputDecoration(
//                 labelText: "Full Name",
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Gender"),
//                 Row(
//                   children: [
//                     Radio<String>(
//                       value: "Male",
//                       groupValue: gender,
//                       onChanged: (value) {
//                         setState(() {
//                           gender = value;
//                         });
//                       },
//                     ),
//                     const Text("Male"),
//                     Radio<String>(
//                       value: "Female",
//                       groupValue: gender,
//                       onChanged: (value) {
//                         setState(() {
//                           gender = value;
//                         });
//                       },
//                     ),
//                     const Text("Female"),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("User Type"),
//                 Row(
//                   children: [
//                     Radio<String>(
//                       value: "Investor",
//                       groupValue: userType,
//                       onChanged: (value) {
//                         setState(() {
//                           userType = value;
//                         });
//                       },
//                     ),
//                     const Text("Investor"),
//                     Radio<String>(
//                       value: "Freelancer",
//                       groupValue: userType,
//                       onChanged: (value) {
//                         setState(() {
//                           userType = value;
//                         });
//                       },
//                     ),
//                     const Text("Freelancer"),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             CupertinoButton(
//               child: const Text("Submit"),
//               onPressed: () {
//                 checkValues();
//               },
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
