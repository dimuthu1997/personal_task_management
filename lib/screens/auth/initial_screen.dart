import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_task_management/screens/auth/signIn_screen.dart';
import 'package:personal_task_management/screens/auth/signUp_screen.dart';
import 'package:personal_task_management/widgets/button_rounded_edge.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Color(0xffa020ef),
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 406.25),
                child: Text("LOGO", style: TextStyle(fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 78, left: 78, top: 420),
              child: RoundedButton(
                width: 295.w,
                label: "Sign Up",
                boarderWidth: 0,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const SignUpScreen(
                            // getEntertainerStore: getEntertainerStore,
                          ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 78, left: 78, top: 490),
              child: RoundedButton(
                width: 295.w,
                label: "Sign In",
                color: Colors.white,
                boarderWidth: 2,
                borderColor: Colors.white,
                textColor: Colors.purple,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const SignUpScreen(
                            // getEntertainerStore: getEntertainerStore,
                          ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 50.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,

                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignInScreen(
                                              // getEntertainerStore: getEntertainerStore,
                                            ),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
