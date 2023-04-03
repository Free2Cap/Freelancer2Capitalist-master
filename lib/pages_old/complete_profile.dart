import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/pages_old/complete_profile.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

enum userTypeEnum { Freelancer, Investor }

enum genderEnum { Male, Female, Other }

class Complete_Profile extends StatefulWidget {
  const Complete_Profile({super.key});

  @override
  State<Complete_Profile> createState() => _Complete_ProfileState();
}

class _Complete_ProfileState extends State<Complete_Profile> {
  userTypeEnum? _userTypeEnum;
  genderEnum? _genderEnum;
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _surnameController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                children: <Widget>[
                  Text(errorText),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          const Text("Complete Profile"),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: "Enter your Name",
                              labelText: "Name",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _surnameController,
                            decoration: const InputDecoration(
                              hintText: "Enter your Surname",
                              labelText: "Surname",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: "Enter your Phone Number",
                              labelText: "Ph. No.",
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              const Text("Gender"),
                              Expanded(
                                child: RadioListTile(
                                    value: genderEnum.Male,
                                    groupValue: _genderEnum,
                                    title: Text(genderEnum.Male.name),
                                    onChanged: (value) {
                                      setState(() {
                                        _genderEnum = value;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                    value: genderEnum.Female,
                                    groupValue: _genderEnum,
                                    title: Text(genderEnum.Female.name),
                                    onChanged: (value) {
                                      setState(() {
                                        _genderEnum = value;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                    value: genderEnum.Other,
                                    groupValue: _genderEnum,
                                    title: Text(genderEnum.Other.name),
                                    onChanged: (value) {
                                      setState(() {
                                        _genderEnum = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              const Text("User Type:"),
                              Expanded(
                                child: RadioListTile<userTypeEnum>(
                                    value: userTypeEnum.Freelancer,
                                    groupValue: _userTypeEnum,
                                    title: Text(userTypeEnum.Freelancer.name),
                                    onChanged: (val) {
                                      setState(() {
                                        _userTypeEnum = val;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile<userTypeEnum>(
                                    value: userTypeEnum.Investor,
                                    groupValue: _userTypeEnum,
                                    title: Text(userTypeEnum.Investor.name),
                                    onChanged: (val) {
                                      setState(() {
                                        _userTypeEnum = val;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
