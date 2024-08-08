import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_screen.dart'; // Ensure this path is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToHome();
  }

  void _startAnimation() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _currentStep++;
      });

      if (_currentStep >= 6) {
        timer.cancel();
      }
    });
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg1.jpeg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Background circular images

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/image.jpeg', // Path to your main image
                    height: screenWidth * 0.3, // Responsive height
                    width: screenWidth * 0.3,  // Responsive width
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'M STEAK',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedOpacity(
                      opacity: _currentStep > index ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                        child: Icon(
                          Icons.circle,
                          size: screenWidth * 0.02,
                          color: Colors.brown,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircleImage(String imagePath, double size, Offset offset, int step) {
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: AnimatedOpacity(
        opacity: _currentStep > step ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: ClipOval(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
