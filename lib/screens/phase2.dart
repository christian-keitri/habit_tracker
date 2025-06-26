import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/favorites.dart';
import 'package:habit_tracker/screens/phase4.dart';
import 'package:habit_tracker/screens/streaks.dart';

class Phase2 extends StatefulWidget {
  const Phase2({super.key});
  @override
  State<Phase2> createState() => _Phase2State();
}

class _Phase2State extends State<Phase2> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _updateHabitProgress(Habit habit, int newValue) {
    final key = '${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}';
    habit.dailyProgress[key] = newValue;
    habit.save();
    setState(() {});
  }

  void _toggleFavorite(Habit habit) {
    habit.isFavorite = !habit.isFavorite;
    habit.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Habit>('habits');
    final habits = box.values.toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/background2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: _buildDrawer(context, habits),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Your Daily Task', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                onDaySelected: (sel, foc) {
                  setState(() {
                    _selectedDay = sel;
                    _focusedDay = foc;
                  });
                },
                onFormatChanged: (fmt) => setState(() => _calendarFormat = fmt),
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                  formatButtonVisible: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.all(Radius.circular(6))),
                  formatButtonTextStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: Color.fromARGB(255, 148, 223, 129), shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Color.fromARGB(255, 42, 153, 17), shape: BoxShape.circle),
                  defaultTextStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  weekendTextStyle: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                  selectedTextStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  todayTextStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                  weekendStyle: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: habits.isEmpty
                    ? const Center(child: Text('No habits found.', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (ctx, i) {
                          final habit = habits[i];
                          final key = '${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}';
                          final currentValue = habit.dailyProgress[key] ?? 0;

                          return Card(
                            color: Colors.white.withAlpha(25),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListTile(
                              leading: habit.iconPath.isNotEmpty
                                  ? Image.asset(habit.iconPath, width: 32, height: 32)
                                  : null,
                              title: Text(habit.title, style: const TextStyle(color: Colors.white)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.white),
                                          onPressed: () {
                                            if (currentValue > 0) {
                                              _updateHabitProgress(habit, currentValue - 1);
                                            }
                                          },
                                        ),
                                        Text(
                                          '$currentValue / ${habit.dailyGoal}',
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () {
                                            if (currentValue < (habit.dailyGoal ?? 1)) {
                                              _updateHabitProgress(habit, currentValue + 1);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            habit.isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: habit.isFavorite ? Colors.red : Colors.white54,
                                          ),
                                          onPressed: () => _toggleFavorite(habit),
                                        ),
                                        const SizedBox(width: 8),

                                        // Progress Ring + Percentage + Streak
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        value: habit.dailyGoal != null && habit.dailyGoal! > 0
                                                            ? (currentValue / habit.dailyGoal!).clamp(0.0, 1.0)
                                                            : 0,
                                                        strokeWidth: 3,
                                                        backgroundColor: Colors.white24,
                                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      '${((currentValue / (habit.dailyGoal ?? 1)) * 100).clamp(0, 100).toInt()}%',
                                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 20),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          '${habit.getStreak()}',
                                                          style: const TextStyle(
                                                            color: Colors.orangeAccent,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            shadows: [
                                                              Shadow(blurRadius: 2, color: Colors.black45, offset: Offset(1, 1)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                       
                                      ],
                                    ),

                                  Row(
                                    children: [
                                      if (habit.isDailyRoutine)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text('Daily', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                      if (habit.isWeeklyRoutine)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text('Weekly', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                      if (habit.isMonthlyRoutine)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text('Monthly', style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 247, 248, 247),
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase3()));
            setState(() {}); // refresh after returning
          },
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, List<Habit> habits) {
    return Drawer(
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/image/drawer.png', fit: BoxFit.cover)),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text('Favorites', style: TextStyle(color: Colors.white)),
                onTap: () {
                  final favs = habits.where((h) => h.isFavorite).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoritesScreen(
                        favorites: favs,
                        onDelete: (h) {
                          h.delete();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics, color: Colors.white),
                title: const Text('Stats', style: TextStyle(color: Colors.white)),
                onTap: () {
                  if (habits.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No habits available for stats.")));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Phase4(habits: habits)));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.orange),
                title: const Text('Streaks', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StreaksScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
