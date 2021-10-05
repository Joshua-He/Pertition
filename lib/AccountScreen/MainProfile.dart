import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pertition/AccountScreen/UserAccountPage.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/BackendFunctions/UploadMedia.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/HomePage/CreatePost.dart';
import 'package:pertition/MapPage/PostPage.dart';
import 'package:pertition/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pertition/main.dart';
import 'package:url_launcher/url_launcher.dart';

class MainProfilePage extends StatefulWidget {
  final String userid;
  MainProfilePage({
    this.userid,
  });
  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  Map<String, dynamic> user;
  Map<String, dynamic> posts;
  bool pic = false;
  int curr = 0;

  ////map

  GoogleMapController _controller;
  Completer<GoogleMapController> _controller2 = Completer();
  FToast fToast;
  List<Marker> allMarkers = [];
  bool finished = false;
  List<int> videoIndex;

  getUserPosts() async {
    getSingleUserPosts('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        posts = value;

        addPosts();
      });
    });
  }

  getUserInfo() async {
    getSingleUserInfo('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        user = value;
        if (user["Items"][0]["profilepicture"] != "") {
          pic = true;
        }
      });
    });
  }

  Future<void> goToNextLocation(double lat, double lng, int ind) async {
    _controller = await _controller2.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 69.440717697143555,
        zoom: 15.151926040649414)));
  }

  Future<void> goToPrevLocation(double lat, double lng, int ind) async {
    _controller = await _controller2.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 69.440717697143555,
        zoom: 15.151926040649414)));
  }

  addPosts() {
    for (int i = 0; i < posts["Count"]; i++) {
      Marker temp = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () {},
        infoWindow: InfoWindow(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    currentuser: widget.userid,
                    currentusertrees: user["Items"][0]["trees"],
                    currentuserpicture: user["Items"][0]["profilepicture"],
                    currentuserscreenname: user["Items"][0]["screenname"],
                    userid: posts["Items"][i]["userid"],
                    screenname: posts["Items"][i]["screenname"],
                    address: posts["Items"][i]["address"],
                    pertitionid: posts["Items"][i]["pertitionid"],
                    timecreated: posts["Items"][i]["timecreated"],
                    caption: posts["Items"][i]["caption"],
                    category: posts["Items"][i]["category"],
                    comments: posts["Items"][i]["comments"],
                    lat: posts["Items"][i]["lat"],
                    lng: posts["Items"][i]["timecreated"],
                    trees: posts["Items"][i]["trees"],
                    video: utf8convert(posts["Items"][i]["videourl"]),
                  ),
                ),
              );
            },
            title: utf8convert(posts["Items"][i]["screenname"]),
            snippet: utf8convert(posts["Items"][i]["caption"])),
        position: LatLng(double.parse(posts["Items"][i]["lat"]),
            double.parse(posts["Items"][i]["lng"])),
        markerId: MarkerId(
            posts["Items"][i]["userid"] + posts["Items"][i]["timecreated"]),
      );
      setState(() {
        allMarkers.add(temp);
      });

      if (i == posts["Count"] - 1) {
        setState(() {
          finished = true;
        });
      }
    }
  }

  @override
  void initState() {
    getUserInfo();
    getUserPosts();
    fToast = FToast();
    fToast.init(context);
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
          Text("Delete Successful",
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
          Text("Delete unsuccessful",
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

  Future<Null> _refresh() async {
    setState(() {
      getSingleUserPosts('{"userid": "${widget.userid}"}').then((value) {
        setState(() {
          posts = value;
          videoIndex = List.filled(posts["Count"], -1);

          addPosts();
        });
      });

      getUserInfo();
    });
  }

  Route _pushAccountPage() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => UserAccountPage(
        userid: widget.userid,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  parseTime(String time) {
    String month = time.substring(5, 7);
    String ret = "";
    if (month == '01') {
      ret += "January";
    }
    if (month == '02') {
      ret += "February";
    }
    if (month == '03') {
      ret += "March";
    }
    if (month == '04') {
      ret += "April";
    }
    if (month == '05') {
      ret += "May";
    }
    if (month == '06') {
      ret += "June";
    }
    if (month == '07') {
      ret += "July";
    }
    if (month == '08') {
      ret += "August";
    }
    if (month == '09') {
      ret += "September";
    }
    if (month == '10') {
      ret += "October";
    }
    if (month == '11') {
      ret += "November";
    }
    if (month == '12') {
      ret += "December";
    }

    return ret + " " + time.substring(8, 10) + ", " + time.substring(0, 4);
  }

  _launchMap(BuildContext context, lat, lng) async {
    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = "comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving";
      if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return new RefreshIndicator(
      onRefresh: _refresh,
      child: Container(
        height: height,
        width: width,
        child: user == null || posts == null
            ? SpinKitRing(
                color: Colors.green[300],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      height: height * 0.07,
                      child: Stack(
                        children: [
                          ///Profile Picture
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(_pushAccountPage());
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.04),
                              height: height * 0.06,
                              width: height * 0.06,
                              //alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: user["Items"][0]["profilepicture"] == ""
                                    ? CircleAvatar(
                                        backgroundColor: Colors.green[300],
                                        radius: height * 0.04,
                                        child: Center(
                                          child: Text(
                                            utf8convert(user["Items"][0]
                                                    ["screenname"])
                                                .substring(0, 1),
                                            style: TextStyle(
                                                fontSize: 24, color: white),
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        user["Items"][0]["profilepicture"],
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              user["Items"][0]["screenname"].length > 17
                                  ? utf8convert(
                                          user["Items"][0]["screenname"]) +
                                      '..'
                                  : utf8convert(user["Items"][0]["screenname"]),
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
/*
                          ///Menu
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: height * 0.06,
                                width: height * 0.06,
                                margin: EdgeInsets.only(right: width * 0.02),
                                color: white,
                                child: Center(
                                  child: Icon(
                                    FlutterIcons.menu_mco,
                                    size: 29,
                                  ),
                                ),
                              ),
                            ),

                            ///Title
                          ),
                          */
                        ],
                      ),
                    ),

                    ///points and trees
                    Container(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.435,
                          margin: EdgeInsets.only(
                              left: width * 0.05, right: width * 0.03),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: height * 0.01, left: width * 0.03),
                                  child: Text("Trees",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: width * 0.43,
                                  padding: EdgeInsets.only(
                                      top: height * 0.01, left: width * 0.0),
                                  height: height * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TreeLogo(),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.03),
                                        child: Text(
                                            user["Items"][0]["trees"]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: width * 0.0),
                            width: width * 0.435,
                            height: height * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: black,
                            ),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user["Items"][0]["postcount"].toString(),
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Posts",
                                  style: TextStyle(color: white),
                                )
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),

                    ///Map and button column
                    posts["Count"] == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///map
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.05, top: height * 0.03),
                                height: height * 0.45,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: GoogleMap(
                                    gestureRecognizers:
                                        <Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<OneSequenceGestureRecognizer>(
                                        () => new EagerGestureRecognizer(),
                                      ),
                                    ].toSet(),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller2.complete(controller);
                                    },
                                    initialCameraPosition: CameraPosition(
                                      zoom: 10,
                                      target: LatLng(
                                        34.0522,
                                        -118.2437,
                                      ),
                                    ),
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    minMaxZoomPreference:
                                        MinMaxZoomPreference(1.3, 9000),
                                    markers: Set<Marker>.of(allMarkers),
                                  ),
                                ),
                              ),

                              ///next and prev
                              Container(
                                width: width * 0.9,
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: width * 0.06,
                                          top: height * 0.007),
                                      child: Text(
                                        posts["Count"] != 0
                                            ? "${curr + 1}" +
                                                " / " +
                                                "${posts["Count"]}"
                                            : "No Posts",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ///Post counter

                                        GestureDetector(
                                          onTap: () {
                                            ///Go to prev
                                            if (posts["Count"] != 0) {
                                              if (curr == 0) {
                                                setState(() {
                                                  curr = posts["Count"] - 1;
                                                  goToPrevLocation(
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lat"]),
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lng"]),
                                                      curr);
                                                });
                                              } else {
                                                setState(() {
                                                  curr -= 1;
                                                  goToPrevLocation(
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lat"]),
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lng"]),
                                                      curr);
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: height * 0.04,
                                            width: height * 0.04,
                                            child: Center(
                                              child: Icon(FlutterIcons
                                                  .corner_left_down_fea),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (posts["Count"] != 0) {
                                              if (curr == posts["Count"] - 1) {
                                                setState(() {
                                                  curr = 0;
                                                  goToNextLocation(
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lat"]),
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lng"]),
                                                      curr);
                                                });
                                              } else {
                                                setState(() {
                                                  curr += 1;
                                                  goToNextLocation(
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lat"]),
                                                      double.parse(
                                                          posts["Items"][curr]
                                                              ["lng"]),
                                                      curr);
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: height * 0.04,
                                            width: height * 0.04,
                                            margin: EdgeInsets.only(
                                                left: width * 0.04),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Icon(FlutterIcons
                                                    .corner_right_up_fea)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///map
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.05, top: height * 0.03),
                                height: height * 0.45,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: GoogleMap(
                                    gestureRecognizers:
                                        <Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<OneSequenceGestureRecognizer>(
                                        () => new EagerGestureRecognizer(),
                                      ),
                                    ].toSet(),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller2.complete(controller);
                                    },
                                    initialCameraPosition: CameraPosition(
                                      zoom: 17,
                                      target: LatLng(
                                        double.parse(
                                          posts["Items"][0]["lat"],
                                        ),
                                        double.parse(
                                          posts["Items"][0]["lng"],
                                        ),
                                      ),
                                    ),
                                    //myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    minMaxZoomPreference:
                                        MinMaxZoomPreference(1.3, 9000),
                                    markers: Set<Marker>.of(allMarkers),
                                  ),
                                ),
                              ),
                            ],
                          ),

                    ///Changing caption
                    posts["Count"] == 0
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(
                                top: height * 0.01,
                                left: width * 0.05,
                                right: width * 0.05),
                            padding: EdgeInsets.only(
                                top: height * 0.01,
                                left: width * 0.03,
                                bottom: height * 0.01),
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  posts["Count"] == 0
                                      ? "No Posts!"
                                      : parseTime(
                                          posts["Items"][curr]["timecreated"],
                                        ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                posts["Count"] == 0
                                    ? null
                                    : Text(
                                        posts["Items"][curr]["trees"]
                                                .toString() +
                                            " trees",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green[300],
                                            fontWeight: FontWeight.bold),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  child: Text(
                                    posts["Count"] == 0
                                        ? "You have no posts."
                                        : utf8convert(
                                            posts["Items"][curr]["caption"]),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),

                    ///see post go to map
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.015, bottom: height * 0.015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///See post video
                          GestureDetector(
                            onTap: () {
                              if (posts["Count"] != 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostPage(
                                      currentuser: widget.userid,
                                      currentuserpicture: user["Items"][0]
                                          ["profilepicture"],
                                      currentuserscreenname: user["Items"][0]
                                          ["screenname"],
                                      currentusertrees: user["Items"][0]
                                          ["trees"],
                                      userid: posts["Items"][curr]["userid"],
                                      screenname: posts["Items"][curr]
                                          ["screenname"],
                                      address: posts["Items"][curr]["address"],
                                      pertitionid: posts["Items"][curr]
                                          ["pertitionid"],
                                      timecreated: posts["Items"][curr]
                                          ["timecreated"],
                                      caption: posts["Items"][curr]["caption"],
                                      category: posts["Items"][curr]
                                          ["category"],
                                      comments: posts["Items"][curr]
                                          ["comments"],
                                      lat: posts["Items"][curr]["lat"],
                                      lng: posts["Items"][curr]["timecreated"],
                                      trees: posts["Items"][curr]["trees"],
                                      video: utf8convert(
                                          posts["Items"][curr]["videourl"]),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: height * 0.08,
                              width: width * 0.435,
                              padding: EdgeInsets.only(
                                  top: height * 0.01, left: width * 0.02),
                              margin: EdgeInsets.only(
                                  left: width * 0.05, right: width * 0.03),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.green[300]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FlutterIcons.map_fea,
                                    size: 16,
                                    color: white,
                                  ),
                                  Text(
                                    "   See Post",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (posts["Count"] != 0) {
                                _launchMap(context, posts["Items"][curr]["lat"],
                                    posts["Items"][curr]["lng"]);
                              }
                            },
                            child: Container(
                              height: height * 0.08,
                              width: width * 0.435,
                              padding: EdgeInsets.only(
                                  top: height * 0.01, left: width * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[300]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FlutterIcons.arrow_up_right_fea,
                                    size: 19,
                                    color: white,
                                  ),
                                  Text(
                                    "  Navigate",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.0, bottom: height * 0.015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///See post video
                          GestureDetector(
                            onTap: () {
                              if (posts["Count"] != 0) {
                                if (curr == posts["Count"] - 1) {
                                  setState(() {
                                    curr = 0;
                                    goToNextLocation(
                                        double.parse(
                                            posts["Items"][curr]["lat"]),
                                        double.parse(
                                            posts["Items"][curr]["lng"]),
                                        curr);
                                  });
                                } else {
                                  setState(() {
                                    curr += 1;
                                    goToNextLocation(
                                        double.parse(
                                            posts["Items"][curr]["lat"]),
                                        double.parse(
                                            posts["Items"][curr]["lng"]),
                                        curr);
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.435,
                              padding: EdgeInsets.only(
                                  top: height * 0.01, left: width * 0.02),
                              margin: EdgeInsets.only(
                                  left: width * 0.05, right: width * 0.03),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FlutterIcons.corner_left_up_fea,
                                    size: 16,
                                    color: white,
                                  ),
                                  Text(
                                    "   Next",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (posts["Count"] != 0) {
                                if (curr == 0) {
                                  setState(() {
                                    curr = posts["Count"] - 1;
                                    goToPrevLocation(
                                        double.parse(
                                            posts["Items"][curr]["lat"]),
                                        double.parse(
                                            posts["Items"][curr]["lng"]),
                                        curr);
                                  });
                                } else {
                                  setState(() {
                                    curr -= 1;
                                    goToPrevLocation(
                                        double.parse(
                                            posts["Items"][curr]["lat"]),
                                        double.parse(
                                            posts["Items"][curr]["lng"]),
                                        curr);
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.435,
                              padding: EdgeInsets.only(
                                  top: height * 0.01, left: width * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FlutterIcons.corner_right_down_fea,
                                    size: 19,
                                    color: white,
                                  ),
                                  Text(
                                    "  Previous",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          showMaterialModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: height * 0.15,
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                    onTap: () {
                                      deletePost(
                                              '{"userid":"${widget.userid}", "timecreated": "${posts["Items"][curr]["timecreated"]}"}')
                                          .then((value) {
                                        if (value == 200) {
                                          deleteMedia(
                                              '{"number": $global1, "keys": ["${posts["Items"][curr]["videourl"]}"]}');

                                          setState(() {
                                            if (curr == 0) {
                                            } else {
                                              curr -= 1;
                                            }

                                            getUserPosts();
                                          });
                                          postSuccessful();
                                          Navigator.pop(context);
                                        } else {
                                          unsuccessful();
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: height * 0.05,
                                          bottom: height * 0.05,
                                          left: width * 0.2,
                                          right: width * 0.2),
                                      height: height * 0.12,
                                      width: width * 0.9,
                                      decoration: BoxDecoration(
                                          color: Colors.red[300],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Confirm Delete",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: height * 0.0, left: width * 0.05),
                          child: Container(
                            width: width * 0.435,
                            alignment: Alignment.center,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Delete",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold)),
                          ),
                        )),
                    GestureDetector(
                        onTap: () async {
                          final Uri params = Uri(
                            scheme: 'mailto',
                            path: 'pertitionllc@gmail.com',
                            query:
                                'subject=Pertition Help&body=', //add subject and body here
                          );

                          var url = params.toString();
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          width: width,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: height * 0.1, left: width * 0.05),
                          child: Container(
                            width: width * 0.385,
                            alignment: Alignment.center,
                            height: height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Help / Suggestions",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )),
                    Container(
                      height: height * 0.1,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
