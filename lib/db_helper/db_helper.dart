import 'dart:core';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_database_batch40/user_model/user-model.dart';

// Global variable

final String tableName = 'Batch';
final String title = 'title';
final String description = 'description';


class DbHelper{

  // Singleton pattern for instance

  // private constructor

  DbHelper._();

  // create an instance

 static DbHelper? instance;

 factory DbHelper(){
   if(instance == null){
     instance = DbHelper._();
   }
   return instance!;
 }


 // singleton pattern for database
 Database? _database;

 // if the database exists then return get function

 Future<Database?> get database async{
   if(_database == null){
     _database = await create();
   }
   return _database;
 }

 Future<Database> create() async{
   var openDb;
   try{
     String createTable = (
         '''
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    $title TEXT,
    $description TEXT
  )
  '''
     );

     var openAccess = await getDatabasesPath();
     var path = join(openAccess,'batch40.db');

     openDb = openDatabase(path,version: 1,onCreate: (Database db,int version){
       db.execute(createTable);
     });
   }
   catch(e){
     print('Created table error ------------->$e');
   }
   return openDb;

  }

  // Crud operation


 // create

 Future<int> createData(UserModel userModel)async{
   try{
     final db = await database;
     await db!.insert(tableName, userModel.toMap());
     print('Data inserted ');
     return 1;
   }catch(e){
     print('Data created error ------->$e');
     return 0;
   }
 }


 // Read

 Future<List<Map<String,dynamic>>> readData()async{
   final db = await database;
   return db!.query(tableName);
 }


 // update

Future<int> updateData(UserModel userModel)async{
   final db = await database;
   return db!.update(tableName,userModel.toMap(),where: 'id = ?',whereArgs: [userModel.id] );
}

// delete

 Future<int> delete(int id)async{
   final db = await database;
   return db!.delete(tableName,where: 'id = ?',whereArgs: [id]);
 }


 // deleteAll
Future<int> deleteAll()async{
   final db = await database;
   return db!.delete(tableName);
}

















}// end of the dbHelper
