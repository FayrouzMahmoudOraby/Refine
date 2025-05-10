import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/video_upload_page.dart';
import '../pages/CoachPlayerPage.dart';
import '../pages/assigned_to_trainees.dart';
import '../widgets/custom_sidebar_drawer.dart'; // import your reusable drawer

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
                MaterialPageRoute(builder: (context) => CoachPlayerPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Assigned to Trainees',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignedToTraineesPage(),
                ),
              );
            },
          ),
          SidebarItem(
            title: 'Payment History',
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoachPlayerPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Sign Out',
            icon: Icons.logout,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
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
                  const SizedBox(height: 20),
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
