import 'package:boss_chat/firebase/auth/login_auth_api.dart';
import 'package:boss_chat/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  // Loading state
  bool _loading = false;

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Form(
        key: _formKey,
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
            CupertinoFormSection(
              margin: const EdgeInsets.all(12),
              children: [
                CupertinoTextFormFieldRow(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
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
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,
              child: CupertinoButton.filled(
                padding: EdgeInsets.zero,
                onPressed: _verifyCredentials,
                child: _loading
                    ? const CupertinoActivityIndicator()
                    : const Text('Sign in'),
              ),
            ),
            CupertinoButton(
              child: const Text('Don\'t have an account yet?'),
              onPressed: () => Navigator.pushNamed(context, SignUpScreen.route),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCredentials() async {
    final isValid = _formKey.currentState!.validate();
    final loginAuthApi = Provider.of<LoginAuthApi>(context, listen: false);

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
        await loginAuthApi.signInWithEmailAndPassword(_email!, _password!);

    if (user == null) {
      _showAlertDialog();
    }

    setState(() {
      _loading = false;
    });
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('User does not exist'),
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
}
