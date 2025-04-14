import 'package:flutter/material.dart';
import 'package:sqlite_database_batch40/db_helper/db_helper.dart';
import 'package:sqlite_database_batch40/user_model/user-model.dart';

class SqliteHomeScreen extends StatefulWidget {
  const SqliteHomeScreen({super.key});

  @override
  State<SqliteHomeScreen> createState() => _SqliteHomeScreenState();
}

class _SqliteHomeScreenState extends State<SqliteHomeScreen> {
  // add
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // update
  final updateTitleController = TextEditingController();
  final updateDescriptionController = TextEditingController();



  // local list
  List<Map<String,dynamic>> list = [];
  final db = DbHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  // dialog

  Future<void> updateDialog(BuildContext context,UserModel userModel){
    updateTitleController.text = userModel.title;
    updateDescriptionController.text = userModel.description;
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Update Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller:updateTitleController,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller:updateDescriptionController,
              decoration: InputDecoration(
                  hintText: 'Description'
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            updateData(userModel.id!);
            Navigator.pop(context);
            updateTitleController.clear();
            updateDescriptionController.clear();
          }, child: Text('Save')),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('NO'))
        ],
      );
    });
  }


  // add
  void add()async{
    await db.createData(UserModel(title: titleController.text, description: descriptionController.text,));
    fetch();
  }

  // fetch

  void fetch()async{
   List<Map<String,dynamic>> data = await db.readData();
   setState(() {
     list = data;
   });
  }

  // update

  void updateData(int id)async{
    await db.updateData(UserModel(title: updateTitleController.text, description: updateDescriptionController.text,id: id));
    fetch();
  }


  // delete

  void delete(int id)async{
    await db.delete(id);
    fetch();
  }


  // deleteALL

  void deleteAll()async{
    await db.deleteAll();
    fetch();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                deleteAll();
              },
                child: Text('Clear',style: TextStyle(fontSize: 18,color: Colors.white),)),
          )
        ],
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
                titleController.clear();
                descriptionController.clear();
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

            if (list.isEmpty) Center(child: Text('No data available')) else Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(list[index]['title']),
                      subtitle: Text(list[index]['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap : (){
                        updateDialog(context, UserModel(
                            id: list[index]['id'],
                            title:list[index]['title'],
                            description: list[index]['description'],))  ;
                    },
                              child: Icon(Icons.edit,color: Colors.blue,)),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap : (){
                        delete(list[index]['id']);
                    },
                              child: Icon(Icons.delete_forever,color: Colors.red,)),

                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
