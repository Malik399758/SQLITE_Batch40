import 'package:flutter/material.dart';
import 'package:sqlite_database_batch40/db_helper/db_helper.dart';
import 'package:sqlite_database_batch40/user_model/user-model.dart';

class SqliteHomeScreen extends StatefulWidget {
  const SqliteHomeScreen({super.key});

  @override
  State<SqliteHomeScreen> createState() => _SqliteHomeScreenState();
}

class _SqliteHomeScreenState extends State<SqliteHomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // local list
  List<Map<String,dynamic>> list = [];
  final db = DbHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }


  // add
  void add()async{
    await db.createData(UserModel(title: titleController.text, description: descriptionController.text));
    fetch();
  }

  // fetch

  void fetch()async{
   List<Map<String,dynamic>> data = await db.readData();
   setState(() {
     list = data;
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title'
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: 'Description'
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                add();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue
                ),
                child: Center(child: Text('ADD',style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(height: 10,),
            Divider(),

            list.isEmpty ? Center(child: Text('No data available'))  :
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(list[index]['title']),
                      subtitle: Text(list[index]['description']),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
