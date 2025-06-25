import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Habit> favorites;
  final void Function(Habit)? onDelete;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dailyRoutines = favorites.where((habit) => habit.dailyProgress.isNotEmpty).toList();
    final favoriteOnly = favorites
        .where((habit) => habit.dailyProgress.isEmpty)
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Favorite Habits'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/favorites.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: favorites.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite habits yet.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      if (dailyRoutines.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(
                            'Daily Routines',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...dailyRoutines.map((habit) => _buildHabitCard(context, habit)),
                      ],
                      if (favoriteOnly.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(
                            'Favorites',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...favoriteOnly.map((habit) => _buildHabitCard(context, habit)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    final completedDays = habit.dailyProgress.values
    .map((v) => v.toDouble())
    .where((v) => v >= 1.0)
    .length;

    return Card(
      color: Colors.white.withAlpha(25),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          habit.dailyProgress.isNotEmpty ? Icons.repeat : Icons.star,
          color: habit.dailyProgress.isNotEmpty ? Colors.greenAccent : Colors.amber,
        ),
        title: Text(
          habit.title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Completed: $completedDays days',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white70),
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context, habit);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, habit);
            }
          },
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              habit.delete();
              if (onDelete != null) onDelete!(habit);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Habit habit) {
    final controller = TextEditingController(text: habit.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Habit Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              habit.title = controller.text;
              habit.save();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
