import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';



import '../pages/main_page.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();

    _pushToMainPage(context);
  }

  Future _pushToMainPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 10));

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset('assets/gifs/animatedSplash.json',
          fit: BoxFit.fill),
    );
  }
}
