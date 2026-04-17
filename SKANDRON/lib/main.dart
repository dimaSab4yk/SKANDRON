import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), 
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
              child: const Text(
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
              imagePath: 'assets/images/ScanBatton.svg',
              width: 80,
              height: 80,
              bottom: 20,
              left: 0,
              right: 0,
              onTap: () => showUploadDialog(context),
            ),

            ImageButton(
              imagePath: 'assets/images/LastResult.svg', 
              width: 130,
              height: 80,
              bottom: 20,
              left: 20,
              onTap: () => print("Ліво натиснуто"),
            ),

            ImageButton(
              imagePath: 'assets/images/History.svg',
              width: 130,
              height: 80,
              bottom: 20,
              right: 20,
              onTap: () => print("Право натиснуто"),
            ),
          ],
        ),
      ),
    );
  }
  void showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color(0xFFD9D9D9).withOpacity(0.6),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 360,
                  height: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF79AAD5).withOpacity(0.6),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Оберіть спосіб завантажити фото',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildDialogButton(
                            imagePath: 'assets/images/GalleryBotton.svg', 
                            label: 'ГАЛЕРЕЯ',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          buildDialogButton(
                            imagePath: 'assets/images/CameraButton.svg', 
                            label: 'КАМЕРА',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildDialogButton({
    required String imagePath, 
    required String label, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: 80, 
                  height: 80,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  imagePath,
                  width: 80, 
                  height: 80,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
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
  final double width;  
  final double height; 
  final double? top;  
  final double? bottom; 
  final double? left;
  final double? right;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SizedBox(
            width: width,   
            height: height,
            child: imagePath.endsWith('.svg')
                ? SvgPicture.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}