import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form.dart';
import '../widgets/RotatingTextCircle.dart';
import '../pages/signin_page.dart';

class CoachSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB), // Blue background
      body: Stack(
        children: [
          // Half Circles
          Positioned(top: -90, left: -30, child: halfCircle2()),
          Positioned(top: -60, right: -30, child: halfCircle()),
          Positioned(bottom: -100, left: -30, child: halfCircle2()),
          Positioned(bottom: -130, right: -50, child: halfCircle()),

          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200, // Give enough space for rotation
                  width: 200,
                  child: RotatingTextCircle(
                    dynamicWord: " Coach Sign Up Coach Sign Up",
                  ),
                ),
                const SizedBox(height: 30),

                // Form Fields
                CustomFormField(label: "name"),
                CustomFormField(label: "last name"),
                CustomFormField(label: "e-mail"),
                CustomFormField(label: "password", isPassword: true),
                CustomFormField(label: "phone"),

                const SizedBox(height: 20),

                // Submit Button
                CustomButton(
                  text: "Submit",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Sign-in Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {},
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
                CustomButton(
                  text: '',
                  onPressed: () {
                    // Handle Google sign-in logic
                  },
                  bgColor: Colors.white,
                  textColor: Colors.black,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: 24,
                      ), // Google logo
                      SizedBox(width: 10),
                      Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10), // Space between buttons
                // Apple Sign-In Button
                CustomButton(
                  text: '',
                  onPressed: () {
                    // Handle Apple sign-in logic
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
                      ), // Apple logo
                      SizedBox(width: 10),
                      Text(
                        'Continue with Apple',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Go Back Button
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

  // Function for Half Circle
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
