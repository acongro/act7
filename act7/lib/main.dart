import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MoodModel(), child: const MyApp()),
  );
}

// ===== State (Provider) =====
class MoodModel with ChangeNotifier {
  String _currentMoodPath = 'assets/moods/happy.png';
  String get currentMoodPath => _currentMoodPath;

  void setHappy() {
    _currentMoodPath = 'assets/moods/happy.png';
    notifyListeners();
  }

  void setSad() {
    _currentMoodPath = 'assets/moods/sad.png';
    notifyListeners();
  }

  void setExcited() {
    _currentMoodPath = 'assets/moods/excited.png';
    notifyListeners();
  }
}

// ===== App =====
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue), // safe across 3.x
      home: const HomePage(),
    );
  }
}

// ===== UI =====
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Toggle Challenge')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
          ],
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
          onPressed: () => context.read<MoodModel>().setHappy(),
          child: const Text('Happy 😊'),
        ),
        ElevatedButton(
          onPressed: () => context.read<MoodModel>().setSad(),
          child: const Text('Sad 😢'),
        ),
        ElevatedButton(
          onPressed: () => context.read<MoodModel>().setExcited(),
          child: const Text('Excited 🎉'),
        ),
      ],
    );
  }
}
