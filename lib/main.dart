// lib/main.dart
import 'package:aiqala/pages/auth/login_screen.dart';
import 'package:aiqala/pages/navigation_screen.dart';
import 'package:aiqala/services/auth_service.dart';
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
                child: Lottie.asset('assets/lottiefiles/onboarding.json')
            )
        ),
        onAnimationEnd: () => debugPrint("On Fade In End"),
        nextScreen: const AuthCheckScreen(),
      ),
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await _authService.isLoggedIn();

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const NavigationScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Тексеру...'),
      ),
    );
  }
}