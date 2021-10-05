import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pertition/AccountScreen/ProfileModalSheet.dart';
import 'package:pertition/BackendFunctions/Pertitions.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/MapPage/PostCommentScreen.dart';
import 'package:pertition/constants.dart';
import 'package:pertition/main.dart';
import 'package:video_player/video_player.dart';

class PostPage extends StatefulWidget {
  final String currentuser;
  final String currentuserscreenname;
  final String currentuserpicture;
  final int currentusertrees;
  final String userid;
  final String screenname;
  final String address;
  final String timecreated;
  final String caption;
  final String category;
  final String pertitionid;

  final int comments;
  final String lat;
  final String lng;

  final int trees;
  final String video;
  final int currentind;

  PostPage(
      {this.userid,
      this.currentuser,
      this.currentusertrees,
      this.currentuserpicture,
      this.currentuserscreenname,
      this.screenname,
      this.address,
      this.timecreated,
      this.caption,
      this.category,
      this.comments,
      this.pertitionid,
      this.lat,
      this.lng,
      this.trees,
      this.video,
      this.currentind});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  VideoPlayerController _controller;
  Map<String, dynamic> comments;
  Map<String, dynamic> user;
  FocusNode _focusNode = FocusNode();
  var _commentController = new TextEditingController();
  int videoIndex = -1;
  int paused = 0;
  int postLiked = 0;
  bool mute = false;
  FToast fToast;
  String postid;
  bool commentsDone = false;
  double textfieldPadding = 0;

  getComments() async {
    getCommentsOfPost('{"postid": "${utf8convert(postid)}"}').then((value) {
      setState(() {
        comments = value;
        commentsDone = true;
      });
    });
  }

  getUser() async {
    getSingleUserInfo('{"userid": "${utf8convert(widget.userid)}"}')
        .then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    postid = widget.userid + widget.timecreated;
    print(widget.video);
    fToast = FToast();
    fToast.init(context);
    _controller = VideoPlayerController.network(
      widget.video,
    )..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  volumeOn() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.green[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterIcons.volume_2_fea,
            color: white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("Volume On", style: TextStyle(color: white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
  }

  volumeMuted() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.green[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterIcons.mute_oct,
            color: white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("Volume Muted", style: TextStyle(color: white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
  }

  getTime(String time) {
    DateTime t = DateTime.parse(time);
    DateTime now = DateTime.now();
    var difference = now.difference(t).inMinutes;
    if (difference > 60) {
      var difference2 = now.difference(t).inHours;

      if (difference2 > 24) {
        var difference3 = now.difference(t).inDays;
        return "$difference3" + "d";
      }
      return "$difference2" + "h";
    } else {
      return "$difference" + "m";
    }
  }

  getWidth(String category) {
    if (category == "deforestation") {
      return 0.26;
    }
    if (category == "water") {
      return 0.13;
    }
    if (category == "pollution") {
      return 0.2;
    }
    if (category == "emissions") {
      return 0.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
    ]);
    commentList() {
      return Container(
        height: height * 0.5,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: comments["Count"],
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height * 0.1,
              padding: EdgeInsets.only(left: width * 0.03),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
            );
          },
        ),
      );
    }

    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              ///video
              GestureDetector(
                onTap: () {
                  if (paused == 0) {
                    setState(() {
                      paused = 1;
                    });

                    _controller.pause();
                  } else {
                    setState(() {
                      paused = 0;
                    });

                    _controller.play();
                    _controller.setLooping(true);
                  }
                },
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                /*        
                  Transform.scale(
                    scale: _controller.value.aspectRatio / (width / height),
                    child: Center(
                        child: AspectRatio(
                            aspectRatio: (_controller.value.aspectRatio),
                            child: VideoPlayer(_controller))),
                  ),
                  */
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  },
                  child: Container(
                    height: height * 0.05,
                    width: height * 0.05,
                    margin: EdgeInsets.only(
                      top: height * 0.07,
                      left: width * 0.06,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent),
                    child: Center(
                      child: Icon(
                        FlutterIcons.arrow_back_mdi,
                        color: white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),

              ///comments, likes, profile
              orientation == Orientation.landscape
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: height * 0.38,
                        width: width * 0.25,
                        padding: EdgeInsets.only(right: width * 0.0),
                        margin: EdgeInsets.only(
                            bottom: height * 0.06, right: width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ///Orientation
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeRight,
                                  ]);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: width * 0.03,
                                    top: height * 0.01,
                                    bottom: height * 0.01),
                                child: Icon(
                                  FlutterIcons.phone_rotate_landscape_mco,
                                  color: white,
                                  size: 28,
                                ),
                              ),
                            ),

