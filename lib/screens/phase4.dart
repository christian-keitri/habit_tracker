import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Phase4 extends StatelessWidget {
  Phase4({super.key});

  final List<String> days = ['1', '2', '3', '4', '5', '6', '7'];
  final List<String> goodHabits = ['Meditate', 'Exercise', 'Eat Healthy', 'Drink more water'];
  final List<String> badHabits = ['Smoking', 'Procrastinating', 'Drinking Alcohol'];

  // Dummy data
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
    return [
      const FlSpot(1, 2),
      const FlSpot(2, 3),
      const FlSpot(3, 3),
      const FlSpot(4, 4),
      const FlSpot(5, 4),
      const FlSpot(6, 5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/background4.png', // ✅ Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.info, color: Colors.white),
                      Text('Stats.', style: TextStyle(color: Colors.white, fontSize: 20)),
                      Icon(Icons.menu, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
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
