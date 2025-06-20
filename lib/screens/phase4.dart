import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_tracker/global_data.dart' as global;
import 'package:habit_tracker/screens/favorites.dart';
import 'package:habit_tracker/screens/phase1.dart';
import 'package:habit_tracker/screens/phase2.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/streaks.dart';

class Phase4 extends StatelessWidget {
  Phase4({super.key});

  final List<String> days = ['1', '2', '3', '4', '5', '6', '7'];
  final List<String> goodHabits = ['Meditate', 'Exercise', 'Eat Healthy', 'Drink more water'];
  final List<String> badHabits = ['Smoking', 'Procrastinating', 'Drinking Alcohol'];

  final Map<String, List<bool>> goodHabitChecks = {
    'Meditate': [true, false, true, true, false, true, true],
    'Exercise': [false, true, false, false, true, true, false],
    'Eat Healthy': [true, true, false, true, true, false, false],
    'Drink more water': [true, true, true, true, true, true, true],
  };

  final Map<String, List<bool>> badHabitChecks = {
    'Smoking': [false, true, false, true, false, false, false],
    'Procrastinating': [true, true, true, false, false, false, false],
    'Drinking Alcohol': [false, true, false, false, true, false, false],
  };

  final Map<String, double> badHabitStats = {
    'Smoking': 30,
    'Procrastinating': 50,
    'Drinking Alcohol': 20,
  };

  List<FlSpot> _generateLineChartData() {
    return const [
      FlSpot(1, 2),
      FlSpot(2, 3),
      FlSpot(3, 3),
      FlSpot(4, 4),
      FlSpot(5, 4),
      FlSpot(6, 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/background4.png',
              fit: BoxFit.cover,
            ),
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Good Habits:", style: TextStyle(color: Colors.white, fontSize: 18)),
                        _buildHabitTable(goodHabits, goodHabitChecks),
                        const SizedBox(height: 16),
                        const Text("Good Habits Graph", style: TextStyle(color: Colors.white)),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.transparent,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _generateLineChartData(),
                                  isCurved: true,
                                  color: Colors.greenAccent,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Bad Habits:", style: TextStyle(color: Colors.white, fontSize: 18)),
                        _buildHabitTable(badHabits, badHabitChecks),
                        const SizedBox(height: 16),
                        const Text("Bad Habits Pie Chart", style: TextStyle(color: Colors.white)),
                        SizedBox(
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
            child: Image.asset(
              'assets/image/drawer.avif',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.check, color: Colors.white),
                title: const Text('Your Daily Task', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Phase2()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_task, color: Colors.white),
                title: const Text('Add Task', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Phase3()));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.white),
                  title: const Text('Favorites', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    final favorites = global.taskList
                        .where((task) => task['isFavorite'] == true)
                        .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(favorites: favorites),
                      ),
                    );
                  },
                ),

              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.white),
                title: const Text('Streaks', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StreaksScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Phase1()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitTable(List<String> habits, Map<String, List<bool>> checks) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('', style: TextStyle(color: Colors.white)),
            ),
            ...days.map((d) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(d, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                )),
          ],
        ),
        ...habits.map(
          (habit) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(habit, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              ...checks[habit]!.map((checked) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      checked ? Icons.check : Icons.close,
                      color: checked ? Colors.white : Colors.white24,
                      size: 20,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForHabit(String habit) {
    switch (habit) {
      case 'Smoking':
        return Colors.red;
      case 'Procrastinating':
        return Colors.grey;
      case 'Drinking Alcohol':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }
}
