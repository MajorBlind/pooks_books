import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';

class AddBookScreen extends StatefulWidget{
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen>{
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void dispose(){
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        title: const Text('Add a book'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newBook = Book(
                  title: _titleController.text,
                  author: _authorController.text,
                );
                await DatabaseHelper.instance.insertBook(newBook);
                if(context.mounted){
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Book'),
            ),
          ],
        ),
      ),
    );
  }
}