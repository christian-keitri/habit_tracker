import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/screens/favorites.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/phase4.dart';
import 'package:habit_tracker/screens/streaks.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:logger/logger.dart';

class Phase2 extends StatefulWidget {
  const Phase2({super.key});

  @override
  Phase2State createState() => Phase2State();
}

class Phase2State extends State<Phase2> {
  final logger = Logger();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    habitBox = Hive.box<Habit>('habits');
    _selectedDay = _focusedDay;
  }

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';

  @override
  Widget build(BuildContext context) {
    final taskList = habitBox.values.toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/background2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 32, 209, 56),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white70),
                      outsideTextStyle: TextStyle(color: Colors.grey),
                    ),
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(color: Colors.white),
                      formatButtonTextStyle: TextStyle(color: Colors.black),
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white70),
                      weekendStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Daily Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star, color: Colors.amber),
                            tooltip: 'Favorites',
                            onPressed: () {
                              final favorites = taskList
                                  .where((task) => task.isFavorite)
                                  .map((task) => {
                                        'title': task.title,
                                        'icon': task.icon,
                                        'progress': task.progress,
                                        'isFavorite': task.isFavorite,
                                        'isBad': task.isBad,
                                      })
                                  .toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoritesScreen(favorites: favorites),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.local_fire_department, color: Colors.orange),
                            tooltip: 'Streaks',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StreaksScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            tooltip: 'Stats',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Phase4()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: habitBox.listenable(),
                      builder: (context, Box<Habit> box, _) {
                        final habits = box.values.toList();
                        final selectedDate = _selectedDay ?? DateTime.now();
                        final todayKey = _formatDate(selectedDate);

                        return habits.isEmpty
                            ? const Center(
                                child: Text(
                                  'No tasks yet.\nTap "Add Habit" to get started!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70, fontSize: 18),
                                ),
                              )
                            : ListView.builder(
                                itemCount: habits.length,
                                itemBuilder: (context, index) {
                                  final task = habits[index];
                                  final isChecked = task.dailyProgress[todayKey] == 1.0;

                                  return CheckboxListTile(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        task.dailyProgress[todayKey] = value == true ? 1.0 : 0.0;
                                        task.save();
                                        logger.i('Checkbox updated: ${task.title} = ${value == true ? 1.0 : 0.0}');
                                      });
                                    },
                                    title: Row(
                                      children: [
                                        if (task.icon.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Image.asset(
                                              task.icon,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            task.isFavorite ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              task.isFavorite = !task.isFavorite;
                                              task.save();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    activeColor: task.isBad ? Colors.red : Colors.green,
                                    tileColor: Colors.white.withAlpha(30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    checkColor: Colors.black,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        logger.i("Hello! Button Pressed");
                        final newHabit = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Phase3()),
                        );

                        if (newHabit != null) {
                          final newHabitObj = Habit(
                            title: newHabit['name'],
                            icon: newHabit['icon'],
                            progress: 0.0,
                            isFavorite: false,
                            isBad: false,
                            dailyProgress: {},
                          );

                          habitBox.add(newHabitObj);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Habit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 31, 226, 89),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
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
}