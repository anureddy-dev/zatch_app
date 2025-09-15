import 'package:flutter/material.dart';
import 'package:zatch_app/view/auth_view/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zatch',
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFCCF656),
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.redAccent,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
