import 'dart:async';
import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pertition/BackendFunctions/Pertitions.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/MapPage/PostPage.dart';
import 'package:pertition/PertitionPage/MyPertitionPage.dart';
import 'package:pertition/PertitionPage/SinglePertition.dart';
import 'package:pertition/constants.dart';
import 'package:flutter/services.dart';
import 'package:pertition/main.dart';

class SingleUserMapPage extends StatefulWidget {
  final String userid;
  final String screenname;
  final int usertrees;
  final double height1;
  final String profilepicture;
  final double width1;
  final String pertitionid;

  SingleUserMapPage({
    this.userid,
    this.pertitionid,
    this.screenname,
    this.height1,
    this.profilepicture,
    this.width1,
    this.usertrees,
  });
  @override
  _SingleUserMapPageState createState() => _SingleUserMapPageState();
}

class _SingleUserMapPageState extends State<SingleUserMapPage> {
  GoogleMapController _controller;
  Completer<GoogleMapController> _controller2 = Completer();
  String _mapStyle;
  int type = 0;
  Location location = new Location();
  Map<String, dynamic> posts;
  bool finished = false;
  Set<Circle> all;
  List<Marker> allMarkers = [];
  List<Circle> allPertitions = [];
  Set<Circle> top;
  Set<Circle> newPosts;
  List<int> videoIndex;

  ///Pertition
  Map<String, dynamic> pertitions;
  getPertitions() async {
    getSinglePertition('{"pertitionid": "${widget.pertitionid}"}')
        .then((value) {
      setState(() {
        pertitions = value;

        addPertitions();
      });
    });
  }

  bool pertitionFinished = false;
  int curr = 0;

