import 'package:flutter/material.dart';
import 'package:personal_task_management/providers/theme_provider.dart';
import 'package:personal_task_management/screens/other/splash_screen.dart';
import 'package:provider/provider.dart';

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      themeMode: ThemeMode.light,
      theme: themeProvider.theme,
      home: const SplashScreen(),
    );
  }
}
