import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String description = "";
  bool completed = false;
  DateTime date = DateTime.now();
  bool? notify;
  DateTime? notificationTime;
  DateTime? taskTime;

  TaskModel(
      {
        required this.description,
        required this.completed,
        required this.date,
        this.notify,
        this.notificationTime,
        this.taskTime
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    completed = json['completed'];
    date = (json['date'] as Timestamp).toDate();
    notify = json['notify'];
    notificationTime = json['notificationTime'] != null
    ? (json['notificationTime'] as Timestamp).toDate()
    : null;
    taskTime = json['taskTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['completed'] = this.completed;
    data['date'] = this.date;
    data['notify'] = this.notify;
    data['notificationTime'] = this.notificationTime;
    data['taskTime'] = this.taskTime;
    return data;
  }
}