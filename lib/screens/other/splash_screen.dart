import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_task_management/providers/auth_provider.dart';
import 'package:personal_task_management/screens/auth/initial_screen.dart';
import 'package:personal_task_management/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateAfterCheck();
  }

  Future<void> navigateAfterCheck() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

   
    while (authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

   
    await Future.delayed(const Duration(milliseconds: 1500));

 
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InitialScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Text(
          "LOGO",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
