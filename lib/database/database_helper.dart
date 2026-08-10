// File systems access
import 'dart:io';
// Desktop SQLite bridge
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// File path helper
import 'package:path/path.dart';
// Book model
import '../models/book.dart';

// Singleton pattern - Assures only one database connection open for entire app
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

    // Getter function for database
    Future<Database> get database async{
        if (_database != null){
            return _database!;
        }

        _database = await _initDB('books.db');

        return _database!;
    }

    // Initializes database
    Future<Database> _initDB(String fileName) async{
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;

        final dbPath = await getDatabasesPath();
        final path = join(dbPath, fileName);

        return await databaseFactory.openDatabase(
            path,
            options: OpenDatabaseOptions(
                version: 1,
                onCreate: _createDB,
            ),
        );
    }

    // Defines 'books' table
    Future<void> _createDB(Database db, int version) async{
        await db.execute('''
        CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            series TEXT,
            status TEXT NOT NULL,
            startDate TEXT,
            finishDate TEXT,
            rating REAL,
            spiceRating INTEGER,
            notes TEXT,
            summary TEXT,
            coverPath TEXT,
            characters TEXT,
            feelings TEXT,
            wouldRecommend INTEGER,
            quote TEXT
            )
        ''');
    }

    // Method to actually save Book to database
    Future<Book> insertBook(Book book) async{
        final db = await instance.database;
        final id = await db.insert('books', book.toMap());
        return book.toMap()['id'] == null
            ? Book.fromMap({...book.toMap(), 'id': id})
            : book;
    }

    // Reads every saved book back out of the database
    Future<List<Book>> getAllBooks() async{
      final db = await instance.database;
      final result = await db.query('books');
      return result.map((map) => Book.fromMap(map)).toList();
    }

    // Takes book object to overwrite matching database row with new values
    Future<int> updateBook(Book book) async{
      final db = await instance.database;
      return db.update(
        'books',
        book.toMap(),
        where: 'id = ?',
        whereArgs: [book.id],
      );
    }

    // Take books ID and remove the whole row
    Future<int> deleteBook(int id) async{
      final db = await instance.database;
      return db.delete(
        'books',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
}