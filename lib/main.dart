import 'package:boss_chat/firebase/auth/login_auth_api.dart';
import 'package:boss_chat/firebase/auth/signup_auth_api.dart';
import 'package:boss_chat/firebase_options.dart';
import 'package:boss_chat/screens/signup_screen.dart';
import 'package:boss_chat/widgets/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          '/': (context) => const MainPage(),
          SignUpScreen.route: (context) => const SignUpScreen()
        },
        initialRoute: '/',
      ),
    );
  }
}
