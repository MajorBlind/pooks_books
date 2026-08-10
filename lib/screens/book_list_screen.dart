import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';
import 'add_book_screen.dart';
import '../widgets/book_card.dart';

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center (child: Text('No books yet - Add one!'))
              : ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildStatusSection('Reading', ReadingStatus.reading),
                  _buildStatusSection('Want To Read', ReadingStatus.wantToRead),
                  _buildStatusSection('Read', ReadingStatus.read),
                ],
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

  Widget _buildStatusSection(String label, ReadingStatus status) {
    final sectionBooks = _booksByStatus(status);
    if(sectionBooks.isEmpty){
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sectionBooks.length,
              itemBuilder: (context, index){
                final book = sectionBooks[index];
                return BookCard(
                  book: book,
                  onTap: () async{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBookScreen(bookToEdit: book),
                      ),
                    );
                    _loadBooks();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead:
        return 'Want To Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.read:
        return 'Read';
    }
  }

  List<Book> _booksByStatus(ReadingStatus status) {
    return books.where((b) => b.status == status).toList();
  }
}