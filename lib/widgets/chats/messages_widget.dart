import 'package:boss_chat/widgets/chats/message_bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('sentAt')
          .snapshots(),
      builder: (context, snapshot) {
        final chats = snapshot.data?.docs;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (snapshot.hasError) {
          return const CupertinoPageScaffold(
            child: Center(
              child: Text('No Messages'),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: chats?.length,
            itemBuilder: (context, index) => MessageBubbleWidget(
              message: chats?[index]['text'],

              isMe: chats?[index]['uid'] == FirebaseAuth.instance.currentUser!.uid,
              uid: chats?[index]['uid'],
              username: chats?[index]['username'],
            ),
          );
        }
      },
    );
  }
}
