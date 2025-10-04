import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list_app/screens/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Column(
          children: [
            SvgPicture.asset('assets/images/onboarding2.svg', height: 500),
            RichText(
              textAlign: TextAlign.center,

              text: TextSpan(
                text: 'Simplify, Organize and Conquer, ',
                style: Theme.of(context).textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: 'Your Day',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Color.fromRGBO(33, 150, 243, 1.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              'Take control of your tasks and\nachieve your goals.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 1, 50),
                backgroundColor: Color.fromRGBO(33, 150, 243, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Lets Start',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
