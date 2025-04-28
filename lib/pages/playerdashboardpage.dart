import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/video_upload_page.dart';

class PlayerDashboardPage extends StatelessWidget {
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
                    "Player Dashboard",
                    style: TextStyle(
                      fontSize: 40, // Slightly smaller than login page
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // First button - Upload Videos
                  CustomButton(
                    text: "Upload Videos",
                    onPressed: () {
                      // Navigate to video upload page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoUploadPage()),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Second button - Manage Players

                  
                  const SizedBox(height: 20),
                  
                  // Optional: Add a sign out button
                  CustomButton(
                    text: "Sign Out",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    bgColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ],
              ),
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