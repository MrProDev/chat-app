import 'package:boss_chat/firebase/auth/login_auth_api.dart';
import 'package:boss_chat/widgets/chats/messages_widget.dart';
import 'package:boss_chat/widgets/chats/new_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CupertinoSliverNavigationBar(
                  padding: EdgeInsetsDirectional.zero,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.logout,
                      color: CupertinoColors.systemRed,
                    ),
                    onPressed: () async {
                      final loginAuthApi =
                          Provider.of<LoginAuthApi>(context, listen: false);
                      loginAuthApi.signOut();
                    },
                  ),
                  largeTitle: const Text('Chats'),
                ),
              ],
          body: Column(
            children: const [
              Expanded(
                child: MessagesWidget(),
              ),
              Expanded(
                child: NewMessageWidget(),
              ),
            ],
          )),
    );
  }
}
