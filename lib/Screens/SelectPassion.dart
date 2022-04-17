import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/Screens/University.dart';
import 'package:meetapp/util/color.dart';
import 'package:meetapp/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectPassion extends StatefulWidget {
  final Map<String, dynamic> userData;

  SelectPassion(this.userData);

  @override
  _SelectPassionState createState() => _SelectPassionState();
}

class _SelectPassionState extends State<SelectPassion> {
  bool man = false;
  bool woman = false;
  bool eyeryone = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IconButton(
            color: secondryColor,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          Padding(
            child: ListTile(
              title: Text(
                "Passion".tr().toString(),
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Text(
                "Let everyone know what you're passionate about by adding it to your profile"
                    .tr()
                    .toString(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400),
              ),
            ),
            padding: EdgeInsets.only(left: 20, top: 100),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        side: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: man ? primaryColor : secondryColor),
                      ),
                      child: Container(
                        child: Center(
                            child: Text("MEN".tr().toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: man ? primaryColor : secondryColor,
                                    fontWeight: FontWeight.bold))),
                      ),
                      onPressed: () {
                        setState(() {
                          woman = false;
                          man = true;
                          eyeryone = false;
                        });
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(direction: Axis.vertical, children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        side: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: woman ? primaryColor : secondryColor),
                      ),
                      child: Container(
                        child: Center(
                            child: Text("WOMEN".tr().toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: woman ? primaryColor : secondryColor,
                                    fontWeight: FontWeight.bold))),
                      ),
                      onPressed: () {
                        setState(() {
                          woman = true;
                          man = false;
                          eyeryone = false;
                        });
                        // Navigator.push(
                        //     context, CupertinoPageRoute(builder: (context) => OTP()));
                      },
                    )
                  ]),
                ),
                Wrap(direction: Axis.vertical, children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      side: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: eyeryone ? primaryColor : secondryColor),
                    ),
                    child: Container(
                      child: Center(
                          child: Text("EVERYONE".tr().toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      eyeryone ? primaryColor : secondryColor,
                                  fontWeight: FontWeight.bold))),
                    ),
                    onPressed: () {
                      setState(() {
                        woman = false;
                        man = false;
                        eyeryone = true;
                      });
                      // Navigator.push(
                      //     context, CupertinoPageRoute(builder: (context) => OTP()));
                    },
                  )
                ]),
              ],
            ),
          ),
          man || woman || eyeryone
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 40),
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
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () {
                        if (man) {
                          widget.userData.addAll({'showGender': "man"});
                        } else if (woman) {
                          widget.userData.addAll({'showGender': "woman"});
                        } else {
                          widget.userData.addAll({'showGender': "everyone"});
                        }

                        print(widget.userData);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    University(widget.userData)));
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: secondryColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () {
                        CustomSnackbar.snackbar(
                            "Please select one".tr().toString(), _scaffoldKey);
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
