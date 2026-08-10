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
                  return Dismissible(
                    key: Key(book.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.shade300,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async{
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete this book?'),
                          content: Text('This will permanently delete "${book.title}.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async{
                      await DatabaseHelper.instance.deleteBook(book.id!);
                      setState(() {
                        books.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(book.title),
                          if(book.rating != null) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.favorite, color: Colors.pink, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              book.rating!.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text('${book.author} -> ${_statusLabel(book.status)}'),
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBookScreen(bookToEdit: book),
                          ),
                        );
                        _loadBooks();
                      },
                    ),
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
}