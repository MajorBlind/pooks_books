import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';
import 'add_book_screen.dart';

// Stateful widget for having book list on screen
class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];

  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async{
    final loadedBooks = await DatabaseHelper.instance.getAllBooks();
    setState(() {
      books = loadedBooks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 195, 212),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        title: const Text('My Reading List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
            ? const Center(child: Text('No books yet - Add one!'))
            : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index){
                  final book = books[index];
                  return ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  );
                },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookScreen()
            ),
          );
          _loadBooks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}