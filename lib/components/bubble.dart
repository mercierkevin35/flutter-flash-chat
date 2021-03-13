import 'package:flutter/material.dart';
import '../constants.dart';

class Bubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final double borderRadius = 30.0;
  Bubble({@required this.text, @required this.sender, @required this.isMe});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.8;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Column(
        crossAxisAlignment:
            this.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(this.sender),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: width),
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.0, 3.0),
                  blurRadius: 4.0,
                )
              ],
              color: this.isMe ? kBgColorSenderIsMe : kBgColorSenderIsYou,
              borderRadius: this.isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(this.borderRadius),
                      bottomLeft: Radius.circular(this.borderRadius),
                      bottomRight: Radius.circular(this.borderRadius),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(this.borderRadius),
                      bottomLeft: Radius.circular(this.borderRadius),
                      bottomRight: Radius.circular(this.borderRadius),
                    ),
            ),
            child: Text(
              this.text,
              style: this.isMe ? kTextStyleSenderIsMe : kTextStyleSenderIsYou,
            ),
          ),
        ],
      ),
    );
  }
}
