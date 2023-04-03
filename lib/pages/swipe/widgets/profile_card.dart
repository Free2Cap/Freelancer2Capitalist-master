import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/models/UIHelper.dart';
import '../model/profile.dart';
import 'dart:developer';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.profile, required this.userType})
      : super(key: key);
  final dynamic profile;
  final String userType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 510,
      width: 310,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => dynamicInformatoinViewer(
            infoType: userType,
            uid: profile!.uid,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  userType == 'Investor'
                      ? profile!.projectImages
                      : profile!.firmImages,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
           Positioned(
  bottom: 0,
  child: Container(
    height: 200,
    width: 310,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.purple,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userType == 'Investor'
                ? 'Aim: ${profile!.aim}'
                : 'Name: ${profile!.name}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 21,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Budget: \u{20B9}${profile!.budgetStart} - \u{20B9}${profile!.budgetEnd}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userType == 'Investor'
                ? 'Objective: ${profile!.objective}'
                : 'Mission: ${profile!.mission}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Field: ${profile!.field}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Creator: ${profile!.creator}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
