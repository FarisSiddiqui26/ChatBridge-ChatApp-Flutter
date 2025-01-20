import 'package:chatbridge/Models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
      final mq=MediaQuery.of(context).size;
    return Card(
      // margin: EdgeInsets.symmetric(
      //     horizontal: mq.size.width * .04,
      //     vertical: mq.size.width * .4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // leading: CircleAvatar(
          //   child: Icon(CupertinoIcons.person),
          // ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.35),
            child: CachedNetworkImage(
              width: mq.width*.1,
              height: mq.height*.055,
              imageUrl: widget.user.image!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(widget.user.name ?? "Unknown"),
          subtitle: Text(
            widget.user.about ?? "unknown",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10)
            ),
          )
          // trailing: Text("12:00"),
        ),
      ),
    );
  }
}
