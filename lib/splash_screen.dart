import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';   // ✅ CHANGE THIS

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_controller);

    _controller.forward();

    // ✅ AFTER 3 SECONDS → GO TO LOGIN
    Future.delayed(const Duration(seconds: 3), () {

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9F2026),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/images/lifedrop_logo.png',
                  width: 200,   // ⚠️ 400 was too big
                ),

                const SizedBox(height: 20),

                const Text(
                  'Blood Management and Blood Donating App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFF9F4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}