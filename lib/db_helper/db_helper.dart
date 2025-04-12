import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
   create table $tableName(
   $title text,
   $description text
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











}// end of the dbHelper