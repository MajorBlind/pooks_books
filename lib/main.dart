import 'package:flutter/material.dart';
import 'screens/book_list_screen.dart';

void main() {
  runApp(const PooksBooksApp());
}

class PooksBooksApp extends StatelessWidget{
  const PooksBooksApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'pooks_books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade100),
        useMaterial3: true,
      ),
      home: const BookListScreen(),
    );
  }
}