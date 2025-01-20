import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbridge/Models/chat_user.dart';
import 'package:chatbridge/Widgets/chat_user_card.dart';
import 'package:chatbridge/api/api.dart';
import 'package:chatbridge/helper/dialogs.dart';
import 'package:chatbridge/main.dart';
import 'package:chatbridge/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Profilescreen extends StatefulWidget {
  final ChatUser user;
  const Profilescreen({super.key, required this.user});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? _image;
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Loginpage()));
              });
            });
            // signout();
          },
          icon: Icon(Icons.add_comment_rounded),
          label: Text("Logout"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .03,
              ),
              Stack(
                children: [
                  //profile picture
                  _image != null
                      ?

                      //local image
                      ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .15),
                          child: Image.file(
                            File(_image!),
                            width: mq.width * .44,
                            height: mq.height * 0.25,
                            fit: BoxFit.cover,
                          ))
                      :

                      //image from server

                      ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .15),
                          child: CachedNetworkImage(
                            width: mq.width * .44,
                            height: mq.height * 0.25,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: Icon(CupertinoIcons.person),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {
                        _showBottomSheet();
                      },
                      elevation: 1,
                      shape: CircleBorder(),
                      color: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: mq.height * .03),
              Text(
                widget.user.email!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: mq.height * .05),
              TextFormField(
                //initialValue: widget.user.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Name",
                  label: Text("Name"),
                ),
              ),
              SizedBox(height: mq.height * .05),
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "I am happy",
                  label: Text("About"),
                ),
              ),
              SizedBox(height: mq.height * .05),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width * .4, mq.height * .06)),
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  size: 28,
                  color: Colors.white,
                ),
                label: Text(
                  "UPDATE",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * .03,
                bottom: mq.height * .05),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(
                              mq.width * .3,
                              mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          print('image.path ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/images/add_image.png")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(
                              mq.width * .3,
                              mq.height * .15)),
                      onPressed: () {
                        
                      },
                      child: Image.asset("assets/images/camera.png"))
                ],
              )
            ],
          );
        });
  }
}
