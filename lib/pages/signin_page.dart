import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_button.dart';
import '../widgets/custom_form.dart';
import '../pages/video_upload_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill in all fields');
      return;
    }

    final url = Uri.parse('http://localhost:5000/api/login'); // Update this URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Navigate to video upload on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VideoUploadPage()),
        );
      } else {
        setState(() => errorMessage = data['message'] ?? 'Login failed');
      }
    } catch (e) {
      setState(() => errorMessage = 'Something went wrong. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB),
      body: Stack(
        children: [
          Positioned(top: -90, left: -30, child: halfCircle2()),
          Positioned(top: -60, right: -30, child: halfCircle()),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form Inputs
                  CustomFormField(label: "E-mail", controller: _emailController),
                  CustomFormField(label: "Password", isPassword: true, controller: _passwordController),

                  const SizedBox(height: 10),

                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: "Submit",
                      onPressed: _loginUser,
                    ),
                  ),

                  const SizedBox(height: 20),
                  CustomButton(
                    text: '',
                    onPressed: () {
                      // TODO: Google Sign In
                    },
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/google.png', height: 24),
                        SizedBox(width: 10),
                        Text('Continue with Google',
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  CustomButton(
                    text: '',
                    onPressed: () {
                      // TODO: Apple Sign In
                    },
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/apple-logo.png', height: 24, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Continue with Apple',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: CustomButton(
              text: "Go Back",
              onPressed: () => Navigator.pop(context),
              bgColor: Colors.white,
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget halfCircle() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 254, 255, 227),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget halfCircle2() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 255, 136),
        shape: BoxShape.circle,
      ),
    );
  }
}
