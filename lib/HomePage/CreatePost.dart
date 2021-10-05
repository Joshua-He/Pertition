import 'dart:async';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_place/google_place.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/BackendFunctions/UploadMedia.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/HomePage/SuccessfulPost.dart';
import 'package:pertition/Media/VideoConstructor.dart';
import 'package:pertition/constants.dart';
import 'package:pertition/main.dart';
import 'package:video_player/video_player.dart';

class CreatePost extends StatefulWidget {
  final String userid;
  final String screenname;
  final String userkey;

  CreatePost({this.userid, this.screenname, this.userkey});
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  VideoPlayerController _controller;
  bool upload = false;
  int display = 0;
  int del = 0;
  List<dynamic> media = [];
  String videourl;
  List<String> keys = [];
  int count = 0;
  FToast fToast;

  var description = new TextEditingController();

  int color2 = 0;
  String category = "";
  List<String> returnedLocation = ["", "", ""];
  String pertitionid = "";

  getUserPertition() async {
    getSingleUserInfo('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        pertitionid = value["Items"][0]["pertitionid"];
      });
    });
  }

  @override
  void initState() {
    getUserPertition();
    fToast = FToast();
    fToast.init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    googlePlace = GooglePlace("AIzaSyAQHOdlDPFrgmvxOfr1p_2doHCPacm7O2s");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  postSuccessful() {
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
            FlutterIcons.checkcircle_ant,
            color: white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("Post Successful",
              style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  unsuccessful() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.red[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterIcons.exclamation_ant,
            color: white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("Post not successful",
              style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  pertition() {
    if (pertitionid == "") {
      return ".";
    } else {
      return pertitionid;
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    ////Text field widgets

    caption() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.06, top: height * 0.0),
            child: Text(
              "Caption",
              style: TextStyle(
                  color: color2 == 1 ? Colors.green[300] : black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            height: height * 0.173,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.1)),
            margin: EdgeInsets.only(
                left: width * 0.06, right: width * 0.06, top: height * 0.02),
            child: TextField(
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 5,
              maxLength: 140,
              controller: description,
              onChanged: (String value) {
                if (value.length >= 0) {
                  setState(() {
                    color2 = 1;
                  });
                }
              },
              textAlign: TextAlign.start,
              autofocus: false,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                      left: width * 0.04,
                      top: height * 0.016,
                      right: width * 0.04,
                      bottom: height * 0.02),
                  hintText: "Your caption",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      );
    }

    awaitLocation(BuildContext context) async {
      returnedLocation = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PickLocation(),
        ),
      );

      setState(() {});
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
        backgroundColor: white,
        body: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Top row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (upload == true) {
                          if (count == 1) {
                            deleteMedia(
                                '{"number": $count, "keys": ["$videourl"]}');
                          }
                          if (count == 2) {
                            deleteMedia(
                                '{"number": $count, "keys": ["${keys[0]}", "${keys[1]}"]}');
                          }
                          if (count == 3) {
                            deleteMedia(
                                '{"number": $count, "keys": ["${keys[0]}", "${keys[1]}", "${keys[2]}"]}');
                          }
                          if (count == 4) {
                            deleteMedia(
                                '{"number": $count, "keys": ["${keys[0]}", "${keys[1]}", "${keys[2]}", "${keys[3]}"]}');
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: width * 0.06, top: width * .01),
                        child: Icon(
                          FlutterIcons.arrow_left_sli,
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: width * .01, left: width * .28),
                      child: Text(
                        "New Post",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                del == 1
                    ? Container()
                    : Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              pickFile().then((value) {
                                uploadFile(value[0], widget.userkey)
                                    .then((value) {
                                  setState(() {
                                    videourl = value;

                                    count++;
                                  });

                                  setState(() {
                                    upload = true;
                                    del = 1;
                                  });
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      display = 1;
                                    });
                                  });
                                });
/*
                                if (value.length > 4) {
                                  for (int i = 0; i < 3; i++) {
                                    uploadFile(value[i].path, widget.userid)
                                        .then((value) {
                                      setState(() {
                                        media.add(value);
                                        keys.add(
                                            value.substring(59, value.length));
                                        count++;
                                      });
                                    });
                                  }

                                  uploadFile(value[value.length - 1].path,
                                          widget.userid)
                                      .then((value) {
                                    setState(() {
                                      media.add(value);
                                      keys.add(
                                          value.substring(59, value.length));
                                      count++;
                                    });
                                  });
                                  setState(() {
                                    upload = true;
                                    del = 1;
                                  });

                                  Timer(Duration(seconds: 4), () {
                                    setState(() {
                                      display = 1;
                                    });
                                  });
                                } else {
                                  for (int i = 0; i < value.length; i++) {
                                    uploadFile(value[i].path, widget.userid)
                                        .then((value) {
                                      setState(() {
                                        media.add(value);
                                        keys.add(
                                            value.substring(59, value.length));
                                        count++;
                                      });
                                    });
                                  }
                                  setState(() {
                                    upload = true;
                                    del = 1;
                                  });

                                  Timer(Duration(seconds: 4), () {
                                    setState(() {
                                      display = 1;
                                    });
                                  });
                                }

                                */
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.07,
                                  bottom: height * 0.06,
                                  left: width * 0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height * 0.08,
                                    width: height * 0.08,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(FlutterIcons.plus_mco),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: width * 0.04),
                                    child: Text("Add a video",
                                        style: TextStyle(color: Colors.green)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                ///pictures
                display == 1
                    ? Container(
                        margin: EdgeInsets.only(
                          top: height * 0.03,
                          bottom: height * 0.02,
                        ),
                        height: height * 0.26,
                        width: width,
                        child: Container(
                          child: VideoConstructor(
                            url: videourl,
                          ),
                        ))
                    : del == 0
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(
                                top: height * 0.05, bottom: height * 0.05),
                            child: SpinKitWave(
                              color: Colors.green[300],
                            ),
                          ),

                ///Caption section
                caption(),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.06, top: height * 0.02),
                  child: Text(
                    "Category",
                    style: TextStyle(
                        color: category != "" ? Colors.green[300] : black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                ///Row 1 category
                Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///emissions
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            category = "emissions";
                          });
                        },
                        child: Container(
                          width: width * 0.42,
                          height: height * 0.07,
                          margin: EdgeInsets.only(right: width * 0.02),
                          padding: EdgeInsets.only(
                              top: height * 0.005, left: width * 0.015),
                          decoration: BoxDecoration(
                              border: category == 'emissions'
                                  ? Border.all(
                                      width: 4, color: Colors.green[300])
                                  : Border.all(
                                      width: 4, color: Colors.transparent),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'pictures/emissions.jpg',
                                  )),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.greenAccent),
                          child: Text(
                            "Emissions",
                            style: TextStyle(
                                fontSize: 15,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //deforestation
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            category = "deforestation";
                          });
                        },
                        child: Container(
                          width: width * 0.42,
                          height: height * 0.07,
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.only(
                              top: height * 0.005, left: width * 0.015),
                          decoration: BoxDecoration(
                              border: category == 'deforestation'
                                  ? Border.all(
                                      width: 4, color: Colors.green[300])
                                  : Border.all(
                                      width: 4, color: Colors.transparent),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'pictures/deforestation.jpg',
                                  )),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.greenAccent),
                          child: Text(
                            "Deforestation",
                            style: TextStyle(
                                fontSize: 15,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///Row 2 category

                Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///emissions
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            category = "pollution";
                          });
                        },
                        child: Container(
                          width: width * 0.42,
                          height: height * 0.07,
                          margin: EdgeInsets.only(right: width * 0.02),
                          padding: EdgeInsets.only(
                              top: height * 0.005, left: width * 0.015),
                          decoration: BoxDecoration(
                              border: category == 'pollution'
                                  ? Border.all(
                                      width: 4, color: Colors.green[300])
                                  : Border.all(
                                      width: 4, color: Colors.transparent),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'pictures/clean.jpg',
                                  )),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.greenAccent),
                          child: Text(
                            "Pollution",
                            style: TextStyle(
                                fontSize: 15,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //deforestation
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            category = "water";
                          });
                        },
                        child: Container(
                          width: width * 0.42,
                          height: height * 0.07,
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.only(
                              top: height * 0.005, left: width * 0.015),
                          decoration: BoxDecoration(
                              border: category == 'water'
                                  ? Border.all(
                                      width: 4, color: Colors.green[300])
                                  : Border.all(
                                      width: 4, color: Colors.transparent),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'pictures/water.jpg',
                                  )),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.greenAccent),
                          child: Text(
                            "Water",
                            style: TextStyle(
                                fontSize: 15,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.06, top: height * 0.02),
                  child: Text(
                    "Location",
                    style: TextStyle(
                        color: returnedLocation[0].length > 0
                            ? Colors.green[300]
                            : black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    awaitLocation(context);
                  },
                  child: Container(
                    height: height * 0.1,
                    width: width,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            awaitLocation(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.05),
                            child: Icon(FlutterIcons.location_oct),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            awaitLocation(context);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: width * 0.05),
                              width: width * 0.8,
                              child: Text(
                                returnedLocation[0].length > 0
                                    ? returnedLocation[0]
                                    : "Search",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: returnedLocation[0].length > 0
                                        ? Colors.green
                                        : black),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if (upload == true &&
                        color2 == 1 &&
                        category != "" &&
                        returnedLocation[0] != "") {
                      uploadPost(
                              '{"userid": "${widget.userid}", "screenname": "${utf8convert(widget.screenname)}", "timecreated": "${DateTime.now()}", "caption": "${description.text}", "category": "$category", "address": "${returnedLocation[0]}", "lat": "${returnedLocation[1]}", "lng": "${returnedLocation[2]}", "pertitionid": "${pertition()}", "videourl": "${utf8convert(videourl)}"}')
                          .then((value) {
                        if (value == 200) {
                          updateUserNumberOfPosts(
                              '{"userid": "${widget.userid}"}');
                          Navigator.pop(context);
                          postSuccessful();
                          setState(() {});
                        } else {
                          unsuccessful();
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Container(
                      width: width * 0.38,
                      margin: EdgeInsets.only(
                          left: width * 0.31,
                          top: height * 0.03,
                          bottom: height * 0.01),
                      height: height * 0.05,
                      decoration: BoxDecoration(
                          color: (upload == true &&
                                  color2 == 1 &&
                                  category != "" &&
                                  returnedLocation[0] != "")
                              ? Colors.green[300]
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                          child: Text("Share",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: white)))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PickLocation extends StatefulWidget {
  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  List<dynamic> items = [];
  List<String> temp = ["", "", ""];

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  @override
  void initState() {
    googlePlace = GooglePlace("AIzaSyAQHOdlDPFrgmvxOfr1p_2doHCPacm7O2s");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {},
      child: ColorfulSafeArea(
        color: white,
        child: Scaffold(
          backgroundColor: white,
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Top Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, temp);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.06, top: width * .01),
                          child: Icon(
                            FlutterIcons.arrow_left_sli,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: width * .01, left: width * .24),
                        child: Text(
                          "Pick Location",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      padding: EdgeInsets.only(
                          left: width * 0.0, right: width * 0.04),
                      width: width,
                      height: height * 0.07,
                      child: TextField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: width * 0.04),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey)),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {
                            if (predictions.length > 0 && mounted) {
                              setState(() {
                                predictions = [];
                              });
                            }
                          }
                        },
                      )),
                  Container(
                    height: height * 0.6,
                    child: ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            var result = await this
                                .googlePlace
                                .details
                                .get(predictions[index].placeId);

                            //  print(result.result.formattedAddress.toString());

                            // print(result.result.addressComponents[0].longName);
                            //  print(result.result.addressComponents[1].longName);
                            //   print(result.result.addressComponents[2].longName);

                            ///bethany
                            // print(result.result.addressComponents[3].longName);

                            ///portland
                            // print(result.result.addressComponents[4].longName);

                            ///county
                            // print(result.result.addressComponents[5].longName);

                            ///state
                            // print(result.result.addressComponents[6].longName);

                            ///country
                            // print(result.result.addressComponents[7].longName);

                            ///zip
//print(result.result.addressComponents[8].longName);

                            List<String> tempret = [
                              result.result.formattedAddress.toString(),
                              result.result.geometry.location.lat.toString(),
                              result.result.geometry.location.lng.toString(),
                            ];

                            Navigator.pop(context, tempret);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: height * 0.03),
                            padding: EdgeInsets.only(
                                left: width * 0.04, right: width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(predictions[index].description),
                              ],
                            ),
                          ),
                        );
                      },
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
