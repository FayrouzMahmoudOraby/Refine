import 'package:flutter/material.dart';
import '../pages/coach_signup_page.dart';
import '../pages/player_signup_page.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/sbackground.jpg', // Ensure this file exists
            fit: BoxFit.cover,
          ),

          // Go Back Button (Top-Right)
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                "Go Back",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title "Refine"
                Text(
                  "Refine",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 40),

                // Player Button
                customButton(context, "Player"),

                const SizedBox(height: 20),

                // Coach Button
                customButton(context, "Coach"),

                const SizedBox(height: 20),

                // **New Chatbot Button**
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Button Function
  Widget customButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        // Navigation logic for Player and Coach
        if (text == "Player") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerSignUpPage(role: 'player'),
            ),
          );
        } else if (text == "Coach") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerSignUpPage(role: 'coach'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.withOpacity(0.8),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Text(text),
    );
  }
}
