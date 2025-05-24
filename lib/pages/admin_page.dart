import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/user_managment.dart';
import '../widgets/custom_sidebar_drawer.dart'; // Reusable drawer
import '../pages/signin_page.dart';
import '../pages/auth_service.dart';
import '../pages/welcome_page.dart';
import '../pages/profile_page.dart';

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
      drawer: CustomSidebarDrawer(
        userName: 'Admin',
        pageItems: [
          SidebarItem(
            title: 'Manage Users',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagementPage()),
              );
            },
          ),
          // Add this to your pageItems list in each dashboard
          SidebarItem(
            title: 'View Analytics',
            icon: Icons.bar_chart,
            onTap: () {
              // Navigate to analytics
            },
          ),
          SidebarItem(
            title: 'Sign Out',
            icon: Icons.logout,
            onTap: () async {
              await AuthService().clearSession();

              // 2. Navigate to the welcome/sign-in screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ), // or SignInPage() if you prefer
                (route) => false, // This removes all routes
              );
            },
          ),
          SidebarItem(
            title: 'My Profile',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
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
                  CustomButton(
                    text: "View Analytics",
                    onPressed: () {
                      // Navigate to analytics
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Sign Out",
                    onPressed: () async {
                      await AuthService().clearSession();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
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
