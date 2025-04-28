import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_button.dart';
import '../widgets/custom_form.dart';
import '../widgets/RotatingTextCircle.dart';
import '../pages/signin_page.dart';
import '../pages/CoachPlayerPage.dart';

class CoachSignUpPage extends StatefulWidget {
  @override
  _CoachSignUpPageState createState() => _CoachSignUpPageState();
}

class _CoachSignUpPageState extends State<CoachSignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> submitForm() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    print('Name: ${nameController.text}');
    print('Last Name: ${lastNameController.text}');
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
    print('Phone: ${phoneController.text}');

    final url = Uri.parse('http://192.168.3.153:5000/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'role': 'coach',
      }),
    );

    if (response.statusCode == 201) {
      print('Success: ${response.body}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      print('Error: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed!')));
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
          Positioned(bottom: -100, left: -30, child: halfCircle2()),
          Positioned(bottom: -130, right: -50, child: halfCircle()),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: RotatingTextCircle(
                      dynamicWord: " Coach Sign Up Coach Sign Up",
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form Fields
                  CustomFormField(label: "name", controller: nameController),
                  CustomFormField(
                    label: "last name",
                    controller: lastNameController,
                  ),
                  CustomFormField(label: "e-mail", controller: emailController),
                  CustomFormField(
                    label: "password",
                    isPassword: true,
                    controller: passwordController,
                  ),
                  CustomFormField(label: "phone", controller: phoneController),

                  const SizedBox(height: 20),

                  // Submit
                  CustomButton(text: "Submit", onPressed: submitForm),

                  const SizedBox(height: 10),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Google Sign-In Button (placeholder)
                  CustomButton(
                    text: '',
                    onPressed: () {
                      // TODO: Add Google Sign-In Logic
                    },
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/google.png', height: 24),
                        SizedBox(width: 10),
                        Text(
                          'Continue with Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Apple Sign-In Button (placeholder)
                  CustomButton(
                    text: '',
                    onPressed: () {
                      // TODO: Add Apple Sign-In Logic
                    },
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/apple-logo.png',
                          height: 24,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Continue with Apple',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: '',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoachPlayerPage(),
                        ),
                      );
                    },
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Test Coach',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Go Back
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
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(9, 30, 66, 0.25),
            blurRadius: 8,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(9, 30, 66, 0.08),
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
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

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  CustomFormField({
    required this.label,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
