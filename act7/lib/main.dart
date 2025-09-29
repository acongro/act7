import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MoodModel(), child: const MyApp()),
  );
}

class MoodModel with ChangeNotifier {
  String _currentMoodPath = 'assets/moods/happy.png';
  Color _backgroundColor = Colors.yellow.shade100;

  final Map<String, int> _counts = {'Happy': 0, 'Sad': 0, 'Excited': 0};

  String get currentMoodPath => _currentMoodPath;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get counts => Map.unmodifiable(_counts);

  void _bump(String key) {
    _counts[key] = (_counts[key] ?? 0) + 1;
  }

  void setHappy() {
    _currentMoodPath = 'assets/moods/happy.png';
    _backgroundColor = Colors.yellow.shade100;
    _bump('Happy');
    notifyListeners();
  }

  void setSad() {
    _currentMoodPath = 'assets/moods/sad.png';
    _backgroundColor = Colors.lightBlue.shade100;
    _bump('Sad');
    notifyListeners();
  }

  void setExcited() {
    _currentMoodPath = 'assets/moods/excited.png';
    _backgroundColor = Colors.orange.shade100;
    _bump('Excited');
    notifyListeners();
  }

  void setRandom() {
    switch (Random().nextInt(3)) {
      case 0:
        setHappy();
        break;
      case 1:
        setSad();
        break;
      default:
        setExcited();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final bg = context.watch<MoodModel>().backgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(title: const Text('Mood Toggle Challenge')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('How are you feeling?', style: TextStyle(fontSize: 24)),
              SizedBox(height: 24),
              MoodDisplay(),
              SizedBox(height: 36),
              MoodButtons(),
              SizedBox(height: 12),
              RandomMoodButton(),
              SizedBox(height: 24),
              MoodCounter(),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodDisplay extends StatelessWidget {
  const MoodDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (_, mood, __) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Image.asset(
          mood.currentMoodPath,
          key: ValueKey<String>(mood.currentMoodPath),
          width: 160,
          height: 160,
        ),
      ),
    );
  }
}

class MoodButtons extends StatelessWidget {
  const MoodButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () =>
              Provider.of<MoodModel>(context, listen: false).setHappy(),
          child: const Text('Happy 😊'),
        ),
        ElevatedButton(
          onPressed: () =>
              Provider.of<MoodModel>(context, listen: false).setSad(),
          child: const Text('Sad 😢'),
        ),
        ElevatedButton(
          onPressed: () =>
              Provider.of<MoodModel>(context, listen: false).setExcited(),
          child: const Text('Excited 🎉'),
        ),
      ],
    );
  }
}

class RandomMoodButton extends StatelessWidget {
  const RandomMoodButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () =>
          Provider.of<MoodModel>(context, listen: false).setRandom(),
      icon: const Icon(Icons.casino),
      label: const Text('Random'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class MoodCounter extends StatelessWidget {
  const MoodCounter({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (_, model, __) {
        final counts = model.counts;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CountPill(label: 'Happy', value: counts['Happy'] ?? 0),
                _CountPill(label: 'Sad', value: counts['Sad'] ?? 0),
                _CountPill(label: 'Excited', value: counts['Excited'] ?? 0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountPill extends StatelessWidget {
  final String label;
  final int value;
  const _CountPill({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.black.withOpacity(0.06),
          ),
          child: Text(value.toString(), style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
