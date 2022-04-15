import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/Screens/Chat/Matches.dart';
import 'package:meetapp/Screens/Chat/chatPage.dart';
import 'package:meetapp/models/user_model.dart';
import 'package:meetapp/util/color.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import '../Payment/subscriptions.dart';

class RecentChats extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final User currentUser;
  final bool isPuchased;
  final List<User> matches;

  RecentChats(this.currentUser, this.matches, this.isPuchased);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: ListView(
                  physics: ScrollPhysics(),
                  children: matches
                      .map((index) => GestureDetector(
                            onTap: () => currentUser.editInfo!['userGender']=="man" && !isPuchased
                                ? showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Subscription Alert'),
                                  content: Text('You do not have any active subscription. Please get any premium subscription to connect, chat, call.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('View Plans'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Subscription(
                                                  currentUser, null, new Map())),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                                : Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ChatPage(
                                  chatId: chatId(currentUser, index),
                                  sender: currentUser,
                                  second: index,
                                ),
                              ),
                            ),
                            child: StreamBuilder(
                                stream: db
                                    .collection("chats")
                                    .doc(chatId(currentUser, index))
                                    .collection('messages')
                                    .orderBy('time', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData)
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  else if (snapshot.data!.docs.length ==
                                      0) {
                                    return Container();
                                  }
                                  index.lastmsg =
                                      snapshot.data!.docs[0]['time'];
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0, right: 20.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: snapshot.data!.docs[0]
                                                      ['sender_id'] !=
                                                  currentUser.id &&
                                              !snapshot.data!.docs[0]
                                                  ['isRead']
                                          ? primaryColor.withOpacity(.1)
                                          : secondryColor.withOpacity(.2),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: secondryColor,
                                        radius: 30.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child: CachedNetworkImage(
                                            imageUrl: index.imageUrl![0] ?? '',
                                            useOldImageOnUrlChange: true,
                                            placeholder: (context, url) =>
                                                CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        index.name!,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[0]['image_url']
                                                    .toString()
                                                    .length >
                                                0
                                            ? "Photo"
                                            : snapshot.data!.docs[0]
                                                ['text'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!.docs[0]
                                                        ["time"] !=
                                                    null
                                                ? DateFormat.MMMd('en_US')
                                                    .add_jm()
                                                    .format(snapshot.data!
                                                        .docs[0]["time"]
                                                        .toDate())
                                                    .toString()
                                                : "",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          snapshot.data!.docs[0]
                                                          ['sender_id'] !=
                                                      currentUser.id &&
                                                  !snapshot.data!.docs[0]
                                                      ['isRead']
                                              ? Container(
                                                  width: 35,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'NEW',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                          snapshot.data!.docs[0]
                                                      ['sender_id'] ==
                                                  currentUser.id
                                              ? !snapshot.data!.docs[0]
                                                      ['isRead']
                                                  ? Icon(
                                                      Icons.done,
                                                      color: secondryColor,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      Icons.done_all,
                                                      color: primaryColor,
                                                      size: 15,
                                                    )
                                              : Text("")
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                      .toList()),
            )));
  }
}

