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
  final List<IconData> _activityIcons = [
    Icons.card_giftcard,
    Icons.message,
    Icons.favorite,
    Icons.directions_run,
    Icons.home,
  ];

  int _selectedFrequency = 0;
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
                          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 239, 241, 239)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Add Habit',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 245, 248, 245),
                          ),
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
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green), // or any color you prefer
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_activityIcons.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedActivityIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedActivityIndex == index
                                ? const Color.fromARGB(255, 23, 192, 37)
                                : Colors.grey[300],
                          ),
                          child: Icon(
                            _activityIcons[index],
                            size: 32,
                            color: _selectedActivityIndex == index
                                ? Colors.white
                                : Colors.black87,
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
                    onPressed: (int index) {
                      setState(() {
                        _selectedFrequency = index;
                      });
                    },
                    color: Colors.white,
                    selectedColor: const Color.fromARGB(255, 251, 252, 251),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (index) {
                            return ChoiceChip(
                              label: Text(_days[index]),
                              selected: _selectedDays[index],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedDays[index] = selected;
                                });
                              },
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
                        border: Border.all(color: const Color.fromARGB(255, 27, 167, 45)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimeOfDay(_reminderTime),
                            style: const TextStyle(fontSize: 16,color: Colors.white,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Habit Added!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 17, 185, 53),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
