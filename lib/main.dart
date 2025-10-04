// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/firebase_options.dart';
import 'package:todo_list_app/helperwidgets/tasks_provider.dart';
import 'package:todo_list_app/screens/homepage.dart';
import 'package:todo_list_app/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'outfit',
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(fontFamily: 'outfit', fontSize: 30),
            titleSmall: TextStyle(fontFamily: 'outfit', fontSize: 20),
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(33, 150, 243, 1.0),
                  ),
                ),
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              print('Navigating to Homepage');
              return Homepage();
            } else {
              return OnboardingScreen();
            }
          },
        ),
      ),
    );
  }
}
