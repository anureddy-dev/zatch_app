import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> contentWidgets; // For inputs, buttons, etc.
  final Widget? bottomText; // Optional text at the bottom (e.g., Terms & Conditions)

  const BaseScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.contentWidgets,
    this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(screenHeight * 0.045),
                ),
              ),
              child: Stack(
                children: [
                  // Background Shapes
                  Positioned(
                    left: -screenWidth * 0.7,
                    top: screenHeight * 0.67,
                    child: Transform.rotate(
                      angle: 0.47,
                      child: Container(
                        width: screenWidth * 0.95,
                        height: screenWidth * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: const Color(0xFFF1F4FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -screenWidth * 0.7,
                    top: screenHeight * 0.66,
                    child: Container(
                      width: screenWidth * 0.95,
                      height: screenWidth * 0.95,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFFF1F4FF),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: -screenWidth * 0.7,
                    child: Container(
                      width: screenWidth * 1.5,
                      height: screenWidth * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: const Color(0x99CCF656),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.4,
                    top: -screenWidth * 0.45,
                    child: Container(
                      width: screenWidth * 1.0,
                      height: screenWidth * 1.0,
                      decoration: BoxDecoration(
                        color: const Color(0x4CCCF656),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: const Color(0x99CCF656),
                        ),
                      ),
                    ),
                  ),

                  // Main content (scrollable and aligned toward top)
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.15,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08,
                      bottom: screenHeight * 0.2, // Increased bottom padding to avoid overlap
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 70,
                            width: 70,
                          ),
                        ),

                        // Title & Subtitle
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF494949),
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Dynamic Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: contentWidgets,
                        ),
                      ],
                    ),
                  ),

                  // Bottom text fixed at the bottom
                  if (bottomText != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: screenHeight * 0.02, // Small padding from bottom
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                        child: bottomText,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}