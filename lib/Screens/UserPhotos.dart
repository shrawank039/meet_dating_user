import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as i;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetapp/Screens/University.dart';
import 'package:meetapp/util/color.dart';
import 'package:meetapp/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user_model.dart';

class UserPhotos extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserPhotos(this.userData);

  @override
  _UserPhotosState createState() => _UserPhotosState();
}

class _UserPhotosState extends State<UserPhotos> {

  List? imageUrl = [];

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
      body: Column(
        children: <Widget>[
          Padding(
            child: ListTile(
              title: Text(
                "Add Photos".tr().toString(),
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Text(
                "Add at least 2 photos to continue."
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
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio:
                            MediaQuery.of(context).size.aspectRatio * 1.5,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(6, (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: imageUrl!.length > index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: secondryColor)),
                                child: Stack(
                                  children: <Widget>[
                                    imageUrl!.length > index
                                        ?
                                    Image.file(
                                      File(imageUrl![index]),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .2,
                                      fit: BoxFit.cover,
                                    )
                                    // CachedNetworkImage(
                                    //         height: MediaQuery.of(context)
                                    //                 .size
                                    //                 .height *
                                    //             .2,
                                    //         fit: BoxFit.cover,
                                    //         imageUrl: imageUrl![index] ?? '',
                                    //         placeholder: (context, url) =>
                                    //             Center(
                                    //           child: CupertinoActivityIndicator(
                                    //             radius: 10,
                                    //           ),
                                    //         ),
                                    //         errorWidget:
                                    //             (context, url, error) => Center(
                                    //           child: Column(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.center,
                                    //             children: <Widget>[
                                    //               Icon(
                                    //                 Icons.error,
                                    //                 color: Colors.black,
                                    //                 size: 25,
                                    //               ),
                                    //               Text(
                                    //                 "Enable to load"
                                    //                     .tr()
                                    //                     .toString(),
                                    //                 style: TextStyle(
                                    //                   color: Colors.black,
                                    //                 ),
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       )
                                        : Container(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          // width: 12,
                                          // height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: imageUrl!.length > index
                                                ? Colors.white
                                                : primaryColor,
                                          ),
                                          child: imageUrl!.length > index
                                              ? InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: primaryColor,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (imageUrl!.length > 1) {
                                                      _deletePicture(index);
                                                    } else {
                                                      source(context, true);
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () =>
                                                      source(context, false),
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ]),
          ),
          imageUrl!.length>0
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
                          widget.userData.addAll({'imageUrl': imageUrl});
                        print(imageUrl);
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

  Future source(BuildContext context, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(isProfilePicture
                  ? "Update profile picture".tr().toString()
                  : "Add pictures".tr().toString()),
              content: Text(
                "Select source".tr().toString(),
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: imageUrl!.length < 6
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 28,
                              ),
                              Text(
                                " Camera".tr().toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context,
                                      isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 28,
                              ),
                              Text(
                                " Gallery".tr().toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context,
                                      isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              "Can't upload more than 6 pictures"
                                  .tr()
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(ImageSource imageSource, context, isProfilePicture) async {
    try {
      var image = await ImagePicker.platform.pickImage(source: imageSource);
      if (image != null) {
        File? croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        if (croppedFile != null) {
          await uploadFile(await compressimage(croppedFile), isProfilePicture);
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, isProfilePicture) async {
    print(image.path+' '+image.hashCode.toString()+' '+isProfilePicture.toString());
    setState(() {
      imageUrl!.add(image.path);
    });
  }

  void _deletePicture(index) async {
    setState(() {
      imageUrl!.removeAt(index);
    });
  }

  Future compressimage(File image) async {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String randomTxt = String.fromCharCodes(Iterable.generate(
        3, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image? imagefile = i.decodeImage(image.readAsBytesSync());
    final compressedImagefile = File('$path$randomTxt.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));
    // setState(() {
    return compressedImagefile;
    // });
  }
}
