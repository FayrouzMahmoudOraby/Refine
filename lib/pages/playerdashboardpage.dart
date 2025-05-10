import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../pages/video_upload_page.dart';
import '../widgets/custom_sidebar_drawer.dart'; // use drawer-compatible sidebar

class PlayerDashboardPage extends StatelessWidget {
  const PlayerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005BBB),
      drawer: CustomSidebarDrawer(
        userName: 'Player',
        pageItems: [
          SidebarItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerDashboardPage()),
              );
            },
          ),

          SidebarItem(
            title: 'Upload Videos',
            icon: Icons.upload,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoUploadPage()),
              );
            },
          ),
          SidebarItem(
            title: "Today's Workout",
            icon: Icons.sports_tennis,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoUploadPage()),
              );
            },
          ),
          SidebarItem(
            title: "My Attendance Report",
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoUploadPage()),
              );
            },
          ),
          SidebarItem(
            title: "Payment History",
            icon: Icons.payment,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoUploadPage()),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF005BBB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  const Text(
                    "Player Dashboard",
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
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 254, 255, 227),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget halfCircle2() {
    return Container(
      width: 260,
      height: 260,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 243, 255, 136),
        shape: BoxShape.circle,
      ),
    );
  }
}
