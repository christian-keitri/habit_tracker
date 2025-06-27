import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Habit> favorites;
  final void Function(Habit)? onDelete;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    this.onDelete,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Habit> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favorites); // Make a local mutable copy
  }

  @override
  Widget build(BuildContext context) {
    final dailyRoutines = _favorites.where((h) => h.isDailyRoutine).toList();
    final weeklyRoutines = _favorites.where((h) => h.isWeeklyRoutine).toList();
    final monthlyRoutines = _favorites.where((h) => h.isMonthlyRoutine).toList();
    final favoriteOnly = _favorites.where((h) =>
        !h.isDailyRoutine && !h.isWeeklyRoutine && !h.isMonthlyRoutine).toList();

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
              'assets/image/black.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: _favorites.isEmpty
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
                        const _SectionTitle(title: 'Daily Routines', color: Colors.greenAccent),
                        ...dailyRoutines.map((habit) => _buildHabitCard(context, habit)),
                      ],
                      if (weeklyRoutines.isNotEmpty) ...[
                        const _SectionTitle(title: 'Weekly Routines', color: Colors.blueAccent),
                        ...weeklyRoutines.map((habit) => _buildHabitCard(context, habit)),
                      ],
                      if (monthlyRoutines.isNotEmpty) ...[
                        const _SectionTitle(title: 'Monthly Routines', color: Colors.orangeAccent),
                        ...monthlyRoutines.map((habit) => _buildHabitCard(context, habit)),
                      ],
                      if (favoriteOnly.isNotEmpty) ...[
                        const _SectionTitle(title: 'Favorites', color: Color.fromARGB(255, 209, 38, 26)),
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
        leading: habit.iconPath.isNotEmpty
            ? Image.asset(habit.iconPath, width: 32, height: 32)
            : Icon(
                habit.isDailyRoutine || habit.isWeeklyRoutine || habit.isMonthlyRoutine
                    ? Icons.repeat
                    : Icons.star,
                color: habit.isDailyRoutine
                    ? Colors.greenAccent
                    : habit.isWeeklyRoutine
                        ? Colors.blueAccent
                        : habit.isMonthlyRoutine
                            ? Colors.orangeAccent
                            : Colors.amber,
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
              habit.delete(); // Delete from Hive
              setState(() {
                _favorites.remove(habit); // Refresh local list
              });
              if (widget.onDelete != null) widget.onDelete!(habit);
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
              habit.save(); // Save updated title
              Navigator.pop(context);
              setState(() {}); // Refresh UI
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
