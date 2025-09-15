import 'package:flutter/material.dart';
import 'package:zatch_app/view/auth_view/welcome.dart';
import 'package:zatch_app/view/auth_view/login.dart';
import 'package:zatch_app/view/help_screen.dart';
import 'package:zatch_app/view/search_view/search_screen.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';

import 'Widget/explore_page.dart';
import 'Widget/notification_screen.dart';
import 'view/auth_view/register_screen.dart';

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
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/explore': (context) => const ExplorePage(),
        '/notification': (context) => const NotificationPage(),
        '/help': (context) => const HelpScreen(),
      },
    );
  }
}
