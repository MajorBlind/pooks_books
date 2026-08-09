import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';

// Stateful widget for having book list on screen
class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('My Reading List')),
      body: const Center(child: Text('Books Will Go Here')),
    );
  }
}