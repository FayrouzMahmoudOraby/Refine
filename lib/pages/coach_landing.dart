import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/video_upload_page.dart';
import '../pages/CoachPlayerPage.dart';
import '../pages/assigned_to_trainees.dart';
import '../pages/AddTrainingPage.dart';
import '../pages/profile_page.dart';
import '../widgets/custom_sidebar_drawer.dart'; // import your reusable drawer
import '../pages/signin_page.dart';
import '../pages/auth_service.dart';
import '../pages/welcome_page.dart';
import '../pages/Attendance_Page.dart';
import '../pages/subscription_system.dart';

class CoachDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB),
      appBar: AppBar(
        backgroundColor: Color(0xFF005BBB),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomSidebarDrawer(
        userName: 'Coach',
        pageItems: [
          SidebarItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoachDashboardPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Manage Players',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoachPlayerPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Attendance Report',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendancePage()),
              );
            },
          ),
          SidebarItem(
            title: 'Assigned to Trainees',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssignTrainingPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Add Training',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTrainingPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Payment History',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubscriptionPage()),
              );
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
                    "Coach Dashboard",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: "Upload Videos",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoUploadPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Manage Players",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoachPlayerPage(),
                        ),
                      );
                    },
                  ),
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
