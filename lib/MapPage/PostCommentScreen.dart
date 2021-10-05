import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pertition/BackendFunctions/Posts.dart';
import 'package:pertition/constants.dart';

class PostCommentScreen extends StatefulWidget {
  final String userid;
  final String postid;
  final String currentuserpicture;
  final String screenname;
  final double height;
  final double width;

  PostCommentScreen(
      {this.userid,
      this.postid,
      this.currentuserpicture,
      this.screenname,
      this.height,
      this.width});

  @override
  _PostCommentScreenState createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  FocusNode _focusNode = FocusNode();
  var _commentController = new TextEditingController();
  double textfieldPadding = 0;
  Map<String, dynamic> comments;
  ScrollController _scrollController = new ScrollController();
  bool commentsDone = false;
  @override
  void initState() {
    getComments();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          textfieldPadding = widget.height * 0.346;
        });
      } else {
        setState(() {
          textfieldPadding = 0;
        });
      }
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _commentController.dispose();

    super.dispose();
  }

  getComments() async {
    getCommentsOfPost('{"postid": "${widget.postid}"}').then((value) {
      setState(() {
        comments = value;
        commentsDone = true;
      });
    });
  }

  getSortKey(String time, String userid) {
    return time + userid;
  }

  String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
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

    commentList() {
      return Container(
        height: height * 0.5,
        color: Colors.grey.withOpacity(0.05),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: comments["Count"],
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(bottom: height * 0.01),
              padding: EdgeInsets.only(
                  left: width * 0.03,
                  bottom: height * 0.01,
                  top: height * 0.01),
              color: DateTime.now()
                          .difference(DateTime.parse(comments["Items"][index]
                                  ["timecreated"]
                              .substring(0, 26)))
                          .inSeconds <
                      20
                  ? Colors.blue[300].withOpacity(0.1)
                  : null,
              width: width,
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
                          child: comments["Items"][index]["userpicture"] == ""
                              ? CircleAvatar(
                                  radius: height * 0.03,
                                  backgroundColor: Colors.green[300],
                                  child: Center(
                                    child: Text(
                                        utf8convert(comments["Items"][index]
                                                ["screenname"])
                                            .substring(0, 1),
                                        style: TextStyle(
                                            color: white, fontSize: 20)),
                                  ))
                              : CachedNetworkImage(
                                  imageUrl: comments["Items"][index]
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
                                    comments["Items"][index]["screenname"]),
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
                                comments["Items"][index]["comment"],
                              ),
                              style: TextStyle(fontSize: 14),
                              softWrap: true),
                        ),
                        Text(
                          getTime(comments["Items"][index]["timecreated"]
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

    return Container(
      height: height * 0.64,
      color: white,
      padding: EdgeInsets.only(bottom: height * 0.04),
      width: width,
      child: Stack(
        children: [
          //Comment count
          Column(
            children: [
              Container(
                width: width,
                height: height * 0.04,
                color: white,
                child: Center(
                  child: Text(
                      comments == null
                          ? ""
                          : comments["Count"].toString() + " comments",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
              comments == null
                  ? Container(
                      height: height * 0.5,
                      width: width,
                      child:
                          Center(child: SpinKitRing(color: Colors.green[300])))
                  : commentList(),
            ],
          ),

          ///TextField
          Container(
            //  height: height * 0.06,
            width: width,
            color: Colors.white,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            margin: EdgeInsets.only(
                left: width * 0.03,
                top: height * 0.54 - textfieldPadding,
                bottom: textfieldPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (widget.currentuserpicture == "") ||
                        (widget.currentuserpicture == null)
                    ? Container(
                        height: height * 0.04,
                        width: height * 0.04,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green[300]),
                        child: Center(
                            child: Text(
                                utf8convert(widget.screenname).substring(0, 1),
                                style: TextStyle(color: white))),
                      )
                    : Container(
                        height: height * 0.04,
                        width: height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl: widget.currentuserpicture,
                              fit: BoxFit.cover),
                        ),
                      ),

                ///TextField
                Container(
                  //height: height * 0.04,
                  width: width * 0.65,
                  margin:
                      EdgeInsets.only(left: width * 0.03, right: width * 0.015),
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
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ),

                GestureDetector(
                    onTap: () async {
                      ///Send Comment
                      createComment(
                              '{"postid": "${widget.postid}", "userid": "${widget.userid}", "userpicture": "${widget.currentuserpicture}", "timecreated": "${getSortKey(DateTime.now().toString(), widget.userid)}", "screenname": "${utf8convert(widget.screenname)}", "comment": "${_commentController.text}"}')
                          .then((value) {
                        /*
                        Map<String, dynamic> temp = {
                          "postid": widget.postid,
                          "userid": widget.userid,
                          "userpicture": widget.currentuserpicture,
                          "timecreated": getSortKey(
                              DateTime.now().toString(), widget.userid),
                          "screenname": widget.screenname,
                          "comment": _commentController.text,
                        };
*/
                        setState(() {
                          getComments();
                        });

                        _scrollController.animateTo(
                          comments["Count"] * height * 0.09,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 200),
                        );
                      });

                      _commentController.clear();
                      _focusNode.unfocus();
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.13,
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
        ],
      ),
    );
  }
}
