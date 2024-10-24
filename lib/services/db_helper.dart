import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "aquarium.db";
  static final _databaseVersion = 1;
  static final tableSettings = 'settings';

  // Column names
  static final columnId = 'id';
  static final columnFishCount = 'fishCount';
  static final columnFishSpeed = 'fishSpeed';
  static final columnFishColor = 'fishColor';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSettings (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFishCount INTEGER NOT NULL,
        $columnFishSpeed REAL NOT NULL,
        $columnFishColor TEXT NOT NULL
      )
    ''');
  }

  // Insert or update settings
  Future<void> saveSettings(int fishCount, double fishSpeed, String fishColor) async {
    Database db = await instance.database;
    await db.insert(
      tableSettings,
      {
        columnFishCount: fishCount,
        columnFishSpeed: fishSpeed,
        columnFishColor: fishColor,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve settings
  Future<Map<String, dynamic>?> getSettings() async {
    Database db = await instance.database;
    final result = await db.query(tableSettings, limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
