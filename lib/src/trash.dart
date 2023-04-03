// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class Complete_Profile extends StatefulWidget {
//   @override
//   _Complete_ProfileState createState() => _Complete_ProfileState();
// }

// class _Complete_ProfileState extends State<Complete_Profile> {
//   File? pickedFile;
//   ImagePicker imagePicker = ImagePicker();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? _name;
//   String? _surname;
//   int? _age;
//   String? _gender;
//   String? _choice;
//   String? _phoneNumber;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[50],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Card(
//               margin: const EdgeInsets.all(24),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: <Widget>[
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 80,
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             child: InkWell(
//                               child: Icon(Icons.camera),
//                               onTap: () {
//                                 showModalBottomSheet(
//                                     context: context,
//                                     builder: (context) => bottomSheet(context));
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your name';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _name = value!,
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Surname',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your surname';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _surname = value!,
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Age',
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your age';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _age = int.parse(value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Male'),
//                         value: 'Male',
//                         groupValue: _gender,
//                         onChanged: (value) => setState(() => _gender = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Female'),
//                         value: 'Female',
//                         groupValue: _gender,
//                         onChanged: (value) => setState(() => _gender = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Other'),
//                         value: 'Other',
//                         groupValue: _gender,
//                         onChanged: (value) => setState(() => _gender = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Investor'),
//                         value: 'Investor',
//                         groupValue: _choice,
//                         onChanged: (value) => setState(() => _choice = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Freelancer'),
//                         value: 'Freelancer',
//                         groupValue: _choice,
//                         onChanged: (value) => setState(
//                           () => _choice = value!,
//                         ),
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Phone Number',
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter your phone number';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _phoneNumber = value!,
//                       ),
//                       ElevatedButton(
//                         child: const Text('Submit'),
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             _formKey.currentState!.save();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget bottomSheet(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Container(
//       width: double.infinity,
//       height: size.height * 0.3,
//       child: Column(
//         children: [
//           Text("Choose Profile Photo"),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               InkWell(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.image),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("Gallery"),
//                   ],
//                 ),
//                 onTap: () {
//                   takePhoto(ImageSource.gallery);
//                 },
//               ),
//               SizedBox(
//                 width: 80,
//               ),
//               InkWell(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.camera),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("Camera"),
//                   ],
//                 ),
//                 onTap: () {
//                   takePhoto(ImageSource.camera);
//                 },
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void takePhoto(ImageSource source) async {
//     final pickedImage =
//         await imagePicker.pickImage(source: source, imageQuality: 100);

//     pickedFile = File(pickedImage!.path);
//     print(pickedFile);
//   }
// }

  // Container(
            //   height: 150,
            //   child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            // ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
            //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   alignment: Alignment.center,
            //   child: Column(
            //     children: [
            //       Form(
            //         key: _formKey,
            //         child: Column(
            //           children: [
            //             GestureDetector(
            //               child: Stack(
            //                 children: [
            //                   Container(
            //                     padding: EdgeInsets.all(10),
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(100),
            //                       border: Border.all(
            //                           width: 5, color: Colors.white),
            //                       color: Colors.white,
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.black12,
            //                           blurRadius: 20,
            //                           offset: const Offset(5, 5),
            //                         ),
            //                       ],
            //                     ),
            //                     child: Icon(
            //                       Icons.person,
            //                       color: Colors.grey.shade300,
            //                       size: 80.0,
            //                     ),
            //                   ),
            //                   Container(
            //                     padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
            //                     child: Icon(
            //                       Icons.add_circle,
            //                       color: Colors.grey.shade700,
            //                       size: 25.0,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             SizedBox(height: 30,),
            //             Container(
            //               child: TextFormField(
            //                 decoration: ThemeHelper().textInputDecoration('Name', 'Enter your first name'),
            //               ),
            //               decoration: ThemeHelper().inputBoxDecorationShaddow(),
            //             ),
                      
            //             SizedBox(height: 20.0),
                        // Container(
                        //   child: TextFormField(
                        //     decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
                        //     keyboardType: TextInputType.emailAddress,
                        //     validator: (val) {
                        //       if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                        //         return "Enter a valid email address";
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                        // SizedBox(height: 20.0),
                        // Container(
                        //   child: TextFormField(
                        //     decoration: ThemeHelper().textInputDecoration(
                        //         "Mobile Number",
                        //         "Enter your mobile number"),
                        //     keyboardType: TextInputType.phone,
                        //     validator: (val) {
                        //       if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                        //         return "Enter a valid phone number";
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                             // SizedBox(height: 15.0),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Checkbox(
                        //                 value: checkboxValue,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     checkboxValue = value!;
                        //                     state.didChange(value);
                        //                   });
                        //                 }),
                        //             Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'You need to accept terms and conditions';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                          // SizedBox(height: 30.0),
                        // Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                        // SizedBox(height: 25.0),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     GestureDetector(
                        //       child: FaIcon(
                        //         FontAwesomeIcons.googlePlus, size: 35,
                        //         color: HexColor("#EC2D2F"),),
                        //       onTap: () {
                        //         setState(() {
                        //           showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return ThemeHelper().alartDialog("Google Plus","You tap on GooglePlus social icon.",context);
                        //             },
                        //           );
                        //         });
                        //       },
                        //     ),
                        //     SizedBox(width: 30.0,),
                        //     GestureDetector(
                        //       child: Container(
                        //         padding: EdgeInsets.all(0),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(100),
                        //           border: Border.all(width: 5, color: HexColor("#40ABF0")),
                        //           color: HexColor("#40ABF0"),
                        //         ),
                        //         child: FaIcon(
                        //           FontAwesomeIcons.twitter, size: 23,
                        //           color: HexColor("#FFFFFF"),),
                        //       ),
                        //       onTap: () {
                        //         setState(() {
                        //           showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return ThemeHelper().alartDialog("Twitter","You tap on Twitter social icon.",context);
                        //             },
                        //           );
                        //         });
                        //       },
                        //     ),
                        //     SizedBox(width: 30.0,),
                        //     GestureDetector(
                        //       child: FaIcon(
                        //         FontAwesomeIcons.facebook, size: 35,
                        //         color: HexColor("#3E529C"),),
                        //       onTap: () {
                        //         setState(() {
                        //           showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return ThemeHelper().alartDialog("Facebook",
                        //                   "You tap on Facebook social icon.",
                        //                   context);
                        //             },
                        //           );
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 15.0),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Checkbox(
                        //                 value: checkboxValue,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     checkboxValue = value!;
                        //                     state.didChange(value);
                        //                   });
                        //                 }),
                        //             const Text(
                        //               "I accept all terms and conditions.",
                        //               style: TextStyle(color: Colors.grey),
                        //             ),
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color:
                        //                   Theme.of(context).colorScheme.error,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'You need to accept terms and conditions';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
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
  // EmailOTP myAuth = EmailOTP();
// SizedBox(height: 20.0),
                        // Container(
                        //   child: TextFormField(
                        //     decoration: ThemeHelper().textInputDecoration(
                        //         "Mobile Number",
                        //         "Enter your mobile number"),
                        //     keyboardType: TextInputType.phone,
                        //     validator: (val) {
                        //       if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                        //         return "Enter a valid phone number";
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                        //sendOtp(emailController.text);
                        // GestureDetector(
                        //   child: Stack(
                        //     children: [
                        //       Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(100),
                        //           border:
                        //               Border.all(width: 5, color: Colors.white),
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             const BoxShadow(
                        //               color: Colors.black12,
                        //               blurRadius: 20,
                        //               offset: Offset(5, 5),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Icon(
                        //           Icons.person,
                        //           color: Colors.grey.shade300,
                        //           size: 80.0,
                        //         ),
                        //       ),
                        //       Container(
                        //         padding:
                        //             const EdgeInsets.fromLTRB(80, 80, 0, 0),
                        //         child: Icon(
                        //           Icons.add_circle,
                        //           color: Colors.grey.shade700,
                        //           size: 25.0,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Container(
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        //   child: TextFormField(
                        //     decoration: ThemeHelper().textInputDecoration(
                        //       'Name',
                        //       'Enter your first name',
                        //     ),
                        //   ),
                        // ),