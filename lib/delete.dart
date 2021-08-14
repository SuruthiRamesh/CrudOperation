// @dart=2.9
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../db/db_provider.dart';
import '../model/task_model.dart';


class deletethelist extends StatefulWidget {
  static String tag = 'deletethelist';
  const deletethelist({Key key}) : super(key: key);

  @override
  _deletethelistState createState() => _deletethelistState();
}

class _deletethelistState extends State<deletethelist> {
  @override
  TextEditingController idDeleteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: <Widget>[
        Container(
        padding: EdgeInsets.all(20),
        child: TextField(
          controller: idDeleteController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'id',
          ),
        ),
      ),
      RaisedButton(
        child: Text('Delete'),
        onPressed: () {
          int id = int.parse(idDeleteController.text);
          _delete(id);
        },
      ),
    ]
    )
      )
    );
  }
  void _delete(id) async {
    final tasks = await DBProvider.dataBase.delete(id);
    return tasks;
  }
}

