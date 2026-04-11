import 'package:flutter/material.dart';
import 'dart:math' as math;

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4698CE),
                Color(0xFF79AAD5),
                Color(0xFF80ADD4),
                Color(0xFFBFD5E3),
                Color(0xFFDFECF2),
              ],
              stops: [0.0, 0.29, 0.47, 0.84, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 211,
                left: 0,
                right: 0,
                child: Text(
                  'SKANDRON',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                    color: Colors.black,
                  ),
                ),
              ),
              CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 72,
                rotation: -10,
                top: 58,     
                left: 38,      
              ),

              CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 40,
                rotation: 0,
                top: 320,
                left: 150,
              ),

              CustomFrame(
                imagePath: 'assets/images/lucide_scan.png',
                size: 90,
                rotation: 10,
                top: 530,
                left: 230,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone1.png',
                size: 130,
                rotation: 0,
                top: 77,
                left: 200,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone2.png',
                size: 220,
                rotation: 0,
                top: 300,
                left: 230,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone3.png',
                size: 210,
                rotation: -20,
                top: 280,
                left: -60,
              ),

              CustomFrame(
                imagePath: 'assets/images/Drone4.png',
                size: 110,
                rotation: 0,
                top: 490,
                left: 70,
              ),

              ImageButton(
                imagePath: 'assets/images/ScanBatton.png',
                size: 80,
                top: 650,   
                left: 155,  
                onTap: () {
                  print("Кнопка сканування натиснута!");
                }
              ),

              ImageButton(
                imagePath: 'assets/images/History.png',
                size: 130,
                top: 650,   
                left: 255,  
                onTap: () {
                  print("Кнопка сканування натиснута!");
                }
              ),

              ImageButton(
                imagePath: 'assets/images/LastResult.png',
                size: 130,
                top: 650,   
                left: 25,  
                onTap: () {
                  print("Кнопка сканування натиснута!");
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFrame extends StatelessWidget {
  final String imagePath;   
  final double size;        
  final double rotation;    
  final double top;         
  final double left;        

  const CustomFrame({
    super.key,
    required this.imagePath,
    required this.size,
    this.rotation = 0,      
    this.top = 0,
    this.left = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: rotation * (math.pi / 180), 
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String imagePath;
  final double size;
  final double top;
  final double left;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.size,
    required this.top,
    required this.left,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: onTap, 
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Image.asset(
            imagePath,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}