import 'dart:io';

//import 'package:apple_sign_in/apple_sign_in.dart' as i;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetapp/Screens/Tab.dart';
import 'package:meetapp/Screens/Welcome.dart';
import 'package:meetapp/Screens/auth/otp.dart';
import 'package:meetapp/constants/constants.dart';
import 'package:meetapp/models/custom_web_view.dart';
import 'package:meetapp/util/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatelessWidget {
  //Replace your facebook id
  static const your_client_id = '1693284571005074';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const your_redirect_url =
      'https://meet-5b836.firebaseapp.com/__/auth/handler';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Colors.white),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipper2(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        darkPrimaryColor,
                        primaryColor.withOpacity(.15)
                      ])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper3(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        darkPrimaryColor,
                        primaryColor.withOpacity(.2)
                      ])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper1(),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              height: 100,
                              width: 100, // fixed width and height
                              child: Image.asset('assets/logo-white.png')),
                        ],
                      ),
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [primaryColor, primaryColor])),
                    ),
                  ),
                ],
              ),
              Column(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 5),
                  child: Text(
                    "By tapping 'Log in', you agree with our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy."
                        .tr()
                        .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
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
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Center(
                                child: Text(
                                  "LOG IN WITH FACEBOOK".tr().toString(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ))),
                            SizedBox(
                                height: 20,
                                width: 20, // fixed width and height
                                child:
                                    Image.asset('assets/images/facebook.png')),
                          ],
                        ),
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Container(
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: CupertinoActivityIndicator(
                                  key: UniqueKey(),
                                  radius: 20,
                                  animating: true,
                                ))));
                        await handleFacebookLogin(context).then((user) {
                          navigationCheck(user, context);
                        }).then((_) {
                          Navigator.pop(context);
                        }).catchError((e) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ),
                // Platform.isIOS
                //     ? Padding(
                //         padding: const EdgeInsets.only(
                //             bottom: 10.0, left: 30, right: 30),
                //         child: i.AppleSignInButton(
                //           style: i.ButtonStyle.black,
                //           cornerRadius: 50,
                //           type: i.ButtonType.defaultButton,
                //           onPressed: () async {
                //             final FirebaseUser currentUser =
                //                 await handleAppleLogin().catchError((onError) {
                //               SnackBar snackBar =
                //                   SnackBar(content: Text(onError));
                //               _scaffoldKey.currentState!.showSnackBar(snackBar);
                //             });
                //             if (currentUser != null) {
                //               print(
                //                   'usernaem ${currentUser.displayName} \n photourl ${currentUser.photoUrl}');
                //               // await _setDataUser(currentUser);
                //               navigationCheck(currentUser, context);
                //             }
                //           },
                //         ),
                //       )
                Container(),
                // OutlineButton(
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * .065,
                //     width: MediaQuery.of(context).size.width * .75,
                //     child: Center(
                //         child: Text("LOG IN WITH PHONE NUMBER".tr().toString(),
                //             style: TextStyle(
                //                 color: primaryColor,
                //                 fontWeight: FontWeight.bold))),
                //   ),
                //   borderSide: BorderSide(
                //       width: 1, style: BorderStyle.solid, color: primaryColor),
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(25)),
                //   onPressed: () {
                //     bool updateNumber = false;
                //     Navigator.push(
                //         context,
                //         CupertinoPageRoute(
                //             builder: (context) => OTP(updateNumber)));
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
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
                          width: MediaQuery.of(context).size.width * .8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Center(child: Text(
                                "LOG IN WITH PHONE NUMBER".tr().toString(),
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ))),
                              SizedBox(
                                  height: 20,
                                  width: 20, // fixed width and height
                                  child:
                                  Image.asset('assets/images/phone.png')),
                            ],
                          ),),
                      onTap: () async {
                        bool updateNumber = false;
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => OTP(updateNumber)));
                      },
                    ),
                  ),
                ),
              ]),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text(
              //         "Trouble logging in?".tr().toString(),
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 12,
              //             fontWeight: FontWeight.normal),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Privacy Policy".tr().toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 13),
                    ),
                    onTap: () => _launchURL(
                        "https://www.privacypolicygenerator.info/live.php?token=lAg44lrhZYKsx5cRfBnJ169DJUPh94Uo"), //TODO: add privacy policy
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue),
                  ),
                  GestureDetector(
                    child: Text(
                      "Terms & Conditions".tr().toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 13),
                    ),
                    onTap: () => _launchURL(
                        "https://www.privacypolicygenerator.info/live.php?token=lAg44lrhZYKsx5cRfBnJ169DJUPh94Uo"), //TODO: add Terms and conditions
                  ),
                ],
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Language')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          // child: Text('Lanuage not Found'),
                          );
                    }
                    return Column(
                      children: snapshot.data!.docs.map((document) {
                        if (document['spanish'] == true &&
                            document['english'] == true) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text(
                                  "English".tr().toString(),
                                  style: TextStyle(color: Colors.pink),
                                ),
                                onPressed: () {
                                  EasyLocalization.of(context)!
                                      .setLocale(Locale('en', 'US'));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ));
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Spanish".tr().toString(),
                                  style: TextStyle(color: Colors.pink),
                                ),
                                onPressed: () {
                                  EasyLocalization.of(context)!
                                      .setLocale(Locale('es', 'ES'));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ));
                                },
                              ),
                            ],
                          );
                        } else {
                          return Text('');
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return _onWillPop(context);
      },
    );
  }

  Future<User> handleFacebookLogin(context) async {
    late User user;
    // String result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => CustomWebView(
    //             selectedUrl:
    //                 'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
    //           ),
    //       maintainState: true),
    // );

    final LoginResult result = await FacebookAuth.instance.login();
    if (true) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.credential(result.accessToken!.token);
        user =
            (await FirebaseAuth.instance.signInWithCredential(facebookAuthCred))
                .user!;

        print('user $user');
      } catch (e) {
        print('Error $e');
      }
    }
    return user;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(User currentUser, context) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: currentUser.uid)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data()['location'] != null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Welcome()));
        }
      } else {
        await _setDataUser(currentUser);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Welcome()));
      }
    });
  }

  /*Future<FirebaseUser> handleAppleLogin() async {
    late FirebaseUser user;
    if (await i.AppleSignIn.isAvailable()) {
      try {
        final i.AuthorizationResult result =
            await i.AppleSignIn.performRequests([
          i.AppleIdRequest(requestedScopes: [i.Scope.email, i.Scope.fullName])
        ]).catchError((onError) {
          print("inside $onError");
        });

        switch (result.status) {
          case i.AuthorizationStatus.authorized:
            try {
              print("successfull sign in");
              final i.AppleIdCredential appleIdCredential = result.credential;

              OAuthProvider oAuthProvider =
                  new OAuthProvider(providerId: "apple.com");
              final AuthCredential credential = oAuthProvider.getCredential(
                idToken: String.fromCharCodes(appleIdCredential.identityToken),
                accessToken:
                    String.fromCharCodes(appleIdCredential.authorizationCode),
              );

              user = (await _auth.signInWithCredential(credential)).user;
              print("signed in as " + user.toString());
            } catch (error) {
              print("Error $error");
            }
            break;
          case i.AuthorizationStatus.error:
            // do something

            _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text('An error occured. Please Try again.'),
              duration: Duration(seconds: 8),
            ));

            break;

          case i.AuthorizationStatus.cancelled:
            print('User cancelled');
            break;
        }
      } catch (error) {
        _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text('$error.'),
          duration: Duration(seconds: 8),
        ));
        print("error with apple sign in");
      }
    } else {
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Apple SignIn is not available for your device'),
        duration: Duration(seconds: 8),
      ));
    }
    return user;
  }*/

  Future<bool> _onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'.tr().toString()),
          content: Text('Do you want to exit the app?'.tr().toString()),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'.tr().toString()),
            ),
            FlatButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text('Yes'.tr().toString()),
            ),
          ],
        );
      },
    );
    return true;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future _setDataUser(User user) async {
  await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      // 'Pictures': FieldValue.arrayUnion([
      //   user.photoURL != null
      //       ? user.photoURL! + '?width=9999'
      //       : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s'
      // ]),
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
    //merge: true,
  );
}
