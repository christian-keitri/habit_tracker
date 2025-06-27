import 'dart:ui';
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
  DateTime _reminderDate = DateTime.now();
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> activityIconPaths = List.generate(
    20,
    (i) => 'assets/image/icon${i + 1}.png',
  );

  Future<void> _pickReminderDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _reminderDate = picked);
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  void _saveHabit() async {
    final name = _habitNameController.text.trim();
    if (name.isEmpty || _selectedIcon.isEmpty) {
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
    final dateLabel = "${_reminderDate.year}-${_reminderDate.month.toString().padLeft(2, '0')}-${_reminderDate.day.toString().padLeft(2, '0')}";
    final timeLabel = _reminderTime.format(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/black.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xAA000000), Color(0x66000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _habitNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Habit Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Frosted Icon Picker
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: ExpansionTile(
                        backgroundColor: Colors.white.withAlpha(25),
                        title: Row(children: [
                          const Text("Choose Activity Icon", style: TextStyle(color: Colors.white, fontSize: 20)),
                          if (_selectedIcon.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            Image.asset(_selectedIcon, width: 30, height: 30),
                          ]
                        ]),
                        initiallyExpanded: _iconPickerExpanded,
                        onExpansionChanged: (e) => setState(() => _iconPickerExpanded = e),
                        children: [
                          SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: activityIconPaths.map((path) {
                                final isSelected = _selectedIcon == path;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedIcon = path;
                                    _iconPickerExpanded = false;
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected ? Colors.greenAccent : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.asset(path, width: 50, height: 50),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Set Reminder", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.greenAccent),
                    title: Text('Date: $dateLabel', style: const TextStyle(color: Colors.white)),
                    onTap: _pickReminderDate,
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.greenAccent),
                    title: Text('Time: $timeLabel', style: const TextStyle(color: Colors.white)),
                    onTap: _pickReminderTime,
                  ),

                  SwitchListTile(
                    title: const Text("Is this a bad habit?", style: TextStyle(color: Colors.white)),
                    value: _isBad,
                    onChanged: (v) => setState(() => _isBad = v),
                    activeColor: Colors.redAccent,
                  ),
                  SwitchListTile(
                    title: const Text("Daily Routine", style: TextStyle(color: Colors.white)),
                    value: _isDaily,
                    onChanged: (v) => setState(() => _isDaily = v),
                    activeColor: Colors.greenAccent,
                  ),
                  SwitchListTile(
                    title: const Text("Weekly Routine", style: TextStyle(color: Colors.white)),
                    value: _isWeekly,
                    onChanged: (v) => setState(() => _isWeekly = v),
                    activeColor: Colors.greenAccent,
                  ),
                  SwitchListTile(
                    title: const Text("Monthly Routine", style: TextStyle(color: Colors.white)),
                    value: _isMonthly,
                    onChanged: (v) => setState(() => _isMonthly = v),
                    activeColor: Colors.greenAccent,
                  ),
                  const SizedBox(height: 20),

                  const Text('How many times daily?', style: TextStyle(color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          if (_dailyGoal > 1) setState(() => _dailyGoal--);
                        },
                      ),
                      Text('$_dailyGoal',
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => setState(() => _dailyGoal++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Neumorphic add button
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, offset: Offset(4, 4), blurRadius: 8),
                          BoxShadow(color: Colors.black26, offset: Offset(-4, -4), blurRadius: 8),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: _saveHabit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add Habit', style: TextStyle(fontSize: 18, color: Colors.black)),
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
