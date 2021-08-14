// @dart=2.9
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../db/db_provider.dart';
import '../model/task_model.dart';


class updatethelist extends StatefulWidget {
  static String tag = 'updatethelist';
  @override
  _updatethelistState createState() => _updatethelistState();
}

class _updatethelistState extends State<updatethelist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showsnackbar(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(message),)
    );
  }
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController textUpdateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: idUpdateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'id',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: textUpdateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task',
                ),
              ),
            ),
            RaisedButton(
              child: Text('Update Details'),
              onPressed: () {
                int id = int.parse(idUpdateController.text);
                String text = textUpdateController.text;
                _update(id, text);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _update(id,task) async {
    Task newTask = Task(id: id,task: task);
    final tasks = await DBProvider.dataBase.update(newTask);
    return tasks;
  }
}