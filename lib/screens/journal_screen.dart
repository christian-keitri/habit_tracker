import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/journal.dart';
import 'package:habit_tracker/screens/habit.dart';

class JournalScreen extends StatefulWidget {
  final Habit habit;

  const JournalScreen({super.key, required this.habit});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  late Box<JournalEntry> journalBox;
  List<JournalEntry> entries = [];

  // Mood and Emoji State
  String _selectedMood = 'Happy';
  String _selectedEmoji = '😊';

  final List<String> moods = ['Happy', 'Sad', 'Anxious', 'Excited'];
  final List<String> emojis = ['😊', '😢', '😰', '🤩'];

  @override
  void initState() {
    super.initState();
    journalBox = Hive.box<JournalEntry>('journals');
    _loadEntries();
  }

  void _loadEntries() {
    final allEntries = journalBox.values
        .where((entry) => entry.habitId == widget.habit.key.toString())
        .toList();
    setState(() {
      entries = allEntries.reversed.toList();
    });
  }

  void _addEntry(String content) {
    final newEntry = JournalEntry(
      habitId: widget.habit.key.toString(),
      content: content,
      date: DateTime.now(),
      mood: _selectedMood,
      emoji: _selectedEmoji,
    );
    journalBox.add(newEntry);
    _controller.clear();
    _selectedMood = 'Happy';
    _selectedEmoji = '😊';
    _loadEntries();
  }

  void _confirmDelete(JournalEntry entry) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text("Are you sure you want to delete this journal entry?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      final deletedEntry = entry;
      final deletedKey = entry.key;
      await entry.delete();
      _loadEntries();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              journalBox.put(deletedKey, deletedEntry);
              _loadEntries();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/black.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Journal: ${widget.habit.title}',
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Write something...',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        _addEntry(_controller.text.trim());
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Mood:", style: TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    dropdownColor: Colors.black87,
                    value: _selectedMood,
                    style: const TextStyle(color: Colors.white),
                    items: moods.map((mood) {
                      return DropdownMenuItem(
                        value: mood,
                        child: Text(mood),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMood = val ?? 'Happy'),
                  ),
                  const SizedBox(width: 20),
                  const Text("Emoji:", style: TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    dropdownColor: Colors.black87,
                    value: _selectedEmoji,
                    style: const TextStyle(fontSize: 20),
                    items: emojis.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedEmoji = val ?? '😊'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Previous Entries',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: entries.isEmpty
                    ? const Center(
                        child: Text(
                          'No journal entries yet.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Card(
                            color: Colors.white24,
                            child: ListTile(
                              title: Text(
                                '${entry.emoji} ${entry.content}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mood: ${entry.mood}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  Text(
                                    entry.date
                                        .toLocal()
                                        .toString()
                                        .split('.')
                                        .first,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _confirmDelete(entry),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
