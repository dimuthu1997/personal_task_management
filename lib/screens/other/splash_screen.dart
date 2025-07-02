import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_task_management/screens/auth/initial_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xffa020ef)),
        child: Center(
          child: Stack(
            children: [
              Center(child: Text("LOGO", style: TextStyle(fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }

  Timer startTimer() {
    var duration = const Duration(milliseconds: 1500);
    return Timer(duration, navigate);
  }

  void navigate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InitialScreen()),
    );
  }
}
