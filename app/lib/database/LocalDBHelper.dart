import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:es/model/transaction.dart' as model;

class LocalDBHelper {
  LocalDBHelper._privateConstructor();
  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
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

    final List<Map<String, dynamic>> maps = await db.query('Transact');
    return List.generate(maps.length, (i) {
      return model.Transaction(
        id_transaction: maps[i]['id_transaction'],
        name: maps[i]['name'],
        total: maps[i]['total'],
        //date: maps[i]['date'],
        notes: maps[i]['notes'],
      );
    });
  }

  Future<void> add_transaction(model.Transaction transaction) async {
    Database db = await instance.database;
    await db.insert('Transact', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
