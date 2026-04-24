import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 🔗 OPEN LINK
  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF9ECF),
              Color(0xFFFFC1E3),
              Color(0xFFFFE4F2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 500,
              ),

              // ✅ SCROLL BIAR AMAN (no overflow)
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // 🔥 CARD SETTINGS
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // 🌙 DARK MODE
                          SwitchListTile(
                            title: const Text(
                              "Dark Mode",
                              style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: isDark,
                            onChanged: (value) {
                              themeProvider.toggleTheme(value);
                            },
                            secondary: const Icon(
                              Icons.dark_mode,
                              color: Colors.pink,
                            ),
                          ),

                          const Divider(height: 1),

                          // ⭐ RATE APP
                          _menuItem(
                            icon: Icons.star,
                            title: "Rate App",
                            onTap: () {
                              _openLink(
                                "https://play.google.com/store/apps/details?id=com.example.app",
                              );
                            },
                          ),

                          const Divider(height: 1),

                          // 📱 INSTAGRAM
                          _menuItem(
                            icon: Icons.camera_alt,
                            title: "Instagram",
                            onTap: () {
                              _openLink(
                                "https://instagram.com/azaliaam_",
                              );
                            },
                          ),

                          const Divider(height: 1),

                          // ℹ️ ABOUT
                          _menuItem(
                            icon: Icons.info,
                            title: "About App",
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: "LIAÉ Nails",
                                applicationVersion: "1.0",
                                applicationLegalese: "© 2026 LIAÉ Nails",
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 MENU ITEM
  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.pink,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}