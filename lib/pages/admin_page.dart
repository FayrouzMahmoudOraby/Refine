import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/user_managment.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB),
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // User Management
                  // In AdminDashboardPage.dart
                  CustomButton(
                    text: "Manage Users",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserManagementPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Content Management
                  CustomButton(
                    text: "Manage Content",
                    onPressed: () {
                      // Navigate to content management
                    },
                  ),

                  const SizedBox(height: 20),

                  // Analytics
                  CustomButton(
                    text: "View Analytics",
                    onPressed: () {
                      // Navigate to analytics
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sign Out
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
