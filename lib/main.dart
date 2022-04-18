import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetapp/Screens/SelectPassion.dart';
import 'package:meetapp/Screens/Splash.dart';
import 'package:meetapp/Screens/Tab.dart';
import 'package:meetapp/Screens/UserPhotos.dart';
import 'package:meetapp/Screens/Welcome.dart';
import 'package:meetapp/Screens/auth/login.dart';
import 'package:meetapp/constants/constants.dart';
import 'package:meetapp/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Screens/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    InAppPurchaseConnection.enablePendingPurchases();
    //runApp(new MyApp());
    runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('es', 'ES')],
      path: 'assets/translation',
      saveLocale: true,
      fallbackLocale: Locale('en', 'US'),
      child: new MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    MobileAds.instance.initialize();
    _getLanguage();
  }

  Future _checkAuth() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = await _auth.currentUser;
    //_auth.currentUser.().then((User user) async {
    //print(user!.uid);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((QuerySnapshot snapshot) async {
        if (snapshot.docs.length > 0) {
          if (snapshot.docs[0].data()['location'] != null) {
            setState(() {
              isRegistered = true;
              isLoading = false;
            });
          } else {
            setState(() {
              isAuth = true;
              isLoading = false;
            });
          }
          print("loggedin ${user.uid}");
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    //});
  }

  _getLanguage() async {
    var itemList = await FirebaseFirestore.instance
        .collection('Language')
        .doc('present_languages')
        .get();

    if (itemList.data()!['spanish'] == true &&
        itemList.data()!['english'] == false) {
      setState(() {
        EasyLocalization.of(context)?.setLocale(Locale('es', 'ES'));
      });
    }
    if (itemList.data()!['english'] == true &&
        itemList.data()!['spanish'] == false) {
      setState(() {
        EasyLocalization.of(context)?.setLocale(Locale('en', 'US'));
      });
    }

    return EasyLocalization.of(context)?.locale;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: Constants.POPPINS,
        primaryColor: primaryColor,
      ),
      home: isLoading
          ? Splash()
          : isRegistered
              ? Tabbar(null, null)
              : isAuth
                  ? Welcome()//Welcome()
                  : Login(), //Login()
    );
  }
}
