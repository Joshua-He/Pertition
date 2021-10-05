import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pertition/BackendFunctions/Pertitions.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/constants.dart';
import 'package:pertition/main.dart';

class PertitionMessagePage extends StatefulWidget {
  final String userid;
  final String postid;
  final String currentuserpicture;
  final String screenname;

  PertitionMessagePage({
    this.userid,
    this.postid,
    this.currentuserpicture,
    this.screenname,
  });
  @override
  _PertitionMessagePageState createState() => _PertitionMessagePageState();
}

class _PertitionMessagePageState extends State<PertitionMessagePage> {
  Map<String, dynamic> messages;
  var _commentController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode _focusNode = FocusNode();
  Timer _timer;
  getComments() async {
    getMessageOfPertition('{"messageid": "${widget.postid}"}').then((value) {
      setState(() {
        messages = value;
      });
    });
  }

  @override
  void initState() {
    getComments();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      getComments();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _commentController.dispose();
    super.dispose();
    _timer.cancel();
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

  getSortKey(String time, String userid) {
    return time + userid;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    commentList() {
      return Container(
        height: height * 0.78,
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: messages["Count"],
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(bottom: height * 0.01),
              padding: EdgeInsets.only(
                  left: width * 0.03,
                  bottom: height * 0.01,
                  top: height * 0.01),
              width: width,
              color: DateTime.now()
                          .difference(DateTime.parse(messages["Items"][index]
                                  ["timecreated"]
                              .substring(0, 26)))
                          .inSeconds <
                      20
                  ? Colors.blue[300].withOpacity(0.1)
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        height: height * 0.036,
                        width: height * 0.036,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: messages["Items"][index]["userpicture"] == ""
                              ? CircleAvatar(
                                  backgroundColor: Colors.green[300],
                                  child: Center(
                                    child: Text(
                                        utf8convert(messages["Items"][index]
                                                ["screenname"])
                                            .substring(0, 1),
                                        style: TextStyle(
                                            color: white, fontSize: 16)),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: messages["Items"][index]
                                      ["userpicture"],
                                  fit: BoxFit.cover),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: height * 0.006),
                          child: Row(
                            children: [
                              Text(
                                utf8convert(
                                    messages["Items"][index]["screenname"]),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.7,
                          margin: EdgeInsets.only(bottom: height * 0.006),
                          child: Text(
                              utf8convert(
                                messages["Items"][index]["comment"],
                              ),
                              style: TextStyle(fontSize: 14),
                              softWrap: true),
                        ),
                        Text(
                          getTime(messages["Items"][index]["timecreated"]
                              .substring(0, 25)),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                  child: Icon(FlutterIcons.arrow_left_sli, size: 25),
                ),
              ),
              Container(),
              Container(
                //  height: height * 0.06,
                height: height * 0.12,
                width: width,
                color: Colors.white,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                margin: EdgeInsets.only(
                    left: width * 0.02,
                    top: height * 0.02,
                    bottom: height * 0.02),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///TextField
                    Container(
                      //height: height * 0.04,
                      width: width * 0.73,
                      margin: EdgeInsets.only(
                          left: width * 0.03, right: width * 0.015),
                      padding: EdgeInsets.only(
                          bottom: height * 0.00, right: width * 0.03),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: _commentController,
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        focusNode: _focusNode,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: width * 0.03,
                                bottom: width * 0.0,
                                top: height * 0.005),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                    ),

                    GestureDetector(
                        onTap: () async {
                          ///Send Comment
                          createPertitionMessage(
                                  '{"messageid": "${widget.postid}", "userid": "${widget.userid}", "userpicture": "${widget.currentuserpicture}", "timecreated": "${getSortKey(DateTime.now().toString(), widget.userid)}", "screenname": "${widget.screenname}", "comment": "${_commentController.text}"}')
                              .then((value) {
                            setState(() {
                              getComments();
                            });

                            _scrollController.animateTo(
                              messages["Count"] * height * 0.09,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 100),
                            );
                          });

                          _commentController.clear();
                          _focusNode.unfocus();
                        },
                        child: Container(
                          height: height * 0.1,
                          width: width * 0.15,
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Icon(
                            FlutterIcons.send_fea,
                            color: Colors.white,
                            size: 24,
                          )),
                        ))
                  ],
                ),
              ),
              messages == null
                  ? Container(
                      height: height * 0.5,
                      width: width,
                      child:
                          Center(child: SpinKitRing(color: Colors.green[300])))
                  : commentList(),
            ],
          )),
    );
  }
}
