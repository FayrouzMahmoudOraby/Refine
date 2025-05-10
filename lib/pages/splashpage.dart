import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/auth_service.dart';  // Assuming you created this
import 'signin_page.dart';
import 'admin_page.dart';
import '../pages/coach_landing.dart';
import '../pages/playerdashboardpage.dart';
import '../pages/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    final userData = await _authService.getUserData();

    await Future.delayed(Duration(milliseconds: 1500));

    if (!mounted) return;

    if (isLoggedIn && userData != null) {
      final user = jsonDecode(userData);
      _redirectBasedOnRole(user['role']);
    } else {
      _redirectToWelcomePage();
    }
  }

  void _redirectBasedOnRole(String role) {
    Widget targetPage;
    
    switch (role) {
      case 'admin':
        targetPage = AdminDashboardPage();
        break;
      case 'coach':
        targetPage = CoachDashboardPage();
        break;
      case 'player':
        targetPage = PlayerDashboardPage();
        break;
      default:
        targetPage = HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  void _redirectToWelcomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Path to your logo
              width: 150, // Adjust size as needed
              height: 150,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}