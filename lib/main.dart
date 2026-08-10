import 'package:flutter/material.dart';
import 'package:auto_updater/auto_updater.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await autoUpdater.setFeedURL(
    'https://raw.githubusercontent.com/MajorBlind/pooks_books/main/appcast.xml',
  );
  await autoUpdater.checkForUpdates();
  await autoUpdater.setScheduledCheckInterval(86400);

  runApp(const PooksBooksApp());
}

class PooksBooksApp extends StatelessWidget {
  const PooksBooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pooks_books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}