                            ///mute video
                            GestureDetector(
                              onTap: () {
                                if (mute == false) {
                                  setState(() {
                                    mute = true;
                                    volumeMuted();
                                    _controller.setVolume(0.0);
                                  });
                                } else {
                                  setState(() {
                                    mute = false;
                                    volumeOn();
                                    _controller.setVolume(0.8);
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: width * 0.03,
                                    top: height * 0.02,
                                    bottom: height * 0.01),
                                child: mute == false
                                    ? Icon(
                                        FlutterIcons.volume_2_fea,
                                        color: white,
                                        size: 28,
                                      )
                                    : Icon(
                                        FlutterIcons.mute_oct,
                                        color: white,
                                        size: 28,
                                      ),
                              ),
                            ),

                            ///Tree liked
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (postLiked == 0 &&
                                        widget.currentusertrees > 0) {
                                      if (widget.userid == widget.currentuser) {
                                        incrementUserNumberOfTrees(
                                            '{"userid": "${widget.currentuser}", "val": $globalnegativeone}');
                                      }

                                      ///Increment post owner tree count and post tree count
                                      incrementUserNumberOfTrees(
                                          '{"userid": "${widget.userid}", "val": $global1}');
                                      incrementPostNumberOfTrees(
                                          '{"userid": "${widget.userid}", "timecreated": "${widget.timecreated}","val": $global1}');

                                      ///Decrement current user tree count
                                      incrementUserNumberOfTrees(
                                          '{"userid": "${widget.currentuser}", "val": $globalnegativeone}');

                                      ///Increment pertition point count of post owner
                                      incrementPertitionPoints(
                                          '{"pertitionid": "${widget.pertitionid}","val": $global1}');
                                      setState(() {
                                        postLiked = 1;
                                      });
                                    } else {
                                      ///Increment current user tree count
                                      incrementUserNumberOfTrees(
                                          '{"userid": "${widget.currentuser}", "val": $global1}');

                                      ///Decrement post owner tree count decremenet post tree count
                                      incrementUserNumberOfTrees(
                                          '{"userid": "${widget.userid}", "val": $globalnegativeone}');
                                      incrementPostNumberOfTrees(
                                          '{"userid": "${widget.userid}", "timecreated": "${widget.timecreated}","val": $globalnegativeone}');

                                      ///Decrement pertition point count of post owner
                                      incrementPertitionPoints(
                                          '{"pertitionid": "${widget.pertitionid}", "val": $globalnegativeone}');
                                      setState(() {
                                        postLiked = 0;
                                      });
                                    }
                                  },
                                  child: postLiked == 1
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.12,
                                              bottom: height * 0.02,
                                              top: height * 0.03),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: height * 0.015,
                                                    width: height * 0.015,
                                                    color: Colors.green,
                                                  ),
                                                  Container(
                                                    height: height * 0.015,
                                                    width: height * 0.015,
                                                    color: Colors.green
                                                        .withRed(200),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height * 0.015,
                                                width: height * 0.015,
                                                color:
                                                    Colors.brown.withRed(200),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.12,
                                              top: height * 0.03,
                                              bottom: height * 0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: height * 0.015,
                                                    width: height * 0.015,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 1,
                                                            color: white),
                                                        left: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                        top: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                        bottom: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.015,
                                                    width: height * 0.015,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                        left: BorderSide(
                                                            width: 1,
                                                            color: white),
                                                        top: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                        bottom: BorderSide(
                                                            width: 2,
                                                            color: white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height * 0.015,
                                                width: height * 0.015,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                        width: 2, color: white),
                                                    right: BorderSide(
                                                        width: 2, color: white),
                                                    bottom: BorderSide(
                                                        width: 2, color: white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),

                            ///Comment Icon
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  commentsDone = false;
                                });
                                getComments();

                                ///Coments
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PostCommentScreen(
                                        userid: widget.currentuser,
                                        postid: postid,
                                        currentuserpicture:
                                            widget.currentuserpicture,
                                        screenname:
                                            widget.currentuserscreenname,
                                        height: height,
                                        width: width,
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: width * 0.03, top: height * 0.02),
                                child: Icon(
                                  FlutterIcons.comment_oct,
                                  color: white,
                                  size: 27,
                                ),
                              ),
                            ),

                            ///Profile Picture of person
                            GestureDetector(
                              onTap: () {
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProfileSheet(
                                        currentuser: widget.currentuser,
                                        currentuserscreenname:
                                            widget.currentuserscreenname,
                                        timecreated: user["Items"][0]
                                            ["timecreated"],
                                        currentuserpicture:
                                            widget.currentuserpicture,
                                        currentusertrees:
                                            widget.currentusertrees,
                                        userid: widget.userid,
                                        screenname: widget.screenname,
                                        profilepicture: user["Items"][0]
                                            ["profilepicture"],
                                        pertitionid: user["Items"][0]
                                            ["pertitionid"],
                                        postcount: user["Items"][0]
                                            ["postcount"],
                                        trees: user["Items"][0]["trees"],
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: width * 0.02, top: height * 0.03),
                                height: width * 0.18,
                                width: width * 0.18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: user == null
                                      ? SpinKitRing(
                                          color: Colors.green,
                                        )
                                      : user["Items"][0]["profilepicture"] == ""
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Colors.green[300],
                                              radius: width * 0.09,
                                              child: Center(
                                                  child: Text(
                                                      utf8convert(user["Items"]
                                                              [0]["screenname"])
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 20))))
                                          : CachedNetworkImage(
                                              imageUrl: user["Items"][0]
                                                  ["profilepicture"],
                                              fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              ///caption and details of the post
              orientation == Orientation.landscape
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: height * 0.2,
                        width: width * 0.7,
                        margin: EdgeInsets.only(
                            bottom: height * 0.08, left: width * 0.04),
                        decoration: BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * getWidth(widget.category),
                              height: height * 0.03,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(widget.category,
                                    style: TextStyle(color: white)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: height * 0.01, top: height * 0.01),
                              child: Text(
                                getTime(
                                      widget.timecreated,
                                    ) +
                                    " ago - " +
                                    widget.address,
                                style: TextStyle(
                                    color: white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            ///username
                            GestureDetector(
                              onTap: () {
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ProfileSheet(
                                        currentuser: widget.currentuser,
                                        currentuserscreenname:
                                            widget.currentuserscreenname,
                                        currentuserpicture:
                                            widget.currentuserpicture,
                                        timecreated: user["Items"][0]
                                            ["timecreated"],
                                        currentusertrees:
                                            widget.currentusertrees,
                                        userid: widget.userid,
                                        screenname: widget.screenname,
                                        profilepicture: user["Items"][0]
                                            ["profilepicture"],
                                        pertitionid: user["Items"][0]
                                            ["pertitionid"],
                                        postcount: user["Items"][0]
                                            ["postcount"],
                                        trees: user["Items"][0]["trees"],
                                      );
                                    });
                              },
                              child: Text(
                                '@' + utf8convert(widget.screenname),
                                style: TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: height * 0.014),
                              child: Text(
                                utf8convert(widget.caption),
                                style: TextStyle(color: white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
