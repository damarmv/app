import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produksi.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poultry.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produksi(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            telur_bagus INTEGER,
            telur_rusak INTEGER,
            pakan_dipakai REAL,
            kematian INTEGER,
            catatan TEXT
          )
        ''');
      },
    );
  }

  // Insert data
  static Future<int> insertProduksi(Produksi produksi) async {
    final db = await database;
    return await db.insert('produksi', produksi.toMap());
  }

  // Ambil semua data
  static Future<List<Produksi>> getProduksi() async {
    final db = await database;
    final result = await db.query('produksi', orderBy: 'tanggal DESC');
    return result.map((e) => Produksi.fromMap(e)).toList();
  }

  // Hapus data
  static Future<int> deleteProduksi(int id) async {
    final db = await database;
    return await db.delete('produksi', where: 'id = ?', whereArgs: [id]);
  }
}
