import 'dart:io';

import 'package:boss_chat/models/user_credentials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class SignUpAuthApi {
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      return null;
    }
  }

  String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String?> uploadProfilePicture({required File image}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${getCurrentUid()}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on PlatformException {
      return null;
    }
  }

  Future createUser(
      {required String username,
      required User user,
      required String imageUrl}) async {
    String uid = getCurrentUid();
    UserCredentials userData = UserCredentials(
        username: username, email: user.email, uid: uid, imageUrl: imageUrl);
    try {
      final DocumentReference<Map<String, dynamic>> doc =
          FirebaseFirestore.instance.collection('users').doc(uid);

      await doc.set(userData.toMap());
    } on PlatformException {
      return null;
    }
  }
}
