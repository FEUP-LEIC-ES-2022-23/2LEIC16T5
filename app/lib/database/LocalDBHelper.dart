import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:es/model/TransactionsModel.dart' as model;

class LocalDBHelper {
  LocalDBHelper._privateConstructor();

  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Transactions2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Transact(
      id_transaction NUMERIC,
      expense NUMERIC,
      name VARCHAR(50) NOT NULL,
      total NUMERIC NOT NULL CHECK (total >= 0),
      date DATE,
      notes VARCHAR(200),
      PRIMARY KEY (id_transaction)
      );
      ''');
  }

  Future<List<model.Transaction>> getTransactions() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('Transact', orderBy: 'name');
    return List.generate(maps.length, (i) {
      return model.Transaction(
        id_transaction: maps[i]['id_transaction'],
        expense: maps[i]['expense'],
        name: maps[i]['name'],
        total: maps[i]['total'],
        //date: maps[i]['date'],
        notes: maps[i]['notes'],
      );
    });
  }

  Future<void> addTransaction(model.Transaction transaction) async {
    Database db = await instance.database;
    await db.insert('Transact', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete( 'Transac', where: 'id_transaction = ?', whereArgs: [id]);
  }

  Future deleteLocalDB() async {
    Database db = await instance.database;
    await db.execute('''
      DELETE FROM Transact
      ''');
  }

  Future<bool> isEmpty() async {
    Database db = await instance.database;
    int count = db.query('''SELECT COUNT(*) FROM Transact''') as int;
    return count == 0;
  }
}
