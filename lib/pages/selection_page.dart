import 'package:flutter/material.dart';
import '../pages/player_signup_page.dart';
import '../pages/signin_page.dart';
import '../widgets/custom_sidebar_drawer.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext scaffoldContext) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                "Go Back",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomSidebarDrawer(
        userName: 'Guest',
        pageItems: [
          SidebarItem(
            title: 'Login',
            icon: Icons.login,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
          SidebarItem(
            title: 'Sign Up',
            icon: Icons.person_add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSignUpPage(role: 'Sign up'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/sbackground.jpg',
            fit: BoxFit.cover,
          ),

          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title "Refine"
                const Text(
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
                _customButton(context, "Player"),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == "Player") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSignUpPage(role: 'Sign up'),
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