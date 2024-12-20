import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class TaskModel {
  String description = "";
  bool completed = false;
  DateTime date = DateTime.now();
  int day = 0;
  bool notify = false;
  DateTime? notificationTime;
  bool fullDay = true;
  DateTime? taskTime;
  DateTime creationDate = DateTime.now();
  DateTime alterationDate = DateTime.now();
  String userId = '';

  TaskModel(
      {
        required this.description,
        required this.completed,
        required this.date,
        required this.day,
        required this.fullDay,
        this.taskTime,
        required this.notify,
        this.notificationTime,
        required this.userId
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    completed = json['completed'];
    date = (json['date'] as Timestamp).toDate();
    day = (json['day']);
    fullDay = json['fullDay'] ?? true;
    taskTime = json['taskTime'] != null
    ? (json['taskTime'] as Timestamp).toDate()
    : null;
    notify = json['notify'] ?? true;
    notificationTime = json['notificationTime'] != null
    ? (json['notificationTime'] as Timestamp).toDate()
    : null;
    creationDate =(json['creationDate'] as Timestamp).toDate();
    alterationDate =(json['alterationDate'] as Timestamp).toDate();
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['completed'] = this.completed;
    data['date'] = this.date;
    data['day'] = this.day;
    data['fullDay'] = this.fullDay;
    data['taskTime'] = this.taskTime;
    data['notify'] = this.notify;
    data['notificationTime'] = this.notificationTime;
    data['creationDate'] = Timestamp.fromDate(this.creationDate);
    data['alterationDate'] = Timestamp.fromDate(this.alterationDate);
    data['userId'] = this.userId;
    return data;
  }
}