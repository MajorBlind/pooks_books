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
}

Future<Database> get database async{
    if (_database != null){
        return _database!;
    }

    _database = await _initDB('books.db');

    return _database!;
}

Future<Database> _initDB(String fileName) async{
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasePath();
    final path = join(dbPath, fileName);

    return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: _createDB,
        ),
    );
}