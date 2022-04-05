import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/Screens/UserDOB.dart';
import 'package:meetapp/Screens/UserName.dart';
import 'package:meetapp/constants/constants.dart';
import 'package:meetapp/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                      Center(
                        child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              "assets/logo.png",
                              fit: BoxFit.contain,
                            )),
                      ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Welcome to MeetApp",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23,
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: Constants.POPPINS),
                          ),
                          subtitle: Text(
                            "Please follow these House Rules.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                            fontFamily: Constants.OPEN_SANS),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 20, top: 8, right: 10, bottom: 8),
                          leading: SizedBox(
                              height: 25,
                              width: 25, // fixed width and height
                              child: Image.asset('assets/images/check_mark.png')
                          ),
                          title: Text(
                            "Be yourself.".tr().toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700,
                            color: Colors.grey.shade700,
                            fontFamily: Constants.OPEN_SANS),
                          ),
                          subtitle: Text(
                            "Make sure your photos, age, and bio are true to who you are.".tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade500,
                              fontFamily: Constants.OPEN_SANS,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 20, top: 8, right: 10, bottom: 8),
                          leading: SizedBox(
                              height: 25,
                              width: 25, // fixed width and height
                              child: Image.asset('assets/images/check_mark.png')
                          ),
                          title: Text(
                            "Play it cool.".tr().toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                                fontFamily: Constants.OPEN_SANS),
                          ),
                          subtitle: Text(
                            "Respect other and treat them as you would like to be treated".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                                fontFamily: Constants.OPEN_SANS,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 20, top: 8, right: 10, bottom: 8),
                          leading: SizedBox(
                              height: 25,
                              width: 25, // fixed width and height
                              child: Image.asset('assets/images/check_mark.png')
                          ),
                          title: Text(
                            "Stay safe.".tr().toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                                fontFamily: Constants.OPEN_SANS),
                          ),
                          subtitle: Text(
                            "Don't be too quick to give out personal information.".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                                fontFamily: Constants.OPEN_SANS,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 20, top: 8, right: 10, bottom: 8),
                          leading: SizedBox(
                              height: 25,
                              width: 25, // fixed width and height
                              child: Image.asset('assets/images/check_mark.png')
                          ),
                          title: Text(
                            "Be proactive.".tr().toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                                fontFamily: Constants.OPEN_SANS),
                          ),
                          subtitle: Text(
                            "Always report bad behavior.".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                                fontFamily: Constants.OPEN_SANS,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor
                                ])),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          "I Agree".tr().toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      //await FirebaseAuth.instance.currentUser().then((_user) {
                      final _user = await FirebaseAuth.instance.currentUser!;
                        if (_user.displayName != null) {
                          if (_user.displayName!.length > 0) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserDOB(
                                        {'UserName': _user.displayName})));
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserName()));
                          }
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserName()));
                        }
                      //});
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
