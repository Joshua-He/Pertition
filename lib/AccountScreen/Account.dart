import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pertition/SplashPage/SplashPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  final String userid;

  AccountScreen({this.userid});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('userid', "");
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          signOut();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashPage(),
            ),
          );
        },
        child: Container(
          height: height,
          width: width,
          child: GestureDetector(
            onTap: () {
              signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashPage(),
                ),
              );
            },
            child: Container(
              height: 100,
              width: width,
              color: Colors.red,
              child: Text("widget.userid"),
            ),
          ),
        ));
  }
}
