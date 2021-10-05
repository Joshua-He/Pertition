import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/MapPage/SingleUserMapPage.dart';
import 'package:pertition/PertitionPage/SinglePertition.dart';
import 'package:pertition/constants.dart';

class ProfileSheet extends StatefulWidget {
  final String currentuser;
  final String currentuserscreenname;
  final String currentuserpicture;
  final int currentusertrees;
  final String userid;
  final String screenname;
  final int postcount;
  final int trees;
  final String pertitionid;
  final String profilepicture;
  final String timecreated;

  ProfileSheet({
    this.userid,
    this.timecreated,
    this.currentuser,
    this.currentusertrees,
    this.currentuserpicture,
    this.currentuserscreenname,
    this.screenname,
    this.postcount,
    this.trees,
    this.profilepicture,
    this.pertitionid,
  });
  @override
  _ProfileSheetState createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  Map<String, dynamic> user;

  getUserInfo() {
    getSingleUserInfo('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.54,
      color: white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.1,
                  width: height * 0.1,
                  margin: EdgeInsets.only(
                      top: height * 0.02,
                      left: width * 0.04,
                      right: width * 0.04),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: widget.profilepicture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                        width: width * 0.5,
                        margin: EdgeInsets.only(
                            left: width * 0.02, top: height * 0.02),
                        child: Center(
                          child: Text(widget.screenname,
                              style: TextStyle(fontSize: 24)),
                        )),
                  ],
                ),
              ],
            ),

            ///Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///see pertition
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SinglePertition(
                            userid: widget.currentuser,
                            profilepicture: widget.currentuserpicture,
                            screenname: widget.currentuserscreenname,
                            usertrees: widget.trees,
                            pertitionid: widget.pertitionid),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(left: width * 0.05, top: height * 0.03),
                    padding:
                        EdgeInsets.only(left: width * 0.03, top: height * 0.01),
                    width: width * 0.435,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.green[300]),
                    child: Text("See Pertition",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: white)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleUserMapPage(
                            userid: widget.currentuser,
                            profilepicture: widget.currentuserpicture,
                            height1: height,
                            width1: width,
                            screenname: widget.currentuserscreenname,
                            usertrees: widget.trees,
                            pertitionid: widget.pertitionid),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(left: width * 0.03, top: height * 0.03),
                    padding:
                        EdgeInsets.only(left: width * 0.03, top: height * 0.01),
                    width: width * 0.435,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue[300]),
                    child: Text("See Posts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: white)),
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: height * 0.02),
              child: Row(
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
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: width * 0.43,
                            padding: EdgeInsets.only(
                                top: height * 0.01, left: width * 0.0),
                            height: height * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TreeLogo(),
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.03),
                                  child: Text(widget.trees.toString(),
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
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: black,
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.postcount.toString(),
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
            ),

            Container(
                margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                width: width * 0.435,
                height: height * 0.08,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(parseTime(widget.timecreated),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text("Start Date",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
