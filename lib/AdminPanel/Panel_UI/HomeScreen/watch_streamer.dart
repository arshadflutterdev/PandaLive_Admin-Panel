import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Widgets/Textfields/my_textfield.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  final arg = Get.arguments;

  late RtcEngine _engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  final String channelName = "testingChannel";
  final String appToken =
      "007eJxTYLj+6dy8P7+qr0ovSwqOO8idLGN/0jF1Ma8v+5KC26cFf69VYLBMMU4yNzdNMza2TDFJSUyzSDI0TTNMNk8xSE42TzNOCxdpy2wIZGQw/HuHhZEBAkF8PoaS1OKSzLx054zEvLzUHAYGAD33JTM=";

  var remoteviewController = Rxn<VideoViewController>();
  Future<void> joinasaudi() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (remoteUid.toString() == arg["agoraUid"].toString()) {
            remoteviewController.value = VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: remoteUid),
              connection: connection,
            );
          }
        },

        onRemoteVideoStateChanged:
            (connection, remoteUid, state, reason, elapsed) {
              if (remoteUid.toString() == arg["agoraUid"].toString() &&
                  state == RemoteVideoState.remoteVideoStateDecoding) {
                if (remoteviewController.value == null) {
                  remoteviewController.value = VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: connection,
                  );
                }
              }
            },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora Error: $err - $msg");
          if (err == ErrorCodeType.errTokenExpired ||
              err == ErrorCodeType.errInvalidToken) {
            Get.snackbar(
              "Connection Error",
              "Stream token has expired. Please refresh.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              if (remoteUid.toString() == arg["agoraUid"].toString()) {
                _isStreamEndedByHost = true;
                String message =
                    (reason == UserOfflineReasonType.userOfflineDropped)
                    ? "The host lost connection."
                    : "The stream has ended.";
                {
                  Get.snackbar(
                    "Stream Ended",
                    "$message",
                    colorText: Colors.white,
                    backgroundColor: Colors.black,
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Get.back(); // Kick viewer back to list
                  });
                }
                return;
                // remoteviewController.value = null;
                // _isStreamEndedByHost = true;
              }
            },
      ),
    );
    await _engine.joinChannel(
      token: appToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  bool isLivecount = false;
  bool _isStreamEndedByHost = false;
  Future<void> updateviews(int amount) async {
    if (_isStreamEndedByHost) return;
    if (amount > 0 && isLivecount) return;
    if (amount <= 0 && !isLivecount) return;
    try {
      final docRef = FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["uid"]);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          transaction.update(docRef, {"views": FieldValue.increment(amount)});
        } else {
          debugPrint("Ghost Stream: Document was already deleted.");
          _isStreamEndedByHost = true;
        }
      });

      isLivecount = (amount > 0);
    } catch (e) {
      debugPrint("views related issue $e");
    }
  }

  final streamcontroll = Get.put(WatchStreamControllers());
  //now get commentFollowingScreen
  var getComment = FirebaseFirestore.instance.collection("LiveStream");
  late Stream<QuerySnapshot> _commentStream;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await streamcontroll.commentUsers();
      await streamcontroll.checkFollowers();
    });
    _commentStream = FirebaseFirestore.instance
        .collection("LiveStream")
        .doc(arg["uid"])
        .collection("Comments")
        .orderBy("sendAt", descending: true)
        .snapshots();
    joinasaudi();
    updateviews(1);
  }

  @override
  void dispose() {
    updateviews(-1);
    remoteviewController.value = null;
    Future.microtask(() async {
      await _engine.leaveChannel();
      await _engine.release();
    });

    streamcontroll.commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isArabic = Get.locale?.languageCode == "ar";
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _handleExit(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Obx(() {
                final Controller = remoteviewController.value;
                if (Controller != null) {
                  return AgoraVideoView(
                    controller: remoteviewController.value!,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                      Text(
                        "Connecting to stream...",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  );
                }
              }),
            ),

            Positioned(
              top: height * 0.040,
              left: 10,
              right: 10,

              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: arg["image"] != null
                                ? NetworkImage(arg["image"]) as ImageProvider
                                : AssetImage("assets/images/dohrda.jpeg"),
                          ),
                          Gap(5),
                          Text(
                            arg["hostname"] ?? "no name",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(5),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: () {
                      _handleExit(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 2,
              right: 2,

              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: streamcontroll.commentController,
                      // keyboard: TextInputType.text,
                      // hintext: isArabic
                      //     ? "اكتب تعليقاً..."
                      //     : "Write a comment...",
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: () {
                      streamcontroll.sendComment();
                    },
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            //comment section
            Positioned(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.090,
              child: StreamBuilder<QuerySnapshot>(
                stream: _commentStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox();
                  }
                  return Container(
                    width: width,
                    color: Colors.transparent,
                    constraints: BoxConstraints(maxHeight: height * 0.4),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Wrap(
                            children: [
                              Text(
                                data["userName"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber,
                                ),
                              ),
                              Text(
                                " : ",
                                style: TextStyle(color: Colors.amber),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                ),

                                child: Text(
                                  data["comment"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExit(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    // If host ended stream, don't ask, just leave.
    if (_isStreamEndedByHost) {
      Get.back();
      return;
    }
    Get.defaultDialog(
      backgroundColor: Colors.white,
      radius: 12,
      title: isArabic ? "هل تريد مغادرة البث المباشر؟" : "Leave Live Stream?",
      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          isArabic
              ? "أنت تشاهد البث المباشر.\nإذا غادرت الآن، قد تفوت شيئًا ممتعًا!"
              : "You're watching a live stream.\nIf you leave now, you might miss something exciting!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(), // Closes only the dialog
        child: Text(
          isArabic ? "ابقَ" : "Stay",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      confirm: TextButton(
        onPressed: () {
          _isStreamEndedByHost = true;
          Get.back(); // Close dialog
          Get.back(); // Close the screen (this triggers dispose() and updateviews(-1))
        },
        child: Text(
          isArabic ? "غادر" : "Leave",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class WatchStreamControllers extends GetxController {
  RxBool isfollowing = false.obs;
  final String currenduser =
      FirebaseAuth.instance.currentUser?.uid ?? "guest_admin";
  TextEditingController commentController = TextEditingController();

  final arg = Get.arguments;

  Future<void> checkFollowers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"])
        .collection("Followers")
        .doc(currenduser)
        .get();
    isfollowing.value = doc.exists;
  }
  //below are related comments

  RxString commentuser = "Guest".obs;
  Future<void> commentUsers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currenduser)
        .get();
    if (doc.exists) {
      commentuser.value = doc.data()?["name"] ?? "No Name";
    }
  }

  Future<void> sendComment() async {
    if (commentController.text.isEmpty) return;
    String comment = commentController.text.toString();
    commentController.clear();
    try {
      await FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["uid"])
          .collection("Comments")
          .add({
            "userName": commentuser.value,
            "userId": currenduser,
            "comment": comment,
            "sendAt": FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint("Comment error: $e");
    }
  }
}
