import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database DB) async {
    await DB.execute("""Create TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'task.db',
      version: 1,
      onCreate: (sql.Database DB, int version) async {
        await createTables(DB);
      },
    );
  }

  static Future<int> createItem(String title, String description) async {
    final DB = await SQLHelper.db();

    final data = {'title': title, 'description': description};

    final id = await DB.insert(
      'items',
      data,
      conflictAlgorithm:
          sql.ConflictAlgorithm.replace, // this for prevent doublicating data
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final DB = await SQLHelper.db();
    return DB.query(
      'items',
      orderBy: "createdAt",
    );
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final DB = await SQLHelper.db();
    return DB.query(
      'items',
      where: "id = ?",
      whereArgs: [id],
      orderBy: "createdAt",
    );
  }

  static Future<int> updateItem(
      int id, String title, String description) async {
    final DB = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(),
    };

    final result = DB.update(
      'items',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final DB = await SQLHelper.db();
    try {
      DB.delete(
        'items',
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item : $err ");
    }
  }
}
