import 'package:flutter/material.dart';
import 'package:zatch_app/view/auth_view/login.dart';
import '../../controller/auth_controller/welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WelcomeController();


    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // White container with rounded bottom
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
            ),

            // Top right concentric green circles
            Positioned(
              top: -35,
              right: -90,
              child: Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary,),
                ),
              ),
            ),
            Positioned(
              top: -25,
              right: -90,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary,),
                ),
              ),
            ),

            // Bottom left green angled box (like a triangle)
            Positioned(
              bottom: 180,
              left: -30,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  width: 120,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 180,
              left: -30,
              child: Transform.rotate(
                angle: -0,
                child: Container(
                  width: 120,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                  ),
                ),
              ),
            ),

            // Main content column
            Column(
              children: [
                const Spacer(flex: 3),

                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  width: 80,
                ),

                const SizedBox(height: 10),

                // App name
                const Text(
                  'Zatch',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),

                const Spacer(flex: 2),

                // Bottom lime-green section
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(

                        'Welcome',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Welcome to India's first Live Shopping Bazaar",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),

                      ),
                      const SizedBox(height: 40),

                      // Pills-style container for buttons
                      Container(
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Login button - black background
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 12),
                                elevation: 0,
                              ),
                              child: const Text("Login"),
                            ),

                            // Register button - white background with border
                            OutlinedButton(
                              onPressed: (){

                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 12),
                              ),
                              child: const Text("Register"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
