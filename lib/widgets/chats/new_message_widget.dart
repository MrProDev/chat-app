import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({Key? key}) : super(key: key);

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _messageController = TextEditingController();
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _messageController,
              onChanged: (message) {
                setState(() {
                  _message = message;
                });
              },
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            child: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chats').add({
      'text': _message,
      'sentAt': Timestamp.now(),
      'uid': user.uid,
      'username': userData['username'],
    });
    _messageController.clear();
  }
}
