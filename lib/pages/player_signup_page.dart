import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_button.dart';
import '../widgets/RotatingTextCircle.dart';
import '../pages/signin_page.dart';

class UserSignUpPage extends StatefulWidget {
  final String role;

  const UserSignUpPage({Key? key, required this.role}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<UserSignUpPage> {
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

    final url = Uri.parse('http://192.168.191.72:5000/api/users');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'role': 'player',
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
      body: Container(
        color: Color(0xFF005BBB),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Circles
              Container(
                width: double.infinity,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(top: -100, left: -5, child: halfCircle2()),
                    Positioned(top: -80, right: -15, child: halfCircle()),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: RotatingTextCircle(
                        dynamicWord:
                            widget.role == 'coach'
                                ? " Coach Sign Up Coach Sign Up"
                                : " Player Sign Up Player Sign Up",
                      ),
                    ),
                    const SizedBox(height: 30),

                    CustomFormField(label: "name", controller: nameController),
                    CustomFormField(
                      label: "last name",
                      controller: lastNameController,
                    ),
                    CustomFormField(
                      label: "e-mail",
                      controller: emailController,
                    ),
                    CustomFormField(
                      label: "password",
                      isPassword: true,
                      controller: passwordController,
                    ),
                    CustomFormField(
                      label: "phone",
                      controller: phoneController,
                    ),

                    const SizedBox(height: 20),

                    CustomButton(text: "Submit", onPressed: submitForm),

                    const SizedBox(height: 10),

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

                    CustomButton(
                      text: '',
                      onPressed: () {},
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

                    CustomButton(
                      text: '',
                      onPressed: () {},
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

                    const SizedBox(height: 20), // Space after form
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 260, // Same as top circle
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(bottom: -100, left: -30, child: halfCircle2()),
                    Positioned(bottom: -130, right: -50, child: halfCircle()),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      width: 280,
      height: 280,
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
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 5),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
