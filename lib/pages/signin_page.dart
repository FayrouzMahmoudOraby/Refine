import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form.dart';
import '../pages/video_upload_page.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB), // Blue background
      body: Stack(
        children: [
          // Half Circles (if needed)
          Positioned(top: -90, left: -30, child: halfCircle2()),
          Positioned(top: -60, right: -30, child: halfCircle()),

          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
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

                // Form Fields
                CustomFormField(label: "E-mail"),
                CustomFormField(label: "Password", isPassword: true),

                const SizedBox(height: 20),

                // Submit Button (aligned to the right)
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    text: "Submit",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoUploadPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20), // Space between buttons
                // Google Sign-In Button
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
              onPressed:
                  () =>
                      Navigator.pop(context), // Go back to the previous screen
              bgColor: Colors.white,
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function for Half Circle (optional)
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
