import 'package:flutter/material.dart';
import '../widgets/custom_sidebar_drawer.dart'; // reuse the same drawer
import '../pages/auth_service.dart';
import '../pages/signin_page.dart';
import '../pages/profile_page.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF005BBB),
      appBar: AppBar(
        backgroundColor: Color(0xFF005BBB),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Attendance', style: TextStyle(color: Colors.white)),
      ),
      drawer: CustomSidebarDrawer(
        userName: 'Coach',
        pageItems: [
          // Include the same menu items you want, example:
          SidebarItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          SidebarItem(
            title: 'Manage Players',
            icon: Icons.group,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/manage_players');
            },
          ),
          SidebarItem(
            title: 'Attendance Report',
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.pop(context); // Already on Attendance page
            },
          ),
          SidebarItem(
            title: 'Sign Out',
            icon: Icons.logout,
            onTap: () async {
              await AuthService().clearSession();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (route) => false,
              );
            },
          ),
          SidebarItem(
            title: 'My Profile',
            icon: Icons.person,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(top: -90, left: -30, child: halfCircle2()),
          Positioned(top: -60, right: -30, child: halfCircle()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Attendance",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 30),

                // Calendar placeholder
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: AttendanceCalendar(),
                  ),
                ),
              ],
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

// Simple calendar UI widget as a placeholder for attendance taking/viewing
class AttendanceCalendar extends StatefulWidget {
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Just a simple month grid for demo with tap to select a date
    final daysInMonth = DateUtils.getDaysInMonth(
      _selectedDate.year,
      _selectedDate.month,
    );
    final firstWeekday =
        DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;

    return Column(
      children: [
        Text(
          "${_selectedDate.year} - ${_selectedDate.month.toString().padLeft(2, '0')}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            itemCount: daysInMonth + firstWeekday - 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) {
                return Container(); // empty cell before month start
              }
              int day = index - firstWeekday + 2;
              bool isSelected = day == _selectedDate.day;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      day,
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blueAccent : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),

        // Placeholder for attendance toggle or note for selected day
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendance for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Just a toggle for demo
              AttendanceToggle(),
            ],
          ),
        ),
      ],
    );
  }
}

class AttendanceToggle extends StatefulWidget {
  @override
  _AttendanceToggleState createState() => _AttendanceToggleState();
}

class _AttendanceToggleState extends State<AttendanceToggle> {
  bool present = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: present,
      onChanged: (val) {
        setState(() {
          present = val;
        });
      },
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
      inactiveTrackColor: Colors.red.shade200,
    );
  }
}
