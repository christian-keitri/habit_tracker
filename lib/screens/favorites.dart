import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // <- This allows the background to go behind the AppBar
      appBar: AppBar(
        title: const Text('Favorite Habits'),
        backgroundColor: Colors.transparent, // Transparent to show background
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/image/favorites.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content with safe padding
          SafeArea(
            child: favorites.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite habits yet.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final habit = favorites[index];
                      return Card(
                        color: Colors.white.withAlpha(25),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(
                            habit['title'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            '${(habit['progress'] * 100).round()}%',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
