import 'package:flutter/material.dart';

class Phase1 extends StatelessWidget {
  final List<String> habitIcons = const [
    'icon1.png', 'icon2.png', 'icon3.png',
    'icon4.png', 'icon5.png', 'icon6.png',
    'icon7.png', 'icon8.png', 'icon9.png',
    'icon10.png','icon11.png', 
  ];

  const Phase1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: habitIcons.map((icon) {
                  return Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/image/$icon',
                        width: 40,
                        height: 40,
                        // Remove color tint unless you're sure all icons are monochromatic
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'MAKE IT A\n',
                    style: TextStyle(fontSize: 24),
                  ),
                  TextSpan(
                    text: 'HABIT\n',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'TRACK IT',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "What are your habits?\nSelect your daily, weekly, or monthly habits.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Icon(
                  Icons.play_circle_fill,
                  size: 56,
                  color: Color(0xFF01522B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
