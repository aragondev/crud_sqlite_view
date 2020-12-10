import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crud_sqlite/models/user.dart';

class DatabaseHelper{
  static const _databaseName = 'UserDatabase.db';
  static const _databaseVersion =1;


  //clase singleton
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database !=null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    //print(dbPath);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }


  Future _onCreateDB(Database db, int version) async {
    //create tables
    await db.execute('''
      CREATE TABLE ${User.tblUser}(
        ${User.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${User.colNombre} TEXT NOT NULL,
        ${User.colDireccion} TEXT NOT NULL,
        ${User.colTelefono} INTEGER NOT NULL
      )
      ''');
  }

 //insert user
  Future<int> insertUser(User user) async {
  Database db = await database;
  return await db.insert(User.tblUser, user.toMap());
  }

  Future<List<User>> fetchUsers() async{
  Database db = await database;
  List<Map> users = await db.query(User.tblUser);
  return users.length == 0
      ? []
      : users.map((x) => User.fromMap(x)).toList();
  }


}