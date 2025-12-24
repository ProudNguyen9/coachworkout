import 'dart:async';
import 'package:flutter/material.dart';
import 'screens.dart'; // đổi path đúng của bạn nha

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Đợi 2 giây rồi chuyển qua màn Login
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // hoặc màu logo bạn
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'), // logo bạn dùng
          width: 120,
        ),
      ),
    );
  }
}
