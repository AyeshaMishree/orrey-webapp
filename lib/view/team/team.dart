import 'package:flutter/material.dart';
import 'package:orrey_web_app/widgets/navigation%20bar/navigation_bar.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Navigation Bar - always on top, not inside Stack
            const CNavigationBar(),

            // Main content inside scroll view for smaller screens
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.05,
                        bottom: screenHeight * 0.03,
                      ),
                      child: Text(
                        'MEET OUR TEAM',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),

                    // First row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        teamMemberCard(
                          'Ayesha Mishree',
                          'Leads backend and database tasks.',
                          'assets/images/jawad_usman.png',
                          screenWidth,
                          screenHeight,
                        ),
                        teamMemberCard(
                          'Hafsa Shahid',
                          'Handles front-end and UI design.',
                          'assets/images/usama_khan.png',
                          screenWidth,
                          screenHeight,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Second row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        teamMemberCard(
                          'Arifa Naseem',
                          'Manages backend logic and APIs.',
                          'assets/images/tm3.PNG',
                          screenWidth,
                          screenHeight,
                        ),
                        teamMemberCard(
                          'M. Hassan Aftab',
                          'Built database and auth module.',
                          'assets/images/tm4.PNG',
                          screenWidth,
                          screenHeight,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget teamMemberCard(
  String name,
  String description,
  String imagePath,
  double screenWidth,
  double screenHeight,
) {
  return Column(
    children: [
      Container(
        height: screenHeight * 0.20,
        width: screenWidth * 0.18,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      SizedBox(height: screenHeight * 0.015),
      Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth * 0.012,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: screenHeight * 0.008),
      SizedBox(
        width: screenWidth * 0.20,
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.0095,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    ],
  );
}
