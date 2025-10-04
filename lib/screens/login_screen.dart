// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromRGBO(33, 150, 243, 1.0);
    final lightGrey = Color.fromRGBO(245, 247, 249, 1);
    final borderGrey = Color.fromRGBO(222, 235, 249, 1);

    Future<void> signInUserWithEmailAndPassword() async {
      try {
        var userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailCtrl.text.trim(),
              password: passwordCtrl.text.trim(),
            );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('login successfull')));
        emailCtrl.clear();
        passwordCtrl.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'some error occured')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(foregroundColor: primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome Back!!',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              'Login',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                fillColor: lightGrey,
                filled: true,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.email_outlined, color: primaryColor),
                    SizedBox(width: 8),
                    Text('Your email'),
                  ],
                ),
                labelStyle: TextStyle(color: Colors.black87),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: lightGrey,
                filled: true,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, color: primaryColor),
                    SizedBox(width: 8),
                    Text('Password'),
                  ],
                ),
                labelStyle: TextStyle(color: Colors.black87),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            Center(
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await signInUserWithEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 1, 50),
                backgroundColor: primaryColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Divider(color: borderGrey, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/facebook.svg', height: 30),
                SizedBox(width: 20),
                SvgPicture.asset('assets/images/instagram.svg', height: 30),
                SizedBox(width: 20),
                SvgPicture.asset('assets/images/twitter.svg', height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
