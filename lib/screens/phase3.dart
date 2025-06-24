import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Phase3 extends StatefulWidget {
  const Phase3({super.key});

  @override
  Phase3State createState() => Phase3State();
}

class Phase3State extends State<Phase3> {
  final TextEditingController _habitNameController = TextEditingController();
  int _selectedActivityIndex = 0;
  int _selectedFrequency = 0;
  bool _isBad = false;

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
  ];

  final List<String> _frequencyOptions = ['Daily', 'Weekly', 'Monthly'];
  final List<bool> _selectedDays = List.generate(7, (_) => false);
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  TimeOfDay _reminderTime = const TimeOfDay(hour: 6, minute: 0);

  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
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
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  const Text(
                    'Choose Activity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(activityIconPaths.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedActivityIndex = index),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedActivityIndex == index
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withAlpha(25),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              activityIconPaths[index],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Repetition Frequency',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(12),
                    isSelected: List.generate(
                      _frequencyOptions.length,
                      (index) => index == _selectedFrequency,
                    ),
                    onPressed: (index) => setState(() => _selectedFrequency = index),
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.green,
                    children: _frequencyOptions.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(e),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedFrequency == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Days of the Week',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 30,
                          children: List.generate(7, (index) {
                            return ChoiceChip(
                              label: Text(_days[index]),
                              selected: _selectedDays[index],
                              onSelected: (selected) => setState(() {
                                _selectedDays[index] = selected;
                              }),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  const Text(
                    'Set Reminder',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickReminderTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimeOfDay(_reminderTime),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text(
                      "Is this a bad habit?",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    value: _isBad,
                    onChanged: (value) => setState(() => _isBad = value),
                    activeColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_habitNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a habit name.')),
                          );
                          return;
                        }

                        final newHabit = {
                          'name': _habitNameController.text.trim(),
                          'icon': activityIconPaths[_selectedActivityIndex],
                          'frequency': _frequencyOptions[_selectedFrequency],
                          'days': _selectedDays,
                          'reminder': _reminderTime,
                          'isBad': _isBad,
                        };

                        Navigator.pop(context, newHabit);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 17, 185, 53),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Add Habit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
