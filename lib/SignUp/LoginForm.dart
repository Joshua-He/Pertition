import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:pertition/BackendFunctions/SignUp.dart';
import 'package:pertition/HomePage/HomePage.dart';
import 'package:pertition/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  String namePattern = r'^[a-z A-Z,.\-]+$';
  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  var _controllerFirst = new TextEditingController();
  var _controllerPassword = new TextEditingController();
  int color1 = 0;
  int user = 0;
  int color3 = 0;
  int color4 = 0;

  int checked = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggle() {
    setState(() {
      obscure = !obscure;
    });
  }

  Color check() {
    if (color1 == 1 && color4 == 1) {
      return Colors.green[300];
    } else {
      return Colors.grey;
    }
  }

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    firstName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.06, top: height * 0.04),
            child: Text(
              "Username",
              style: TextStyle(
                  color: color1 == 1 ? Colors.green[300] : black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              controller: _controllerFirst,
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[/*&#]')),
                // FilteringTextInputFormatter.allow(RegExp(namePattern)),
              ],
              onChanged: (String value) {
                if (value.length > 1) {
                  setState(() {
                    color1 = 1;
                  });
                }

                if (value.length < 2) {
                  setState(() {
                    color1 = 0;
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
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      );
    }

    password() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.06, top: height * 0.02),
            child: Text(
              "Password",
              style: TextStyle(
                  color: color4 == 1 ? Colors.green[300] : black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              obscureText: obscure,
              controller: _controllerPassword,
              onChanged: (String value) {
                if (RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$")
                    .hasMatch(_controllerPassword.text)) {
                  setState(() {
                    color4 = 1;
                  });
                } else {
                  setState(() {
                    color4 = 0;
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
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _toggle();
                    },
                    child: Icon(
                      Icons.visibility,
                    ),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Password (8+, 1+ Upper, 1+ Number)",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      );
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Back/Cancel button
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: width * 0.06, top: width * .01),
                      child: Icon(
                        FlutterIcons.arrow_left_sli,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: width * .01, left: width * .31),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              ///First Name
              firstName(),

              password(),
              Container(
                height: height * 0.01,
              ),

//Button
              GestureDetector(
                onTap: () async {
                  if (color1 == 1 && color4 == 1) {
                    //'{"userid": "${_controllerFirst.text}", "password": "${_controllerPassword.text}"}'
                    login('{"userid": "${_controllerFirst.text}", "password": "${_controllerPassword.text}"}')
                        .then((value) async {
                      Navigator.pop(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(
                          'userid', _controllerFirst.text.toLowerCase());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userid: _controllerFirst.text.toLowerCase(),
                          ),
                        ),
                      );
                    });
                  }
                },
                child: Container(
                  width: width * 0.38,
                  height: height * 0.05,
                  margin: EdgeInsets.only(
                      left: width * 0.31,
                      top: height * 0.05,
                      right: width * 0.31),
                  decoration: BoxDecoration(
                    color: check(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
