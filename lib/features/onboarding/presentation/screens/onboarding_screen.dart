import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.red,
        pageBackgroundColor: Colors.red,
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(backgroundColor: Colors.black),
        skipTextButton: Text('Skip'),
        trailing: Text('Login'),
        background: [
          Image.asset('assets/onboarding/img1.png'),
          Image.asset('assets/onboarding/img2.png'),
          Image.asset('assets/onboarding/img3.png'),
          Image.asset('assets/onboarding/img4.png'),
          Image.asset('assets/onboarding/img5.png'),
        ],
        totalPage: 5,
        speed: 1.8,
        pageBodies: [
          pageBody("Welcome to NexaFit – your AI-powered fitness companion."),
          pageBody(
            "Get personalized workouts tailored to your goals and fitness level.",
          ),
          pageBody(
            "Plan your meals smartly with AI-driven diet suggestions and tracking.",
          ),
          pageBody(
            "Track every rep, set, and milestone to see your true progress.",
          ),
          pageBody(
            "Join challenges, share achievements, and stay motivated with the community.",
          ),
        ],
      ),
    );
  }

  Widget pageBody(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[Text(text), SizedBox(height: 100)],
      ),
    );
  }
}
