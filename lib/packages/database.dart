

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String table = "notification";
final String columnId = "_id";
final String columnType = "type";
final String columnAddress = "address";
final String columnDecription = "description";
final String columnDate = "date";
final String columnIsRead = "isread";

class NotData {

  int date ;
  int id ;
  String type ;
  String address ;
  String description ;
  int isRead ;

  NotData({this.date,this.type,this.address,this.description,this.isRead});

  NotData.fromMap(Map map){
    address = map[columnAddress] as String;
    type = map[columnType] as String ;
    description = map[columnDecription] as String ;
    date = map[columnDate] as int ;
    isRead = map[columnIsRead] as int ;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnType: type,
      columnAddress: address,
      columnDecription: description,
      columnDate : date,
      columnIsRead : isRead
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

}

class NotificationProvider {

  Database db;
  String path ;

  NotificationProvider(String dbName){
     init(dbName);
  }

  init(String dbName)async{
    String databasePath = await getDatabasesPath();
    this.path = join(databasePath,dbName);
    this.db = await open(this.path);
  }

  Future open(String path) async {
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $table (
            $columnId integer primary key autoincrement,
            $columnType text not null,
            $columnAddress text not null,
            $columnDecription text not null,
            $columnDate text not null,
            $columnIsRead integer not null)
          ''');
    });
    return db ;
  }

  Future<NotData> insert(NotData data) async {
    data.id = await this.db.insert(table, data.toMap());
    print("Inserting database . . . .");
    return data;
  }

  Future<NotData> getNotData(int id) async {
    List<Map> maps = await db.query(table,
        columns: [columnId, columnType, columnAddress,columnDecription,columnDate,columnIsRead],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return NotData.fromMap(maps.first);
    }
    return null;
  }
  Future<List<NotData>> getAll()async{
    List<Map> maps = await db.query(table, columns: [columnId, columnType, columnAddress,columnDecription,columnDate,columnIsRead]);
    print("Database -----------------------------------: "+maps.toString());
    List<NotData> data = new List<NotData>();
    maps.forEach((map){
       data.add(NotData.fromMap(map));
    });
    return data;
  }

  Future<int> delete(int id) async {
    print("Deleting database . . . .");
    return await db.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(NotData todo) async {
    print("Updating database . . . .");
    return await db.update(table, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();

}
