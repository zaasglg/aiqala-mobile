import 'package:aiqala/pages/home_page.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AiQala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FlutterSplashScreen.fadeIn(
        duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
          onInit: () {
            debugPrint("On Init");
          },
          onEnd: () {
            debugPrint("On End");
          },
          childWidget: Center(
            child: SizedBox(
              width: 200,
              child: Lottie.asset('assets/lottiefiles/onboarding.json'))
            ),
          onAnimationEnd: () => debugPrint("On Fade In End"),
          nextScreen: const HomePage(),
        ),
    );
  }
}

