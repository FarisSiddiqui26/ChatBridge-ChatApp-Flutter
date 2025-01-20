import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbridge/Models/chat_user.dart';
import 'package:chatbridge/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      child: Row(
        children: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white54,
              )),
      
          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .35),
            child: CachedNetworkImage(
              width: mq.width * .1,
              height: mq.height * .055,
              imageUrl: widget.user.image!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          SizedBox(width: mq.width*.01,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  )),
          SizedBox(height: 2,),
                  Text('Last seen not available',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
