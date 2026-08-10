import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import '../models/book.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _totalBooks = 0;
  int _booksRead = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allBooks = await DatabaseHelper.instance.getAllBooks();
    final readCount =
        allBooks.where((b) => b.status == ReadingStatus.read).length;

    setState(() {
      _totalBooks = allBooks.length;
      _booksRead = readCount;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_totalBooks == 0) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 195, 212),
        body: const Center(
          child: Text('Add some books to see your progress!'),
        ),
      );
    }

    final progress = (_booksRead / _totalBooks).clamp(0.0, 1.0);
    final filled = _booksRead.toDouble();
    final remaining = (_totalBooks - _booksRead).toDouble();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 195, 212),
      body: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      value: filled,
                      color: const Color.fromARGB(255, 201, 108, 130),
                      radius: 30,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: remaining,
                      color: const Color.fromARGB(228, 255, 255, 255),
                      radius: 30,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_booksRead / $_totalBooks books',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}