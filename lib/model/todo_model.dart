import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'todo_model.g.dart';


@HiveType(typeId: 1)
class ToDoModel extends HiveObject{

  ToDoModel();

  ToDoModel.create(this.description,this.completed,this.date, this.notify, this.notificationTime, this.TaskTime, this.taskHour);

  @HiveField(0)
  String? description = "";

  @HiveField(1)
  bool completed = false;

  @HiveField(2)
  DateTime date = DateTime.now();

  @HiveField(3)
  bool notify = false;

  @HiveField(4)
  TimeOfDay? notificationTime;


  @HiveField(5)
  bool TaskTime = false;

  @HiveField(6)
  TimeOfDay? taskHour; 


}