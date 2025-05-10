import 'package:flutter/material.dart';

class CustomSidebarDrawer extends StatelessWidget {
  final String userName;
  final List<SidebarItem> pageItems;

  const CustomSidebarDrawer({
    Key? key,
    required this.userName,
    required this.pageItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.indigo[900],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hey, $userName',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24),

            // Dynamic page buttons
            ...pageItems.map(
              (item) => ListTile(
                leading: Icon(item.icon, color: Colors.white),
                title: Text(
                  item.title,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  item.onTap();
                },
              ),
            ),

            const Spacer(),
            const Divider(color: Colors.white24),

            // Notification & Settings
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text(
                'Notifications',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SidebarItem({required this.title, required this.icon, required this.onTap});
}
