import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final String token;

  const MainScreen({super.key, required this.token});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  List<Widget> get pages => [
        HomeScreen(token: widget.token),
        FavoriteScreen(token: widget.token),
        ProfileScreen(token: widget.token),
        const SettingsScreen(),
      ];

  // 🔐 LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 📱 MOBILE
    if (width < 700) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("LIAÉ Nails"),
          backgroundColor: Colors.pink,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            )
          ],
        ),

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pages[currentIndex],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting",
            ),
          ],
        ),
      );
    }

    // 💻 DESKTOP / WEB
    return Scaffold(
      body: Row(
        children: [
          // 🔥 SIDEBAR
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (i) {
              setState(() => currentIndex = i);
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.pink.shade50,
            selectedIconTheme: const IconThemeData(color: Colors.pink),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text("Favorite"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("Profile"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text("Setting"),
              ),
            ],
          ),

          // 🔥 CONTENT
          Expanded(
            child: Column(
              children: [
                // HEADER
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.pink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "LIAÉ Nails",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: logout,
                      )
                    ],
                  ),
                ),

                // PAGE
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pages[currentIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}