  getPosts() async {
    getSingleUserPosts('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        posts = value;

        addPosts();
      });
    });
  }

  addPosts() {
    for (int i = 0; i < posts["Count"]; i++) {
      Marker temp = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
            onTap: () {
              Navigator.push(
                context,

                ///todo picture of poster
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    currentuser: widget.userid,
                    currentuserscreenname: widget.screenname,
                    currentuserpicture: widget.profilepicture,
                    currentusertrees: widget.usertrees,
                    userid: posts["Items"][i]["userid"],
                    address: posts["Items"][i]["address"],
                    pertitionid: posts["Items"][i]["pertitionid"],
                    screenname: posts["Items"][i]["screenname"],
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

  categorytag(String category) {
    if (category == "pollution") {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width1 * 0.18,
          padding: EdgeInsets.only(
              left: widget.width1 * 0.01, right: widget.width1 * 0.01),
          height: widget.height1 * 0.03,
          decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:
                Text("Pollution", style: TextStyle(color: white, fontSize: 12)),
          ),
        ),
      );
    }

    if (category == "emissions") {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width1 * 0.21,
          padding: EdgeInsets.only(
            left: widget.width1 * 0.01,
            right: widget.width1 * 0.01,
          ),
          height: widget.height1 * 0.03,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:
                Text("Emissions", style: TextStyle(color: white, fontSize: 12)),
          ),
        ),
      );
    }
    if (category == "general") {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width1 * 0.18,
          padding: EdgeInsets.only(
              left: widget.width1 * 0.01, right: widget.width1 * 0.01),
          height: widget.height1 * 0.03,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:
                Text("General", style: TextStyle(color: white, fontSize: 12)),
          ),
        ),
      );
    }

    if (category == 'deforestation') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width1 * 0.28,
          padding: EdgeInsets.only(
            left: widget.width1 * 0.01,
            right: widget.width1 * 0.01,
          ),
          height: widget.height1 * 0.03,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("Deforestation",
                style: TextStyle(color: white, fontSize: 12)),
          ),
        ),
      );
    }

    if (category == 'water') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: widget.width1 * 0.13,
          padding: EdgeInsets.only(
            left: widget.width1 * 0.01,
            right: widget.width1 * 0.01,
          ),
          height: widget.height1 * 0.03,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("Water", style: TextStyle(color: white, fontSize: 12)),
          ),
        ),
      );
    }
  }

  ///

  addPertitions() {
    for (int i = 0; i < pertitions["Count"]; i++) {
      Circle temp = Circle(
        onTap: () {},
        circleId: CircleId(pertitions["Items"][i]["pertitionscreenname"]),
        strokeColor: Colors.brown,
        center: LatLng(double.parse(pertitions["Items"][i]["lat"]),
            double.parse(pertitions["Items"][i]["lng"])),
        strokeWidth: 7,
        radius: 1000,
      );

      Marker temp1 = Marker(
        onTap: () {
          showMaterialModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: widget.height1 * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///profile picture and name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: widget.height1 * 0.1,
                            width: widget.height1 * 0.1,
                            margin: EdgeInsets.only(
                                top: widget.height1 * 0.02,
                                left: widget.width1 * 0.04,
                                right: widget.width1 * 0.04),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: pertitions["Items"][i]["picture"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: widget.height1 * 0.01),
                                child: Text(
                                    utf8convert(pertitions["Items"][i]
                                        ["pertitionscreenname"]),
                                    style: TextStyle(fontSize: 19)),
                              ),

                              ///memebrs and points
                              Container(
                                margin: EdgeInsets.only(
                                    right: widget.width1 * 0.06,
                                    top: widget.height1 * 0.003),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      pertitions["Items"][i]["members"]
                                              .toString() +
                                          members(pertitions["Items"][i]
                                              ['members']),
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "  ·  ",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      pertitions["Items"][i]["points"]
                                              .toString() +
                                          " points",
                                      style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: widget.width1 * 0.67,
                                  margin: EdgeInsets.only(
                                      top: widget.height1 * 0.006),
                                  child: Text(
                                    pertitions["Items"][i]["address"],
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(right: widget.width1 * 0.05),
                        margin: EdgeInsets.only(
                            left: widget.width1 * 0.06,
                            top: widget.height1 * 0.02),
                        child: Stack(
                          children: [
                            Text(
                              "About",
                              style: TextStyle(
                                  color: black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: categorytag(
                                  pertitions["Items"][i]["category"]),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: widget.height1 * 0.14,
                        margin: EdgeInsets.only(
                            left: widget.width1 * 0.06,
                            top: widget.height1 * 0.02),
                        child: Text(
                          utf8convert(pertitions["Items"][i]["about"]),
                          style: TextStyle(
                            color: black,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePertition(
                                userid: widget.userid,
                                profilepicture: widget.profilepicture,
                                pertitionid: pertitions["Items"][i]
                                    ["pertitionid"],
                                usertrees: widget.usertrees,
                                screenname: widget.screenname,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: widget.width1 * 0.3),
                          width: widget.width1 * 0.4,
                          height: widget.height1 * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green[300],
                          ),
                          child: Center(
                            child: Text(
                              "See More",
                              style: TextStyle(fontSize: 16, color: white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow.noText,
        position: LatLng(double.parse(pertitions["Items"][i]["lat"]),
            double.parse(pertitions["Items"][i]["lng"])),
        markerId: MarkerId(pertitions["Items"][i]["pertitionid"]),
      );

      setState(() {
        allPertitions.add(temp);
        allMarkers.add(temp1);
      });
      if (i == pertitions["Count"] - 1) {
        setState(() {
          pertitionFinished = true;
        });
      }
    }

    setState(() {
      pertitionFinished = true;
    });
  }

  members(int mem) {
    if (mem == 1) {
      return " member";
    } else {
      return " members";
    }
  }

  @override
  void initState() {
    getPosts();
    getPertitions();
    super.initState();

    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final CameraPosition start = CameraPosition(
    target: LatLng(37.42796133580664, -102.085749655962),
    zoom: 3.55,
  );

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

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return new Scaffold(
      body: finished == false || pertitionFinished == false
          ? Container(
              child: SpinKitFadingFour(
              color: Colors.green,
            ))
          : Stack(
              children: [
                Container(
                  child: GoogleMap(
                    minMaxZoomPreference: MinMaxZoomPreference(1.3, 9000),
                    markers: Set<Marker>.of(allMarkers),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    // mapType: MapType.normal,
                    initialCameraPosition: start,
                    circles: Set<Circle>.of(allPertitions),
                    onCameraMoveStarted: () {},
                    onMapCreated: (GoogleMapController controller) {
                      _controller2.complete(controller);
                      // controller.setMapStyle(_mapStyle);
                    },
                    onTap: (LatLng location) {
                      //print(location);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      margin: EdgeInsets.only(
                          top: height * 0.05, left: width * 0.05),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:
                              Icon(FlutterIcons.arrow_left_sli, color: black),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                ///Pop up menu
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: height * 0.1, right: width * 0.05),
                    height: height * 0.05,
                    width: height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: PopupMenuButton(
                      child: Center(
                        child: Icon(
                          FlutterIcons.menu_mdi,
                        ),
                      ),
                      itemBuilder: (context) {
                        return List.from([
                          PopupMenuItem(
                              child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  child: Icon(FlutterIcons.trending_up_fea)),
                              Text("Top"),
                            ],
                          )),
                          PopupMenuItem(
                              child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  child: Icon(FlutterIcons.loader_fea)),
                              Text("New"),
                            ],
                          )),
                          PopupMenuItem(
                              child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  child: Icon(FlutterIcons.radio_fea)),
                              Text("Near"),
                            ],
                          )),
                        ]);
                      },
                    ),
                  ),
                ),

                ///Next
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ///Go to next
                      if (curr == posts["Count"] - 1) {
                        setState(() {
                          curr = 0;
                          goToNextLocation(
                              double.parse(posts["Items"][curr]["lat"]),
                              double.parse(posts["Items"][curr]["lng"]),
                              curr);
                        });
                      } else {
                        setState(() {
                          curr += 1;
                          goToNextLocation(
                              double.parse(posts["Items"][curr]["lat"]),
                              double.parse(posts["Items"][curr]["lng"]),
                              curr);
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      margin: EdgeInsets.only(
                          top: height * 0.23, right: width * 0.05),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(FlutterIcons.corner_right_up_fea),
                      ),
                    ),
                  ),
                ),

                ///Prev
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ///Go to prev
                      if (curr == 0) {
                        setState(() {
                          curr = posts["Count"] - 1;
                          goToPrevLocation(
                              double.parse(posts["Items"][curr]["lat"]),
                              double.parse(posts["Items"][curr]["lng"]),
                              curr);
                        });
                      } else {
                        setState(() {
                          curr -= 1;
                          goToPrevLocation(
                              double.parse(posts["Items"][curr]["lat"]),
                              double.parse(posts["Items"][curr]["lng"]),
                              curr);
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      margin: EdgeInsets.only(
                          top: height * 0.36, right: width * 0.05),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(FlutterIcons.corner_right_down_fea),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
