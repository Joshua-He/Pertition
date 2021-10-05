import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pertition/BackendFunctions/Pertitions.dart';
import 'package:pertition/BackendFunctions/UploadMedia.dart';
import 'package:pertition/BackendFunctions/User.dart';
import 'package:pertition/SplashPage/SplashPage.dart';
import 'package:pertition/constants.dart';
import 'package:pertition/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAccountPage extends StatefulWidget {
  final String userid;
  UserAccountPage({this.userid});
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  Map<String, dynamic> user;
  String phone = "";
  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('userid', "");
    });
  }

  getUserInfo() {
    getSingleUserInfo('{"userid": "${widget.userid}"}').then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  awaitPhoneConfirmed() async {
    phone = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPhone(
          userid: widget.userid,
          phone: user["Items"][0]["phone"],
        ),
      ),
    );

    return phone;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    name() {
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: width * 0.9,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17, color: black),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.01),
                child: Text(
                  utf8convert(user["Items"][0]["name"]),
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      );
    }

    nonVerifiedPhone() {
      return GestureDetector(
        onTap: () {
          awaitPhoneConfirmed();
        },
        child: Container(
          width: width * 0.9,
          color: white,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.03),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: black),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: Text(
                      "No Phone Added",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin:
                      EdgeInsets.only(top: height * 0.02, right: width * 0.03),
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.green[300], fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    verifiedPhone() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhone(
                userid: widget.userid,
                phone: user["Items"][0]["phone"],
              ),
            ),
          );
        },
        child: Container(
          width: width * 0.9,
          color: white,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.03),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: black),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: Text(
                      user["Items"][0]["phone"],
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin:
                      EdgeInsets.only(top: height * 0.02, right: width * 0.03),
                  child: Text(
                    "Change",
                    style: TextStyle(color: Colors.green[300], fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    email() {
      return GestureDetector(
        onTap: () {},
        child: Container(
          width: width * 0.9,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17, color: black),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.01),
                child: Text(
                  user["Items"][0]["email"],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      );
    }

    verifiedEmail() {}

    ///member start date and posts
    datePosts() {
      return Container(
          width: width * 0.9,
          margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(right: width * 0.04),
                  width: width * 0.43,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                            fontSize: 21,
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
              Container(
                width: width * 0.43,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(
                            top: height * 0.01, left: width * 0.0),
                        height: height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TreeLogo(),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.03),
                              child: Text(user["Items"][0]["trees"].toString(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }

    logoutButton() {
      return GestureDetector(
        onTap: () {
          showMaterialModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: height * 0.15,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashPage(),
                        ),
                      );
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
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Confirm Log out",
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
          width: width * 0.38,
          height: height * 0.05,
          margin: EdgeInsets.only(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: Colors.red[300]),
          child: Center(
            child: Text("Log Out",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      );
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
        backgroundColor: white,
        body: user == null
            ? Center(
                child: SpinKitRing(
                  color: Colors.green[300],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Cancel
                    Container(
                      height: height * 0.04,
                      padding: EdgeInsets.only(
                          top: height * 0.01, left: width * 0.04),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, size: 35),
                      ),
                    ),

                    ///userid and profile picture
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///Profile Picture
                        GestureDetector(
                          onTap: () {
                            uploadProfilePicture(widget.userid).then((value) {
                              if (value != null) {
                                updateUserProfilePicture(
                                    '{"userid": "${widget.userid}", "profilepicture": "$value"}');
                              }
                            });
                          },
                          child: Container(
                            height: height * 0.10,
                            width: height * 0.10,
                            margin: EdgeInsets.only(
                                top: height * 0.04,
                                left: width * 0.04,
                                right: width * 0.03),
                            child: user["Items"][0]["profilepicture"] == ""
                                ? CircleAvatar(
                                    backgroundColor: Colors.green[300],
                                    radius: height * 0.05,
                                    child: Center(
                                      child: Text(
                                        utf8convert(user["Items"][0]["userid"])
                                            .substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 24, color: white),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      user["Items"][0]["profilepicture"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),

                        ///Userid
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.6,
                              margin: EdgeInsets.only(
                                  top: height * 0.04, left: width * 0.04),
                              child: Text(
                                  utf8convert(user["Items"][0]["screenname"]),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 24)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    name(),
                    email(),

                    ///Verify Phone for 100 trees
                    user["Items"][0]["phone"] == ""
                        ? nonVerifiedPhone()
                        : verifiedPhone(),

                    Padding(
                      padding: EdgeInsets.only(top: height * 0.07),
                      child: Center(child: logoutButton()),
                    ),

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
                          margin: EdgeInsets.only(
                            top: height * 0.01,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: width * 0.38,
                            alignment: Alignment.center,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Help / Suggestions",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold)),
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

class VerifyPhone extends StatefulWidget {
  final String userid;
  final String phone;
  VerifyPhone({this.userid, this.phone});
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  var _phone = new TextEditingController();
  int color1 = 0;
  String phone1 = "";
  FToast fToast;
  @override
  void initState() {
    _phone.text = widget.phone;
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showToast() {
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
            Icons.check,
            color: white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("Phone confirmed: ${_phone.text}",
              style: TextStyle(color: white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 3),
    );

    // Custom Toast Position
    /*
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
        */
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;

    phone() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: height * 0.04),
            child: Text(
              "Phone",
              style: TextStyle(
                  color: color1 == 1 ? Colors.green : black,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
          ),

          ///Phone textfield
          Container(
            alignment: Alignment.center,
            child: TextField(
              controller: _phone,
              onChanged: (String value) {
                if (RegExp(
                        r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$")
                    .hasMatch(_phone.text)) {
                  setState(() {
                    color1 = 1;
                  });
                } else {
                  setState(() {
                    color1 = 0;
                  });
                }
              },
              textAlign: TextAlign.center,
              autofocus: true,
              keyboardType: TextInputType.phone,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 30,
              ),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Phone",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )),
            ),
          ),
        ],
      );
    }

    return ColorfulSafeArea(
      color: white,
      child: Scaffold(
        backgroundColor: white,
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: width * 0.0, top: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.04,
                margin: EdgeInsets.only(left: width * 0.06),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 35),
                ),
              ),
              phone(),
              GestureDetector(
                onTap: () {
                  if (color1 == 1) {
                    confirmUserPhone(
                            '{"userid": "${widget.userid}", "phone": "${_phone.text}"}')
                        .then((value) {
                      if (value == 200) {
                        Navigator.pop(context);
                        _showToast();
                      }
                    });
                  }
                },
                child: Container(
                    margin:
                        EdgeInsets.only(left: width * 0.2, top: height * 0.3),
                    width: width * 0.6,
                    height: height * 0.06,
                    decoration: BoxDecoration(
                      color: color1 == 1
                          ? Colors.green[300]
                          : Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text("Confirm",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
