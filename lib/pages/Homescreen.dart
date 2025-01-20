import 'dart:convert';
import 'dart:math';

import 'package:chatbridge/Models/chat_user.dart';
import 'package:chatbridge/Widgets/chat_user_card.dart';
import 'package:chatbridge/api/api.dart';
import 'package:chatbridge/pages/profile_screen.dart';
import 'package:chatbridge/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  final users = APIs.auth.currentUser;
  signout() async {
    try {
      await GoogleSignIn().signOut();
      await APIs.auth.signOut();
    } catch (e) {
      print("Error during signout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
     child: WillPopScope(
    onWillPop: () async {
      if (_isSearching) {
        setState(() {
          _isSearching = false;
        });
        return false; // Prevent exiting the screen
      }
      return true; // Allow exiting the screen
    },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: Icon(
              Icons.home,
            ),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name, Email....",
                    ),
                    autofocus: true,
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : Text(
                    "Chat Bridge",
                    style: TextStyle(fontSize: 16, letterSpacing: 1),
                  ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching =
                          !_isSearching; // Use setState to trigger UI rebuild
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Profilescreen(user: APIs.me)));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                signout();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    break;
                  default:
                }
                if (list.isNotEmpty) {
                  return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : list.length,
                      padding: EdgeInsets.only(top: mq.height * 0.00),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearching ? _searchList[index] : list[index],
                        );
                        // return Text("Name : ${list[index]}");
                      });
                } else {
                  return Center(
                    child: Text(
                      "No connection found",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
