import 'dart:io';

import 'package:boss_chat/firebase/auth/signup_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const route = '/SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  final _passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  // Loading state
  bool _loading = false;

  String? _email;
  String? _password;
  String? _username;

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final tempImageFile = File(image.path);
      setState(() {
        this.image = tempImageFile;
      });
    } on PlatformException {
      _showAlertDialog('Failed to pick image ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12, bottom: 12),
                child: SvgPicture.asset(
                  'assets/svg/icon.svg',
                  width: 256,
                  height: 256,
                ),
              ),
              Stack(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _showActionSheet,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0),
                      child: image == null
                          ? Container(
                              height: 128,
                              width: 128,
                              color: CupertinoColors.systemGrey,
                            )
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                              height: 128,
                              width: 128,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _showActionSheet,
                      child: const CircleAvatar(
                        child: Icon(
                          Icons.add_a_photo,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoFormSection(
                margin: const EdgeInsets.all(12),
                children: [
                  CupertinoTextFormFieldRow(
                    textInputAction: TextInputAction.next,
                    prefix: const Icon(CupertinoIcons.profile_circled),
                    placeholder: 'Username',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (username) {
                      _username = username;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefix: const Icon(CupertinoIcons.mail),
                    placeholder: 'Email Address',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Address cannot be empty';
                      } else if (!_emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (email) {
                      _email = email;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Icon(CupertinoIcons.lock),
                    placeholder: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (!_passwordRegex.hasMatch(value)) {
                        return 'Password must have at least 8 characters including\nOne upper case letter\nOne number\nOne special character';
                      }
                      return null;
                    },
                    onSaved: (password) {
                      _password = password;
                    },
                  ),
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                width: double.infinity,
                child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  onPressed: _verifyCredentials,
                  child: _loading
                      ? const CupertinoActivityIndicator()
                      : const Text('Sign up'),
                ),
              ),
              CupertinoButton(
                child: const Text('Already have an account?'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyCredentials() async {
    final isValid = _formKey.currentState!.validate();
    final signUpAuthApi = Provider.of<SignUpAuthApi>(context, listen: false);

    if (isValid) {
      FocusManager.instance.primaryFocus?.unfocus();
      _formKey.currentState!.save();
    } else {
      return;
    }

    setState(() {
      _loading = true;
    });

    User? user =
        await signUpAuthApi.createUserWithEmailAndPassword(_email!, _password!);

    if (user == null) {
      _showAlertDialog('User with this email address already exists');
      setState(() {
        _loading = false;
      });
      return;
    } else {
      await signUpAuthApi.createUser(
        username: _username!,
        user: user,
      );
    }

    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _showAlertDialog(String message) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showActionSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text(
              'Take Photo',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Text(
              'Choose Photo',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
