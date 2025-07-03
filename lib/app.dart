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
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      home: const SplashScreen(),
    );
  }
}
