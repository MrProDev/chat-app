import 'package:boss_chat/firebase/auth/login_auth_api.dart';
import 'package:boss_chat/firebase/auth/signup_auth_api.dart';
import 'package:boss_chat/firebase_options.dart';
import 'package:boss_chat/screens/signup_screen.dart';
import 'package:boss_chat/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print('User granted permission');
    }
  } else {
    if (kDebugMode) {
      print('User declined or has not accepted permission');
    }
  }
  runApp(const BossChat());
}

class BossChat extends StatelessWidget {
  const BossChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginAuthApi>(
          create: (context) => LoginAuthApi(),
        ),
        Provider<SignUpAuthApi>(
          create: (context) => SignUpAuthApi(),
        ),
      ],
      child: CupertinoApp(
        routes: {
          '/': (context) => const SplashScreen(),
          SignUpScreen.route: (context) => const SignUpScreen()
        },
        initialRoute: '/',
      ),
    );
  }
}
