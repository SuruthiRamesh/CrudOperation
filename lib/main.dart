// @dart=2.9
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/delete.dart';
import '../db/db_provider.dart';
import '../model/task_model.dart';
import 'update.dart';



void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  final routes = {
    updatethelist.tag:(context) => updatethelist(),
    deletethelist.tag:(context) => deletethelist()
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTodoApp(),
      routes: routes,
    );
  }
}
class MyTodoApp extends StatefulWidget {
  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController textUpdateController = TextEditingController();
  //controllers used in delete operation UI
  TextEditingController idDeleteController = TextEditingController();
  dialogshow(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Update or Delete entry in the list"),
        content: Text("Would you like to update or delete any entry in the list"),
        actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pushNamed(deletethelist.tag);
          }, child: Text("Delete")),
          FlatButton(onPressed: (){
            Navigator.of(context).pushNamed(updatethelist.tag);
          }, child: Text('Update')),
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Cancel'))
        ],
      );
    });
  }
  Color mainColor = Colors.cyan;
  Color secondColor = Color(0xFF212061);
  Color btnColor = Color(0xFFff955b);
  Color editorColor = Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  getTasks() async{
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainColor,
        title: Text(" Today's Schedule!!"),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTasks(),
              builder: (_, taskData){
                switch (taskData.connectionState){
                  case ConnectionState.waiting:
                    {
                      return Center(child: CircularProgressIndicator());
                    }
                  case ConnectionState.done:
                    {
                      if(taskData.data !=Null){
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: taskData?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              String task = taskData.data[index]['task'].toString();
                              String day = DateTime.parse(taskData.data[index]['creationDate']).day.toString();
                              return Card(
                                  child: InkWell(
                                onTap: (){},
                                child: Row(
                                  children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 12.0),
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(day, style: TextStyle(color: Colors.white,fontSize: 25.0,fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(child: Text(task,style: TextStyle(color: Colors.white,fontSize: 16.0),),),
                                  ),

                                ],),
                              ),color: secondColor);
                            },
                          ),
                        );
                      }
                      else{
                        return Center(
                          child: Text("You have no Task today",
                          style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                    }
                }
            },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            decoration: BoxDecoration(
              color: editorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type a new Task",

                    ),
                  ),
                ),
                SizedBox(width: 15.0,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Add Task"),
                  color: btnColor,
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                    onPressed: (){
                    setState(() {
                      newTaskTxt = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask = Task(task: newTaskTxt,dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                    }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

