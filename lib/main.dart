import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoorIslamApp());
}

class NoorIslamApp extends StatelessWidget {
  const NoorIslamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نور الإسلام',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1B15), // اللون الأخضر الداكن
        primaryColor: const Color(0xFFD4AF37), // اللون الذهبي
        fontFamily: 'Cairo', // خط كايو المطلوب
      ),
      home: const HomeScreen(),
    );
  }
}
