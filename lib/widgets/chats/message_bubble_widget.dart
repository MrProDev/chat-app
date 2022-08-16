import 'package:flutter/cupertino.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.uid,
      required this.username})
      : super(key: key);

  final String message;
  final bool isMe;
  final String uid;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? CupertinoColors.systemPink
                : CupertinoColors.systemPurple,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      ],
    );
  }
}
