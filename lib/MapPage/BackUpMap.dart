import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pertition/BackendFunctions/Pertitions.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/MapPage/PostPage.dart';

import 'package:pertition/constants.dart';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  final String userid;

  MapPage({this.userid});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Completer<GoogleMapController> _controller2 = Completer();
  String _mapStyle;
  int type = 0;
  Location location = new Location();
  Map<String, dynamic> posts;
  Map<String, dynamic> pertitions;
  bool finished = false;
  bool pertitionFinished = false;
  Set<Circle> all;
  List<Marker> allMarkers = [];
  List<Circle> allPertitions = [];
  Set<Circle> top;
  Set<Circle> newPosts;
  List<int> videoIndex;

  int curr = 0;

  getPertitions() async {
    getPertitionCategory('{"category": "main"}').then((value) {
      setState(() {
        pertitions = value;
        addPertitions();
      });
    });
  }

  getPosts() async {
    getPostsMain('{"appcategory": "main"}').then((value) {
      setState(() {
        posts = value;
        addPosts();
        videoIndex = List.filled(posts["Count"], -1);
        findVideo();
      });
    });
  }

  findVideo() {
    for (int i = 0; i < posts["Count"]; i++) {
      for (int j = 0; j < posts["Items"][i]["media"].length; j++) {
        if (posts["Items"][i]["media"][j]
                .substring(posts["Items"][i]["media"][j].length - 4) ==
            ".mov") {
          setState(() {
            videoIndex[i] = j;
          });
        }
      }
    }
  }

  addPosts() {
    for (int i = 0; i < posts["Count"]; i++) {
      Marker temp = Marker(
        infoWindow: InfoWindow(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    currentuser: widget.userid,
                    userid: posts["Items"][i]["userid"],
                    address: posts["Items"][i]["address"],
                    pertitionid: posts["Items"][i]["pertitionid"],
                    timecreated: posts["Items"][i]["timecreated"],
                    caption: posts["Items"][i]["caption"],
                    category: posts["Items"][i]["category"],
                    comments: posts["Items"][i]["comments"],
                    lat: posts["Items"][i]["lat"],
                    lng: posts["Items"][i]["timecreated"],
                    trees: posts["Items"][i]["trees"],
                    video: posts["Items"][i]["videourl"],
                  ),
                ),
              );
              /*
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 400,
                        height: 500,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Pictures
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {},
                                viewportFraction: 1,
                              ),
                              itemCount: posts["Items"][i]["mediacount"],
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                width: 400,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    posts["Items"][i]["media"][itemIndex],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            ///location and name
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ///Profile Picture
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              'pictures/clean.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, bottom: 3),
                                                child: Text(
                                                  posts["Items"][i]["userid"],
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  posts["Items"][i]["address"]
                                                              .length <
                                                          26
                                                      ? posts["Items"][i]
                                                          ["address"]
                                                      : posts["Items"][i]
                                                                  ["address"]
                                                              .substring(
                                                                  0, 36) +
                                                          "..",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///caption
                            Container(
                              padding: EdgeInsets.only(left: 16, right: 5),
                              margin: EdgeInsets.only(top: 8, left: 2),
                              child: Text(posts["Items"][i]["caption"],
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                  */
            },
            title: posts["Items"][i]["userid"],
            snippet: posts["Items"][i]["caption"]),
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
          pertitionFinished = true;
        });
      }
    }
  }

  addPertitions() {
    for (int i = 0; i < pertitions["Count"]; i++) {
      Circle temp = Circle(
        onTap: () {},
        circleId: CircleId(pertitions["Items"][i]["pertitionid"]),
        strokeColor: circleColor(pertitions["Items"][i]["category"]),
        center: LatLng(10.0, 30.0 + 1),
        strokeWidth: 10,
        radius: 1000,
      );

      setState(() {
        allPertitions.add(temp);
      });
      if (i == pertitions["Count"] - 1) {
        setState(() {
          finished = true;
        });
      }
    }
  }

  @override
  void initState() {
    getPosts();
    //getPertitions();
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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 3,
  );

  Future<void> goToNextLocation(double lat, double lng, int ind) async {
    _controller = await _controller2.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }

  Future<void> goToPrevLocation(double lat, double lng, int ind) async {
    _controller = await _controller2.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }

  Color circleColor(String category) {
    if (category == "pollution") {
      return Colors.red[300];
    }
    if (category == "emissions") {
      return Colors.blueGrey;
    }
    if (category == "general") {
      return Colors.black;
    }
    if (category == "deforestation") {
      return Colors.brown;
    }
    if (category == "water") {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return new Scaffold(
      body: finished == false // || pertitionFinished == false
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
                    mapType: MapType.normal,
                    initialCameraPosition: start,
                    circles: Set<Circle>.of(allPertitions),
                    onCameraMoveStarted: () {},
                    onMapCreated: (GoogleMapController controller) {
                      _controller2.complete(controller);
                      controller.setMapStyle(_mapStyle);
                    },
                    onTap: (LatLng location) {},
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
                              Icon(FlutterIcons.arrow_left_sli, color: white),
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
                /*
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      if (type == 0) {
                        setState(() {
                          type = 1;
                        });
                      } else {
                        setState(() {
                          type = 0;
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      margin: EdgeInsets.only(
                          bottom: height * 0.05, right: width * 0.08),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (type == 0) {
                              setState(() {
                                type = 1;
                              });
                            } else {
                              setState(() {
                                type = 0;
                              });
                            }
                          },
                          child: Icon(
                            FlutterIcons.menu_mdi,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
    );
  }
}
