import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.uid,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  final String message;
  final bool isMe;
  final String uid;
  final String username;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: isMe
                    ? CupertinoColors.systemPink
                    : CupertinoColors.systemPurple,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: CupertinoColors.systemYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
            Positioned(
              right: !isMe ? 0 : null,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imageUrl),
              ),
            )
          ],
        ),
      ],
    );
  }
}
