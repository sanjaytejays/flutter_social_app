import 'package:flutter/material.dart';
import 'package:medcon/app/authentication/presentation/screens/login_screen.dart';
import 'package:medcon/app/authentication/presentation/screens/register_screen.dart';

class AuthToggleScreen extends StatefulWidget {
  const AuthToggleScreen({super.key});

  @override
  State<AuthToggleScreen> createState() => _AuthToggleScreenState();
}

class _AuthToggleScreenState extends State<AuthToggleScreen> {
  // initially show login screen
  bool showLoginScreen = true;

  // toggle between login and register screens
  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onToggleScreen: toggleScreen);
    } else {
      return RegisterScreen(onToggleScreen: toggleScreen);
    }
  }
}
