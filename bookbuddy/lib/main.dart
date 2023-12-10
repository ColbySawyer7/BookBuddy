import 'package:bookbuddy/models/book_model.dart';
import 'package:bookbuddy/models/club_model.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:bookbuddy/pages/auth_wrapper.dart';
import 'package:bookbuddy/pages/clubs_page.dart';
import 'package:bookbuddy/pages/home_page.dart';
import 'package:bookbuddy/pages/profile_page.dart';
import 'package:bookbuddy/pages/library_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}
