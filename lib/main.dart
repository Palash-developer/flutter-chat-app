import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/main_screen.dart';
import 'package:flutter_chat_app/utils/secrets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_chat_app/screens/splash_screen.dart';
import 'package:flutter_chat_app/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize OneSignal
  // OneSignal.initialize(Secrets.oneSignalAppId);
  // OneSignal.User.pushSubscription.addObserver((state) {
  //   log(OneSignal.User.pushSubscription.optedIn as String);
  //   log(OneSignal.User.pushSubscription.id as String);
  //   log(OneSignal.User.pushSubscription.token as String);
  //   log(state.current.jsonRepresentation());
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 197, 174, 255),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // if (snapshot.hasData) return const ChatScreen();
          if (snapshot.hasData) return const MainScreen();
          return const AuthScreen();
        },
      ),
    );
  }
}
