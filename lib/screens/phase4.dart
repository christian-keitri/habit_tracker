import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/favorites.dart';
import 'package:habit_tracker/screens/phase1.dart';
import 'package:habit_tracker/screens/phase2.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/streaks.dart';

class Phase4 extends StatelessWidget {
  final List<Habit> habits;
  const Phase4({super.key, required this.habits});

  List<FlSpot> _generateLineChartData(List<Habit> goodHabits) {
    List<FlSpot> spots = [];

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final key = '${date.year}-${date.month}-${date.day}';

      double total = 0;
      int count = 0;

      for (var habit in goodHabits) {
        if (habit.dailyProgress.containsKey(key)) {
          total += habit.dailyProgress[key]!;
          count++;
        }
      }

      spots.add(FlSpot((i + 1).toDouble(), count == 0 ? 0 : total / count));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final goodHabits = habits.where((h) => !h.isBad).toList();
    final badHabits = habits.where((h) => h.isBad).toList();

    final Map<String, double> badHabitStats = {};
    for (var habit in badHabits) {
      double total = 0.0;
      for (var value in habit.dailyProgress.values) {
        total += value;
      }
      badHabitStats[habit.title] = total * 100;
    }

    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/background4.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: const Text('Stats.', style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Good Habits Progress", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              minX: 1,
                              maxX: 7,
                              backgroundColor: Colors.transparent,
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      if (value % 1 != 0) return const SizedBox.shrink();
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, _) {
                                      int index = value.toInt();
                                      if (value % 1 != 0 || index < 1 || index > 7) return const SizedBox.shrink();
                                      final date = DateTime.now().subtract(Duration(days: 7 - index));
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '${date.day}',
                                          style: const TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _generateLineChartData(goodHabits),
                                  isCurved: true,
                                  color: Colors.greenAccent,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text("Bad Habits Pie Chart", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 12),
                        badHabitStats.isEmpty
                            ? const Text("No bad habits yet 🎉", style: TextStyle(color: Colors.white))
                            : SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: badHabitStats.entries.map((e) {
                                      return PieChartSectionData(
                                        title: '${e.key}\n${e.value.toInt()}%',
                                        value: e.value,
                                        color: _getColorForHabit(e.key),
                                        radius: 60,
                                        titleStyle: const TextStyle(color: Colors.black, fontSize: 12),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 30),
                        const Text("Habit Completion Table", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20,
                              headingRowColor: WidgetStateProperty.all(Colors.transparent),
                              columns: const [
                                DataColumn(label: Text('Habit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Completed Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Streak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              ],
                              rows: habits.map((habit) {
                                final todayKey = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                                final completedToday = (habit.dailyProgress[todayKey] ?? 0.0) >= 1.0;
                                final streak = _calculateStreak(habit);

                                return DataRow(cells: [
                                  DataCell(Text(habit.title, style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(completedToday ? 'Yes ✅' : 'No ❌', style: const TextStyle(color: Colors.white))),
                                  DataCell(Text('$streak days', style: const TextStyle(color: Colors.white))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/drawer.avif', fit: BoxFit.cover),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.check, color: Colors.white),
                title: const Text('Your Daily Task', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase2())),
              ),
              ListTile(
                leading: const Icon(Icons.add_task, color: Colors.white),
                title: const Text('Add Task', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase3())),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text('Favorites', style: TextStyle(color: Colors.white)),
                onTap: () {
                  final favorites = habits.where((task) => task.isFavorite).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoritesScreen(
                        favorites: favorites,
                        onDelete: (habit) {
                          habit.delete();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.white),
                title: const Text('Streaks', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StreaksScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.white),
                title: const Text('Reset All Data', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Reset All Data"),
                      content: const Text("Are you sure you want to delete all habits and start over?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text("Confirm", style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final habitBox = Hive.box<Habit>('habits');
                    await habitBox.clear();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All habits have been reset.")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Phase4(habits: [])),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Phase1())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorForHabit(String habit) {
    switch (habit.toLowerCase()) {
      case 'smoking':
        return Colors.red;
      case 'procrastinating':
        return Colors.orange;
      case 'drinking alcohol':
        return Colors.purple;
      default:
        return Colors.blueAccent;
    }
  }

  int _calculateStreak(Habit habit) {
    int streak = 0;
    DateTime today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      final progress = habit.dailyProgress[key] ?? 0.0;
      if (progress >= 1.0) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
