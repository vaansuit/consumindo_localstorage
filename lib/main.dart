import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void init() async {
    void initState() {
      init();
      super.initState();
    }

    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}task.db';

// Delete the database
    // await deleteDatabase(path);

// open the database
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
        );
      },
    );

// Insert some records in a transaction
    await database.transaction(
      (txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
        print(
          'inserted1: $id1',
        );
        int id2 = await txn.rawInsert(
            'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
            ['another name', 12345678, 3.1416]);
        print(
          'inserted2: $id2',
        );
      },
    );

// Update some record
    int count = await database.rawUpdate(
      'UPDATE Test SET name = ?, value = ? WHERE name = ?',
      ['updated name', '9876', 'some name'],
    );
    print('updated: $count');

// Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    List<Map> expectedList = [
      {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
      {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    ];
    print(list);
    print(expectedList);

// Count the records

// Delete a record
    count = await database.rawDelete(
      'DELETE FROM Test WHERE name = ?',
      ['another name'],
    );

// Close the database
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
