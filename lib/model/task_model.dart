import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String description = "";
  bool completed = false;
  DateTime date = DateTime.now();
  bool? notify;
  DateTime? notificationTime;
  DateTime? taskTime;
  DateTime creationDate = DateTime.now();
  DateTime alterationDate = DateTime.now();
  String userId = '';

  TaskModel(
      {
        required this.description,
        required this.completed,
        required this.date,
        this.notify,
        this.notificationTime,
        this.taskTime,
        required this.userId
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
    creationDate =(json['creationDate'] as Timestamp).toDate();
    alterationDate =(json['alterationDate'] as Timestamp).toDate();
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['completed'] = this.completed;
    data['date'] = this.date;
    data['notify'] = this.notify;
    data['notificationTime'] = this.notificationTime;
    data['taskTime'] = this.taskTime;
    data['creationDate'] = Timestamp.fromDate(this.creationDate);
    data['alterationDate'] = Timestamp.fromDate(this.alterationDate);
    data['userId'] = this.userId;
    return data;
  }
}