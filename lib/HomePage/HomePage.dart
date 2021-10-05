import 'dart:async';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pertition/AccountScreen/Account.dart';
import 'package:pertition/AccountScreen/MainProfile.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/HomePage/CreatePost.dart';
import 'package:pertition/HomePage/Tabs/HomeTab.dart';
import 'package:pertition/MapPage/MapPage.dart';
import 'package:pertition/PertitionPage/MyPertitionPage.dart';
import 'package:pertition/PertitionPage/PertitionPage.dart';
import 'package:pertition/PertitionPage/SinglePertition.dart';
import 'package:pertition/constants.dart';
import 'package:pertition/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userid;

  HomePage({this.userid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AppLifecycleState _notification;
  int tabIndex = 1;

  String userid;
  Map<String, dynamic> user;
//  Stopwatch _watch = Stopwatch();
  Timer _timer;

  getUserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userid = prefs.getString('userid');
    });
    getSingleUserInfo('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      incrementUserNumberOfTrees(
          '{"userid": "${widget.userid}", "val": $global1}');

      ///back end function
    });
    super.initState();
    // _watch.start();
    WidgetsBinding.instance.addObserver(this);
    didChangeAppLifecycleState(_notification);

    getUserid();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        _timer = Timer.periodic(Duration(minutes: 1), (timer) {
          ///back end function
          incrementUserNumberOfTrees(
              '{"userid": "${widget.userid}", "val": $global1}');
        });
        // _watch.start();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        _timer.cancel();
        // _watch.stop();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    returnTab() {
      if (tabIndex == 1) {
        return MainProfilePage(
          userid: widget.userid,
        );
      }
      if (tabIndex == 2) {
        return MapPage(
          userid: widget.userid,
        );
      }
      if (tabIndex == 3) {
        return PertitionPage(
          userid: widget.userid,
          profilepicture: user["Items"][0]["profilepicture"],
          screenname: user["Items"][0]["screenname"],
          usertrees: user["Items"][0]["trees"],
          currentPertition: user["Items"][0]["pertitionid"],
        );
      }
      if (tabIndex == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyPartitionPage(
              userid: widget.userid,
              usertrees: user["Items"][0]["trees"],
              screenname: user["Items"][0]["screenname"],
            ),
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: () {},
      child: ColorfulSafeArea(
        color: white,
        child: Scaffold(
          backgroundColor: white,
          //backgroundColor: Color(0xf1ffffff),
          body: Container(
            height: height,
            width: width,
            child: userid == null
                ? Container()
                : Stack(
                    children: [
                      Container(child: returnTab()),

                      ///TabBar
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(top: height * 0.01),
                          height: height * 0.055,
                          width: width,
                          decoration: BoxDecoration(
                            color: white,
                            /*
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                                */
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(
                                    0, 0.1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Home
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tabIndex = 1;
                                  });
                                },
                                child: Container(
                                  height: height * 0.055,
                                  margin: EdgeInsets.only(
                                      left: width * 0.04, right: width * 0.03),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FlutterIcons.home_fea,
                                        size: 25,
                                        color: tabIndex == 1
                                            ? Colors.green[300]
                                            : black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///pertitoins
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tabIndex = 3;
                                  });
                                },
                                child: Container(
                                  width: width * 0.2,
                                  height: height * 0.045,
                                  margin: EdgeInsets.only(left: width * 0.02),
                                  child: Column(
                                    children: [
                                      Icon(
                                        FlutterIcons.target_fea,
                                        size: 25,
                                        color: tabIndex == 3 ? green : black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///New Post
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreatePost(
                                        userid: widget.userid,
                                        screenname: user["Items"][0]
                                            ["screenname"],
                                        userkey: user["Items"][0]["userkey"],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: width * 0.18,
                                  margin: EdgeInsets.only(left: width * 0.01),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: height * 0.02,
                                            width: height * 0.02,
                                            color: Colors.green,
                                          ),
                                          Container(
                                            height: height * 0.02,
                                            width: height * 0.02,
                                            color: Colors.green.withRed(200),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: height * 0.02,
                                        width: height * 0.02,
                                        color: Colors.brown.withRed(200),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              ///map
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapPage(
                                          userid: widget.userid,
                                          screenname: user["Items"][0]
                                              ["screenname"],
                                          profilepicture: user["Items"][0]
                                              ["profilepicture"],
                                          height1: height,
                                          width1: width,
                                          usertrees: user["Items"][0]["trees"],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  width: width * 0.2,
                                  height: height * 0.055,
                                  margin: EdgeInsets.only(right: width * 0.04),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FlutterIcons.map_fea,
                                        size: 25,
                                        color: tabIndex == 2 ? green : black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///Profile
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyPartitionPage(
                                        userid: widget.userid,
                                        usertrees: user["Items"][0]["trees"],
                                        screenname: user["Items"][0]
                                            ["screenname"],
                                      ),
                                    ),
                                  );
                                  /*
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SinglePertition(
                                        userid: widget.userid,
                                        pertitionid: user["Items"][0]
                                            ["pertitionid"],
                                        usertrees: user["Items"][0]["trees"],
                                      ),
                                    ),
                                  );
                                  */
                                },
                                child: Container(
                                  height: height * 0.045,
                                  margin: EdgeInsets.only(
                                      right: width * 0.04, left: width * 0.01),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FlutterIcons.globe_fea,
                                        size: 25,
                                        color: tabIndex == 4 ? green : black,
                                      ),
                                    ],
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
    );
  }
}
