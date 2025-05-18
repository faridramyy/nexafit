import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Theme.of(context).colorScheme.surface,
        finishButtonText: 'Register',
        skipTextButton: Text('Skip'),
        trailing: Text('Login'),
        centerBackground: true,
        indicatorAbove: true,
        background: [
          Stack(
            children: [
              Image.asset('assets/images/onboarding/img5.png'),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/onboarding/shadow_black.png'
                    : 'assets/images/onboarding/shadow_white.png',
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset('assets/images/onboarding/img4.png'),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/onboarding/shadow_black.png'
                    : 'assets/images/onboarding/shadow_white.png',
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset('assets/images/onboarding/img3.png'),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/onboarding/shadow_black.png'
                    : 'assets/images/onboarding/shadow_white.png',
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset('assets/images/onboarding/img2.png'),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/onboarding/shadow_black.png'
                    : 'assets/images/onboarding/shadow_white.png',
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset('assets/images/onboarding/img1.png'),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/onboarding/shadow_black.png'
                    : 'assets/images/onboarding/shadow_white.png',
              ),
            ],
          ),
        ],
        totalPage: 5,
        speed: 1.8,
        pageBodies: [
          pageBody(
            "Welcome to NexaFit – your AI-powered fitness companion.",
            context,
          ),
          pageBody(
            "Get personalized workouts tailored to your goals and fitness level.",
            context,
          ),
          pageBody(
            "Plan your meals smartly with AI-driven diet suggestions and tracking.",
            context,
          ),
          pageBody(
            "Track every rep, set, and milestone to see your true progress.",
            context,
          ),
          pageBody(
            "Join challenges, share achievements, and stay motivated with the community.",
            context,
          ),
        ],
      ),
    );
  }

  Widget pageBody(String text, context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
