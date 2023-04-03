import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/models/user_model.dart';
import 'package:freelancer2capitalist/pages/chat_pages/widgets/chat_helper.dart';
import '../../../models/FirebaseHelper.dart';
import '../../../models/UIHelper.dart';
import '../../../models/chat_room_model.dart';
import '../model/profile.dart';
import '../swipe.dart';
import 'action_button_widget.dart';
import 'drag_widget.dart';

class CardsStackWidget extends StatefulWidget {
  final String userType;
  const CardsStackWidget({Key? key, required this.userType}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  List<dynamic> draggableItems = [];

  void _createUserTargetChatRoom(String targetUid) async {
    try {
      ChatHelper chatHelper = ChatHelper();
      String user = FirebaseAuth.instance.currentUser!.uid;
      UserModel? currentUserModel = await FirebaseHelper.getUserModelById(user);
      UserModel? targetUserModel =
          await FirebaseHelper.getUserModelById(targetUid);
      // log('current:${currentUserModel?.fullname.toString()} \n target:${targetUserModel?.fullname.toString()} \n uid:${draggableItems.last.creatorUid}');
      await chatHelper.getChatRoomModel(targetUserModel!, currentUserModel!);
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  Future<List<dynamic>> _getInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userType = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((doc) => doc.get('userType'));

    if (userType == 'Freelancer') {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('firm')
          .where('uid', isNotEqualTo: user.uid)
          .get();

      final results = await Future.wait(querySnapshot.docs.map((doc) async {
        String uid = doc.get('uid').toString();
        final firebaseFirestore =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        return Firm(
          uid: doc.get('uid'),
          name: doc.get('name'),
          mission: doc.get('mission'),
          budgetStart: doc.get('budgetStart').toString(),
          budgetEnd: doc.get('budgetEnd').toString(),
          field: doc.get('field'),
          firmImages: doc.get('firmImage'),
          creator: firebaseFirestore.get('fullname'),
          creatorUid: doc.get('uid'),
        );
      }));

      return results;
    } else if (userType == 'Investor') {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('creator', isNotEqualTo: user.uid)
          .get();

      final results = await Future.wait(querySnapshot.docs.map((doc) async {
        String uid = doc.get('creator').toString();
        final firebaseFirestore =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        return Project(
          uid: doc.get('uid'),
          aim: doc.get('aim'),
          objective: doc.get('objective'),
          budgetStart: doc.get('budgetStart').toString(),
          budgetEnd: doc.get('budgetEnd').toString(),
          field: doc.get('field'),
          projectImages: (doc.get('projectImages') as List<dynamic>)[0],
          creator: firebaseFirestore.get('fullname'),
          creatorUid: uid,
        );
      }));

      return results;
    }

    return []; // default empty result if userType is neither Freelancer nor Investor
  }

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _getInfo().then((value) {
      setState(() {
        draggableItems = value;
      });
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        try {
          draggableItems.removeLast();
        } on RangeError catch (e) {
          log(e.toString());
          UIHelper.showAlertDialog(context, 'End', 'No more slides');
        }

        swipeNotifier.value = Swipe.none;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(draggableItems.length, (index) {
                if (index == draggableItems.length - 1) {
                  return PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromSize(
                          const Rect.fromLTWH(0, 0, 300, 200),
                          const Size(300, 200)),
                      end: RelativeRect.fromSize(
                        Rect.fromLTWH(
                            swipe != Swipe.none
                                ? swipe == Swipe.left
                                    ? -150
                                    : 150
                                : 0,
                            0,
                            300,
                            200),
                        const Size(300, 200),
                      ),
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    )),
                    child: RotationTransition(
                      turns: Tween<double>(
                              begin: 0,
                              end: swipe != Swipe.none
                                  ? swipe == Swipe.left
                                      ? -0.1 * 0.3
                                      : 0.1 * 0.3
                                  : 0.0)
                          .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0, 0.4, curve: Curves.easeInOut),
                        ),
                      ),
                      child: DragWidget(
                        profile: draggableItems[index],
                        index: index,
                        swipeNotifier: swipeNotifier,
                        isLastCard: true,
                        userType: widget.userType,
                      ),
                    ),
                  );
                } else {
                  return DragWidget(
                    profile: draggableItems[index],
                    index: index,
                    swipeNotifier: swipeNotifier,
                    userType: widget.userType,
                  );
                }
              }),
            ),
          ),
        ),
        Positioned(
  bottom: -8,
  left: 0,
  right: 0,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 46.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButtonWidget(
          onPressed: () {
            swipeNotifier.value = Swipe.left;
            _animationController.forward();
            log('swipped left');
          },
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 20),
        ActionButtonWidget(
          onPressed: () {
            try {
              dynamic info = draggableItems.last;
              showDialog(
                context: context,
                builder: (_) => dynamicInformatoinViewer(
                  infoType: widget.userType,
                  uid: info.uid,
                ),
              );
            } on StateError catch (e) {
              log(e.toString());
              UIHelper.showAlertDialog(
                  context, 'End', 'No more Slides');
            }
          },
          icon: const Icon(
            Icons.info_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 20),
        ActionButtonWidget(
          onPressed: () {
            swipeNotifier.value = Swipe.right;
            _animationController.forward();
            log('swipped right');
            try {
              _createUserTargetChatRoom(draggableItems.last.creatorUid);
            } on StateError catch (ex) {
              log(ex.toString());
            }
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ],
    ),
  ),
),

        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                log('swipped left');
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                _createUserTargetChatRoom(draggableItems.last.creatorUid);
                log('swipped right');
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
}
