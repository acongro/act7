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

  String get currentMoodPath => _currentMoodPath;
  Color get backgroundColor => _backgroundColor;

  void setHappy() {
    _currentMoodPath = 'assets/moods/happy.png';
    _backgroundColor = Colors.yellow.shade100;
    notifyListeners();
  }

  void setSad() {
    _currentMoodPath = 'assets/moods/sad.png';
    _backgroundColor = Colors.lightBlue.shade100;
    notifyListeners();
  }

  void setExcited() {
    _currentMoodPath = 'assets/moods/excited.png';
    _backgroundColor = Colors.orange.shade100;
    notifyListeners();
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
