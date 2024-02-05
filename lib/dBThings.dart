import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTable(Database database) async {
    try {
      await database.execute('''
  CREATE TABLE IF NOT EXISTS book3 (
    bookName TEXT PRIMARY KEY,
    bookAuthor TEXT,
    bookDescription TEXT,
    bookImage TEXT,
    bookPDFLink TEXT
  )
''');
    } catch (e) {
      print('Error creating table: $e');
    }


  }


  static Future<Database> db() async {
    return openDatabase('dbBookStore', version: 1,
        onCreate:  (Database db, int version )async{
      await createTable(db);
        }

    );

  }

  static Future<int> createItem(String bookName, String bookAuthor, String bookDescription, String bookImage, String bookPDFLink) async {
    final db = await SQLHelper.db();
    final data = {
      'bookName': bookName,
      'bookAuthor': bookAuthor,
      'bookDescription': bookDescription,
      'bookImage': bookImage,
      'bookPDFLink': bookPDFLink,
    };

    try {
      // Use insertOrIgnore to avoid inserting if the book already exists
      final id = await db.insert('book3', data, conflictAlgorithm: ConflictAlgorithm.ignore);
      return id;
    } catch (e) {
      print('Error creating item: $e');
      return -1; // Return a failure indicator, you can handle it as needed
    }
  }


  static Future<List<Map<String,dynamic>>> getBooks() async {
    final db = await SQLHelper.db();
    return db.query("book3", orderBy: "bookName");
  }



  static Future<void> dropTable() async {
    try {
      final db = await SQLHelper.db();
      await db.execute('DROP TABLE IF EXISTS books');
    } catch (e) {
      print('Error dropping table: $e');
    }
  }


  static Future<int> deleteItem(String bookname) async {
    try {
      final db = await SQLHelper.db();
      return await db.delete('book3', where: 'bookName = ?', whereArgs: [bookname]);
    } catch (e) {
      print('Error deleting item: $e');
      return -1; // Return a failure indicator, you can handle it as needed
    }
  }
}


class SQLHelperForNotes {
  static Future<void> createTable(Database database) async {
    try {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS Notes (
          NoteID TEXT PRIMARY KEY,
          book TEXT,
          Note TEXT,
          PageNumber TEXT
        )
      ''');
    } catch (e) {
      print('Error creating table: $e');
    }
  }

  static Future<Database> db() async {
    return openDatabase(
      'dbBookStore',
      version: 1,
      onCreate: (Database db, int version) async {
        await createTable(db);
      },
    );
  }

  static Future<int> createItem(String noteID, String book, String note, String pageNumber) async {
    final db = await SQLHelperForNotes.db();
    final data = {
      'NoteID': noteID,
      'book': book,
      'Note': note,
      'PageNumber': pageNumber,
    };

    try {
      final id = await db.insert('Notes', data, conflictAlgorithm: ConflictAlgorithm.ignore);
      return id;
    } catch (e) {
      print('Error creating item: $e');
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelperForNotes.db();
    return db.query('Notes', orderBy: 'PageNumber');
  }

  static Future<void> dropTable() async {
    try {
      final db = await SQLHelperForNotes.db();
      await db.execute('DROP TABLE IF EXISTS Notes');
    } catch (e) {
      print('Error dropping table: $e');
    }
  }

  static Future<int> deleteItem(String noteID) async {
    try {
      final db = await SQLHelperForNotes.db();
      return await db.delete('Notes', where: 'NoteID = ?', whereArgs: [noteID]);
    } catch (e) {
      print('Error deleting item: $e');
      return -1;
    }
  }
}
