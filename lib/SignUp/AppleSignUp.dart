import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pertition/BackendFunctions/SignUp.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/HomePage/HomePage.dart';
import 'package:pertition/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppleSignUpPage extends StatefulWidget {
  final String name;
  final String email;
  final String first;
  final String last;
  final String credential;
  AppleSignUpPage(
      {this.name, this.email, this.first, this.last, this.credential});
  @override
  _AppleSignUpPageState createState() => _AppleSignUpPageState();
}

class _AppleSignUpPageState extends State<AppleSignUpPage> {
  var _controllerUsername = new TextEditingController();
  var _controllerEmail = new TextEditingController();
  int user = 0;
  int emailCheck = 0;
  int isEmail = 0;
  bool useridtaken = false;
  @override
  void initState() {
    if (widget.email == "") {
      isEmail = 1;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    ///widgets
    username() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.1, top: height * 0.04),
            child: Text(
              "Username",
              style: TextStyle(
                  color: user == 1 ? Colors.green[300] : black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.1),
            child: TextField(
              controller: _controllerUsername,
              onChanged: (String value) {
                if (value.length > 1) {
                  setState(() {
                    user = 1;
                  });
                }
                setState(() {
                  getSingleUserInfo(
                          '{"userid": "${_controllerUsername.text.toLowerCase()}"}')
                      .then((value) {
                    if (value["Count"] == 0) {
                      setState(() {
                        useridtaken = false;
                      });
                    } else {
                      setState(() {
                        useridtaken = true;
                      });
                    }
                  });
                });
                if (value.length < 2) {
                  setState(() {
                    user = 0;
                  });
                }
              },
              textAlign: TextAlign.start,
              autofocus: false,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 16,
              ),
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[ /*&#]')),
              ],
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Username",
                  errorText: useridtaken ? 'Username taken' : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
        ],
      );
    }

    email() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.1, top: height * 0.02),
            child: Text(
              "Email",
              style: TextStyle(
                  color: emailCheck == 1 ? Colors.green[300] : black,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.1),
            child: TextField(
              controller: _controllerEmail,
              onChanged: (String value) {
                if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(_controllerEmail.text)) {
                  setState(() {
                    emailCheck = 1;
                  });
                } else {
                  setState(() {
                    emailCheck = 0;
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
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          Container(
            width: width,
            margin: EdgeInsets.only(
                top: height * 0.03, left: width * 0.2, right: width * 0.2),
            child: Center(
                child: Text(
              "Email is not required, but helpful for verification and password reset.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )),
          )
        ],
      );
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///back
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(left: width * 0.05, top: height * .02),
                    child: Icon(
                      FlutterIcons.arrow_left_sli,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * .02),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up With Apple",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),

            username(),
            widget.email == "" ? email() : Container(),

            GestureDetector(
              onTap: () {
                ///shared email
                if (user == 1 && isEmail == 0 && useridtaken == false) {
                  signupApple(
                          '{"userid": "${_controllerUsername.text}", "timecreated": "${DateTime.now()}", "name": "${widget.name}", "credential": "${widget.credential}", "email": "${widget.email}"}')
                      .then((value) async {
                    if (value == 200) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('userid', _controllerUsername.text);

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userid: _controllerUsername.text,
                          ),
                        ),
                      );
                    }
                  });
                }

                if (user == 1 && isEmail == 1 && useridtaken == false) {
                  signupApple(
                          '{"userid": "${_controllerUsername.text.toLowerCase()}", "timecreated": "${DateTime.now()}", "name": "${widget.name}", "credential": "${widget.credential}", "email": "${_controllerEmail.text}", "screenname": "${_controllerUsername.text}"}')
                      .then((value) async {
                    if (value == 200) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(
                          'userid', _controllerUsername.text.toLowerCase());

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userid: _controllerUsername.text.toLowerCase(),
                          ),
                        ),
                      );
                    }
                  });
                }
              },
              child: Container(
                  height: height * 0.06,
                  width: width,
                  margin: EdgeInsets.only(
                    left: width * 0.1,
                    top: height * 0.03,
                    right: width * 0.1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.green[300],
                  ),
                  child: Center(
                      child: Text(
                    "Finish",
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
