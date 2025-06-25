import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';

class Phase3 extends StatefulWidget {
  const Phase3({super.key});

  @override
  Phase3State createState() => Phase3State();
}

class Phase3State extends State<Phase3> {
  final TextEditingController _habitNameController = TextEditingController();
  bool _isBad = false;
  bool _isDaily = false;
  bool _isWeekly = false;
  bool _isMonthly = false;
  bool _iconPickerExpanded = false;
  String _selectedIcon = '';

  int _dailyGoal = 1;

  // New: reminder date & time
  DateTime _reminderDate = DateTime.now();
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> activityIconPaths = [
     'assets/image/icon1.png',
    'assets/image/icon2.png',
    'assets/image/icon3.png',
    'assets/image/icon4.png',
    'assets/image/icon5.png',
    'assets/image/icon6.png',
    'assets/image/icon7.png',
    'assets/image/icon8.png',
    'assets/image/icon9.png',
    'assets/image/icon10.png',
    'assets/image/icon11.png',
    'assets/image/icon12.png',
    'assets/image/icon13.png',
    'assets/image/icon14.png',
    'assets/image/icon15.png',
    'assets/image/icon16.png',
  ];

  Future<void> _pickReminderDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: today.add(const Duration(days: 365)),
    );
    if (!mounted || picked == null) return;
    setState(() => _reminderDate = picked);
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (!mounted || picked == null) return;
    setState(() => _reminderTime = picked);
  }

  void _saveHabit() async {
    final name = _habitNameController.text.trim();
    if (name.isEmpty || _selectedIcon.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name and select an icon.')),
      );
      return;
    }

    final box = Hive.box<Habit>('habits');
    final newHabit = Habit(
      title: name,
      iconPath: _selectedIcon,
      isBad: _isBad,
      isDailyRoutine: _isDaily,
      isWeeklyRoutine: _isWeekly,
      isMonthlyRoutine: _isMonthly,
      isFavorite: false,
      dailyProgress: {},
      dailyGoal: _dailyGoal,
    );
    await box.add(newHabit);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        "${_reminderDate.year}-${_reminderDate.month.toString().padLeft(2,'0')}-${_reminderDate.day.toString().padLeft(2,'0')}";
    final timeLabel = _reminderTime.format(context);

    return Scaffold(
      body: Stack(children: [
        // background
        SizedBox.expand(
          child: Image.asset(
            'assets/image/background3.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back + title
                Stack(alignment: Alignment.center, children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Add Habit',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                // name
                TextField(
                  controller: _habitNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // icon picker
                ExpansionTile(
                  title: Row(children: [
                    const Text(
                      "Choose Activity Icon",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    if (_selectedIcon.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Image.asset(_selectedIcon, width: 30, height: 30),
                    ]
                  ]),
                  initiallyExpanded: _iconPickerExpanded,
                  onExpansionChanged: (e) =>
                      setState(() => _iconPickerExpanded = e),
                  children: [
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: activityIconPaths.map((path) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = path;
                                _iconPickerExpanded = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(path, width: 50, height: 50),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // reminder section
                const Text(
                  'Set Reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.calendar_today, color: Colors.greenAccent),
                  title: Text('Date: $dateLabel',
                      style: const TextStyle(color: Colors.white)),
                  onTap: _pickReminderDate,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.access_time, color: Colors.greenAccent),
                  title:
                      Text('Time: $timeLabel', style: const TextStyle(color: Colors.white)),
                  onTap: _pickReminderTime,
                ),
                const SizedBox(height: 20),

                // routine toggles
                SwitchListTile(
                  title: const Text("Is this a bad habit?",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  value: _isBad,
                  onChanged: (v) => setState(() => _isBad = v),
                  activeColor: Colors.redAccent,
                ),
                SwitchListTile(
                  title: const Text("Daily Routine",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  value: _isDaily,
                  onChanged: (v) => setState(() => _isDaily = v),
                  activeColor: Colors.greenAccent,
                ),
                SwitchListTile(
                  title: const Text("Weekly Routine",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  value: _isWeekly,
                  onChanged: (v) => setState(() => _isWeekly = v),
                  activeColor: Colors.greenAccent,
                ),
                SwitchListTile(
                  title: const Text("Monthly Routine",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  value: _isMonthly,
                  onChanged: (v) => setState(() => _isMonthly = v),
                  activeColor: Colors.greenAccent,
                ),
                const SizedBox(height: 30),


                const SizedBox(height: 20),
const Text(
  'How many times should this habit be done daily?',
  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      icon: const Icon(Icons.remove, color: Colors.white),
      onPressed: () {
        if (_dailyGoal > 1) {
          setState(() {
            _dailyGoal--;
          });
        }
      },
    ),
    Text(
      '$_dailyGoal',
      style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    IconButton(
      icon: const Icon(Icons.add, color: Colors.white),
      onPressed: () {
        setState(() {
          _dailyGoal++;
        });
      },
    ),
  ],
),

const SizedBox(height: 30),

                // save
                Center(
                  child: ElevatedButton(
                    onPressed: _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 17, 185, 53),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Habit',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
