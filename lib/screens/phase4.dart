import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/favorites.dart';
import 'package:habit_tracker/screens/phase1.dart';
import 'package:habit_tracker/screens/phase2.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/streaks.dart';
import 'package:habit_tracker/screens/journal_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/journal.dart';

class Phase4 extends StatelessWidget {
  final List<Habit> habits;
  const Phase4({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Habit Statistics', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/image/black.png', fit: BoxFit.cover)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight + 10),
                  const Text("Habit Completion Bar Chart", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) => Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= habits.length) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Image.asset(habits[index].iconPath, width: 24, height: 24),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups: List.generate(habits.length, (index) {
                          final habit = habits[index];
                          final streak = habit.getStreak().toDouble();
                          final todayKey = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                          final completedToday = habit.dailyProgress[todayKey] != null &&
                              habit.dailyProgress[todayKey]! >= (habit.dailyGoal ?? 1)
                              ? 1.0
                              : 0.0;

                          return BarChartGroupData(x: index, barRods: [
                            BarChartRodData(
                              toY: streak,
                              width: 16,
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY: completedToday * 5,
                              width: 8,
                              color: const Color.fromARGB(255, 70, 58, 43),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ]);
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text("Habit Heatmap", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 4),
                  const Text("Each square represents a day. Green = completed any habit.",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegendBox(Colors.green, "Completed"),
                      const SizedBox(width: 16),
                      _buildLegendBox(const Color.fromARGB(255, 255, 252, 252), "Missed"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 24,
                    runSpacing: 6,
                    children: List.generate(30, (i) {
                      final day = DateTime.now().subtract(Duration(days: 29 - i));
                      final dayKey = '${day.year}-${day.month}-${day.day}';
                      final completed = habits.any((habit) =>
                          habit.dailyProgress[dayKey] != null &&
                          habit.dailyProgress[dayKey]! >= (habit.dailyGoal ?? 1));

                      return Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: completed ? Colors.green : const Color.fromARGB(255, 245, 245, 245),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),
                  const Text("Weekly Trend (Line Chart)", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.show_chart, color: Colors.blueAccent, size: 16),
                      SizedBox(width: 4),
                      Text('Streaks', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.show_chart, color: Colors.orangeAccent, size: 16),
                      SizedBox(width: 4),
                      Text('Completion Rate', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.show_chart, color: Colors.redAccent, size: 16),
                      SizedBox(width: 4),
                      Text('Missed Days', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: (habits.length - 1).toDouble(),
                        minY: 0,
                        maxY: 100,
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= habits.length) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Image.asset(habits[index].iconPath, width: 24, height: 24),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, interval: 20, getTitlesWidget: (value, _) {
                              return Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10));
                            }),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(habits.length, (index) {
                              final habit = habits[index];
                              return FlSpot(index.toDouble(), habit.getStreak().toDouble() * 10);
                            }),
                            isCurved: true,
                            color: Colors.blueAccent,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: List.generate(habits.length, (index) {
                              final habit = habits[index];
                              double rate = habit.getCompletionRate();
                              return FlSpot(index.toDouble(), rate.isNaN ? 0.0 : rate);
                            }),
                            isCurved: true,
                            color: Colors.orangeAccent,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: List.generate(habits.length, (index) {
                              final habit = habits[index];
                              final totalDays = habit.dailyProgress.length;
                              final completedDays = habit.dailyProgress.values.where((v) => v >= (habit.dailyGoal ?? 1)).length;
                              final missedDays = totalDays - completedDays;
                              final percentMissed = totalDays == 0 ? 0.0 : (missedDays / totalDays) * 100;
                              return FlSpot(index.toDouble(), percentMissed);
                            }),
                            isCurved: true,
                            color: Colors.redAccent,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color, margin: const EdgeInsets.only(right: 4)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  void resetData(BuildContext context, List<Habit> habits) async {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  // Clear habits
  for (var habit in habits) {
    await habit.delete();
  }

  // Clear journal entries too
  final journalBox = Hive.box<JournalEntry>('journals');
  await journalBox.clear();

  messenger.showSnackBar(
    const SnackBar(content: Text("All data has been reset.")),
  );

  navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const Phase2()),
    (route) => false,
  );
}





  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/image/black.png', fit: BoxFit.cover)),
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
                leading: const Icon(Icons.book, color: Colors.white),
                title: const Text('Journal', style: TextStyle(color: Colors.white)),
                onTap: () {
                  if (habits.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No habits available for journal.")),
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
                      builder: (context) => ListView(
                        children: habits.map((habit) {
                          return ListTile(
                            leading: habit.iconPath.isNotEmpty
                                ? Image.asset(habit.iconPath, width: 24, height: 24)
                                : const Icon(Icons.bookmark),
                            title: Text(habit.title, style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => JournalScreen(habit: habit)),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.white),
                title: const Text('Reset Data', style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.black87,
                      title: const Text('Confirm Reset', style: TextStyle(color: Colors.white)),
                      content: const Text('Are you sure you want to delete all data?', style: TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx); // close dialog
                            resetData(context, habits);// call the method
                          },
                          child: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );
                },
              ),


              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase1())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
