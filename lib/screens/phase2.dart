import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/screens/phase3.dart';
import 'package:habit_tracker/screens/phase4.dart';
import 'package:habit_tracker/screens/streaks.dart';


class Phase2 extends StatefulWidget {
  const Phase2({super.key});

  @override
  Phase2State createState() => Phase2State();
}

class Phase2State extends State<Phase2> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, dynamic>> taskList = [];

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              'assets/image/background2.png',
              fit: BoxFit.cover,
            ),
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
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
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
                    child: Column(
                      children: [
                        Expanded(
                          child: taskList.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No tasks yet.\nTap "Add Habit" to get started!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                )
                              : ListView(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  children: taskList.map((task) => Card(
                                    color: Colors.white.withAlpha(30),
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              if (task['icon'] != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 12.0),
                                                  child: Image.asset(
                                                    task['icon'],
                                                    width: 30,
                                                    height: 30,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              Expanded(
                                                child: Text(
                                                  task['title'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${(task['progress'] * 100).round()}%',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          LinearProgressIndicator(
                                            value: task['progress'],
                                            backgroundColor: Colors.grey.shade300,
                                            color: const Color.fromARGB(255, 91, 233, 55),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  task['progress'] += 0.3;
                                                  if (task['progress'] > 1.0) {
                                                    task['progress'] = 1.0;
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.check_circle_outline, color: Color.fromARGB(255, 34, 235, 44)),
                                              label: const Text(
                                                'Mark as Done',
                                                style: TextStyle(color: Color.fromARGB(255, 243, 245, 243)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )).toList(),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final newHabit = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Phase3()),
                              );

                              if (newHabit != null) {
                                setState(() {
                                  taskList.add({
                                    'title': newHabit['name'],
                                    'icon': newHabit['icon'],
                                    'progress': 0.0,
                                  });
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Habit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 31, 226, 89),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
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
