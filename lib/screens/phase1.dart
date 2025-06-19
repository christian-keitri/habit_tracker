import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/phase2.dart';

class Phase1 extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Phase1({super.key});

  @override
  State<Phase1> createState() => _Phase1State();
}

class _Phase1State extends State<Phase1> {
  final List<String> habitIcons = const [
    'icon1.png', 'icon2.png', 'icon3.png',
    'icon4.png', 'icon5.png', 'icon6.png',
    'icon7.png', 'icon8.png', 'icon9.png',
    'icon10.png', 'icon11.png', 'icon12.png',
  ];

  int? selectedIndex;

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
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                children: List.generate(habitIcons.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == index
                              ? Colors.green
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/image/${habitIcons[index]}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Just Me Again Down Here',
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'MAKE IT A\n',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'HABIT\n',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'TRACK IT',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "What are your habits?\nSelect your daily, weekly, or monthly habits.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 15, 14, 14),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  if (selectedIndex != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Phase2(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an icon first.'),
                      ),
                    );
                  }
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
