import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voter_finder/data/model/area_model.dart';
import 'package:voter_finder/data/model/area_wise_model.dart';
import 'package:voter_finder/data/model/centre_wise_model.dart';
import 'package:voter_finder/data/model/info_model.dart';
import 'package:voter_finder/data/model/word_model.dart';

import '../model/votar_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'voter_info2.db');

    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load(join('assets', 'election.db'));
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createVoterTable(db);
    await _createWordTable(db);
    await _createAreaTable(db);
    await _createDashInfoTable(db);
    await _createAreaWiseTable(db);
    await _createCenterTable(db);
  }

  Future<void> _createVoterTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS voter_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        info TEXT,
        gender TEXT,
        ward_name TEXT,
        voter_area_name TEXT,
        voter_area_no TEXT,
        center_name TEXT
      )
    ''');
    await _createIndex(db, 'voter_data', 'info');
    await _createIndex(db, 'voter_data', 'gender');
    await _createIndex(db, 'voter_data', 'ward_name');
    await _createIndex(db, 'voter_data', 'voter_area_name');
  }

  Future<void> _createWordTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS word (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await _createIndex(db, 'word', 'name');
  }

  Future<void> _createAreaTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS area (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER,
        ward_name TEXT,
        name TEXT,
        code TEXT,
        code_bn TEXT
      )
    ''');
    await _createIndex(db, 'area', 'word_id');
  }

  Future<void> _createDashInfoTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dash_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_voters TEXT,
        total_voters_with_migrate TEXT,
        total_centers TEXT
      )
    ''');
  }

  Future<void> _createAreaWiseTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS voters_by_area (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        male_voters TEXT,
        female_voters TEXT
      )
    ''');
  }

  Future<void> _createCenterTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS voters_by_center (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        start_from TEXT,
        end_to TEXT
      )
    ''');
  }

  Future<void> _createIndex(Database db, String tableName, String columnName) async {
    await db.execute('CREATE INDEX idx_$columnName ON $tableName($columnName);');
  }

  Future<List<DashInfoModel>> getAllInfoData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('dash_info');
    return List.generate(maps.length, (i) {
      return DashInfoModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<AreaWiseDataModel>> getAllAreaWiseData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('voters_by_area');
    return List.generate(maps.length, (i) {
      return AreaWiseDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<CenterWiseDataModel>> getAllCenterWiseData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('voters_by_center');
    return List.generate(maps.length, (i) {
      return CenterWiseDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<WordDataModel>> getWordData({int limit = 100, int offset = 0}) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'word',
      limit: limit,
      offset: offset,
    );
    return List.generate(maps.length, (i) {
      return WordDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<AreaDataModel>> getAllAreaData({int limit = 100, int offset = 0}) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'area',
      limit: limit,
      offset: offset,
    );
    return List.generate(maps.length, (i) {
      return AreaDataModel.fromMap(maps[i] ?? {});
    });
  }


  Future<List<VotarDataModel>> getNameWiseData(String name, String gender, String word, String area) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voter_data',
      where: 'info LIKE ? AND gender = ? AND ward_name = ? AND voter_area_name = ?',
      whereArgs: [name.length >= 2 ? '${name.substring(0, 2)}%' : name, gender, word, area],
    );
    return List.generate(maps.length, (i) {
      return VotarDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<VotarDataModel>> getSerialWiseData(String serial, String gender, String word, String area) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voter_data',
      where: 'info LIKE ? AND gender = ? AND ward_name = ? AND voter_area_name = ?',
      whereArgs: [serial.length >=2 ? '${serial.substring(0, 2)}%' : serial, gender, word, area],
    );
    return List.generate(maps.length, (i) {
      return VotarDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<VotarDataModel>> getDateWiseData(String date, String gender, String word, String area) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voter_data',
      where: 'info LIKE ? AND gender = ? AND ward_name = ? AND voter_area_name = ?',
      whereArgs: ['%$date%', gender, word, area],
    );
    return List.generate(maps.length, (i) {
      return VotarDataModel.fromMap(maps[i] ?? {});
    });
  }

  Future<List<VotarDataModel>> getHoldingWiseData(String holding, String gender, String word, String area) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voter_data',
      where: 'info LIKE ? AND gender = ? AND ward_name = ? AND voter_area_name = ?',
      whereArgs: [holding.length >= 2? '${holding.substring(0, 2)}%' : holding, gender, word, area],
    );
    return List.generate(maps.length, (i) {
      return VotarDataModel.fromMap(maps[i] ?? {});
    });
  }
}
