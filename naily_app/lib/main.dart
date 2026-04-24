import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/nail_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NailProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // 🔥 INI YANG PENTING BANGET
          title: 'LIAÉ Nails',

          // 🌞 LIGHT
          theme: ThemeData.light(),

          // 🌙 DARK
          darkTheme: ThemeData.dark(),

          // 🔥 THEME SWITCH
          themeMode: themeProvider.themeMode,

          home: SplashScreen(),
        );
      },
    );
  }
}