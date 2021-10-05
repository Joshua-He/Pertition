import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pertition/BackendFunctions/SignUp.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/HomePage/HomePage.dart';
import 'package:pertition/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String namePattern = r'^[a-z A-Z,.\-]+$';
  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  var _controllerFirst = new TextEditingController();
  var _controllerEmail = new TextEditingController();
  var _controllerUsername = new TextEditingController();
  var _controllerPassword = new TextEditingController();
  int color1 = 0;
  int user = 0;
  int color3 = 0;
  int color4 = 0;
  bool useridtaken = false;
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
    if (color1 == 1 && color3 == 1 && color4 == 1 && user == 1) {
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
              "Name",
              style: TextStyle(
                  color: color1 == 1 ? Colors.green[300] : black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              controller: _controllerFirst,
              inputFormatters: [
                //FilteringTextInputFormatter.allow(RegExp(namePattern)),
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
                fontSize: 15,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "First Last",
                  hintStyle: TextStyle(color: Colors.grey)),
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
            margin: EdgeInsets.only(left: width * 0.06, top: height * 0.02),
            child: Text(
              "Email",
              style: TextStyle(
                  color: color3 == 1 ? Colors.green[300] : black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              controller: _controllerEmail,
              onChanged: (String value) {
                if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(_controllerEmail.text)) {
                  setState(() {
                    color3 = 1;
                  });
                } else {
                  setState(() {
                    color3 = 0;
                  });
                }
              },
              textAlign: TextAlign.start,
              autofocus: false,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 15,
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
        ],
      );
    }

    username() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.06, top: height * 0.02),
            child: Text(
              "Username",
              style: TextStyle(
                  color: user == 1 ? Colors.green[300] : black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              controller: _controllerUsername,
              onChanged: (String value) {
                if (value.length > 1) {
                  setState(() {
                    user = 1;
                  });
                }

                if (value.length < 2) {
                  setState(() {
                    user = 0;
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
              },
              textAlign: TextAlign.start,
              autofocus: false,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 15,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: width * 0.9,
            margin: EdgeInsets.only(left: width * 0.06),
            child: TextField(
              obscureText: obscure,
              controller: _controllerPassword,
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[ ]')),
              ],
              onChanged: (String value) {
                if (RegExp(
                        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
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
                  hintText: "Password (8+, 1+ Number, 1+ special character)",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
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
                        EdgeInsets.only(top: width * .01, left: width * .27),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              ///First Name
              firstName(),

              email(),
              username(),
              password(),
              Container(
                height: height * 0.01,
              ),
              /*
              //User check
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (checked == 0) {
                        setState(() {
                          checked = 1;
                        });
                      } else {
                        setState(() {
                          checked = 0;
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.027,
                      width: height * 0.027,
                      margin: EdgeInsets.only(
                          left: width * 0.06, top: height * 0.01),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: checked == 1 ? Colors.greenAccent : black,
                              width: 2),
                          color:
                              checked == 1 ? Colors.green : Colors.transparent),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: width * 0.02, top: height * 0.01),
                    child: RichText(
                      text: new TextSpan(
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        children: <TextSpan>[
                          new TextSpan(
                            text: "  I agree to the ",
                            style: TextStyle(color: black, fontSize: 16),
                          ),
                          new TextSpan(
                            text: "User Agreement",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              */
//Button
              GestureDetector(
                onTap: () async {
                  if (color1 == 1 &&
                      color3 == 1 &&
                      color4 == 1 &&
                      user == 1 &&
                      useridtaken == false) {
                    print(useridtaken);
                    signup('{"name": "${_controllerFirst.text}", "timecreated": "${DateTime.now()}","email": "${_controllerEmail.text}", "password": "${_controllerPassword.text}", "userid": "${_controllerUsername.text.toLowerCase()}", "screenname": "${_controllerUsername.text}"}')
                        .then((value) async {
                      if (value == 200) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString(
                            'userid', _controllerUsername.text.toLowerCase());
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
                  width: width * 0.38,
                  height: height * 0.055,
                  margin:
                      EdgeInsets.only(left: width * 0.31, top: height * 0.05),
                  decoration: BoxDecoration(
                    color: check(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
