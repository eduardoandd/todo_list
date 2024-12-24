import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/notifications/notification_helper.dart';
import 'package:todo_list/shared/widgets/custom_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/shared/widgets/custom_appbar_widget.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import '../model/todo_model.dart';
import '../repositories/todo_repositories.dart';
import '../shared/widgets/custom_drawer_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoRepository todoRepository;
  var _tasks = <ToDoModel>[];
  var descriptionController = TextEditingController();
  bool justNotCompleted = false;
  DateTime pickDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  bool _initialized = false;
  bool notify = false;
  DateTime? notificationTime;
  bool fullDay = true;
  bool watchIcon = false;
  bool borderIsVisible = false;
  DateTime taskTime = DateTime.now();
  DateTime notifyTime = DateTime.now();

  PageController _pageController = PageController(initialPage: 1);

  final db = FirebaseFirestore.instance;
  String userId = '';

  @override
  void initState() {
    super.initState();
    getTasks();
    _initialized = true;

    loadUser();
  }

  loadUser() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(name: "LoadUserOpen");

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
    setState(() {});
  }

  void getTasks() async {
    todoRepository = await TodoRepository.loadData();
    _tasks = todoRepository.get(justNotCompleted, pickDate);
    setState(() {});
  }

  void updateDate(bool nextDay) {
    setState(() {
      pickDate = pickDate.add(Duration(days: nextDay ? 1 : -1));
    });
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        pickDate: pickDate,
        onDateSelected: (selectedDate) {
          setState(() {
            pickDate = selectedDate;
          });
        },
      ),
      drawer: CustomDrawerWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade600,
        child: const Icon(Icons.add),
        onPressed: () async {
          descriptionController.text = "";
          notificationTime = null;
          notify = false;
          fullDay = true;
          watchIcon = false;
          borderIsVisible = false;
          showDialog(
            context: context,
            builder: (BuildContext bc) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return CustomAlertDialog(
                    title: "Adicionar tarefa",
                    controller: descriptionController,
                    onConfirm: () async {
                      var task = TaskModel(
                          description: descriptionController.text,
                          completed: false,
                          date: pickDate,
                          userId: userId,
                          taskTime: taskTime,
                          notificationTime:notificationTime ,
                          day: pickDate.day,
                          fullDay: fullDay,
                          notify: notify);
                      await db.collection('tasks').add(task.toJson());
                      getTasks();
                      NotificationHelper.scheduledNotification(
                          'Hoje às ${task.taskTime?.hour}${task.taskTime?.minute != null ? ":" + task.taskTime!.minute.toString().padLeft(2, '0') : ''}',
                          '${task.description}', 
                          notificationTime!
                        );
                    },
                    confirmText: "Salvar",
                    fullDay: fullDay,
                    notify: notify,
                    onfullDayChanged: (value) {
                      setState(() {
                        fullDay = value;
                      });
                    },
                    onTaskTimeChanged: (value) {
                      setState(() {
                        taskTime = DateTime(pickDate.year, pickDate.month,
                            pickDate.day, value.hour, value.minute);
                      });
                    },
                    onNotifyTimeChanged: (value) {
                      var hour = taskTime.hour - value.hour;
                      var minute = taskTime.minute - value.minute;
                      notificationTime = DateTime(pickDate.year, pickDate.month,
                          pickDate.day, hour, minute);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_initialized) {
            if (index == 0) {
              updateDate(false);
            } else if (index == 2) {
              updateDate(true);
            }
            _pageController.jumpToPage(1);
          }
        },
        children: [
          Center(child: Text("Dia anterior")),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Apenas não concluídos",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        value: justNotCompleted,
                        onChanged: (bool value) async {
                          justNotCompleted = value;
                          getTasks();
                        },
                        activeColor: Colors.purple.shade600,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: justNotCompleted
                          ? db
                              .collection('tasks')
                              .where('completed', isEqualTo: false)
                              .where('userId', isEqualTo: userId)
                              .where('day', isEqualTo: pickDate.day)
                              .snapshots()
                          : db
                              .collection("tasks")
                              .where('userId', isEqualTo: userId)
                              .where('day', isEqualTo: pickDate.day)
                              .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(child: CircularProgressIndicator())
                            : ListView(
                                children: snapshot.data!.docs.map((e) {
                                  var task = TaskModel.fromJson(
                                      (e.data() as Map<String, dynamic>));
                                  return Dismissible(
                                    onDismissed: (DismissDirection
                                        dismissDirection) async {
                                      await db
                                          .collection('tasks')
                                          .doc(e.id)
                                          .delete();
                                      getTasks();
                                    },
                                    key: Key(e.id),
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      // padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: task.completed
                                              ? Colors.purple.shade50
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3))
                                          ]),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                task.description.toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  // decoration:  task.completed ? TextDecoration.lineThrough : TextDecoration.none
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Switch(
                                          onChanged: (bool value) async {
                                            task.completed = value;
                                            await db
                                                .collection("tasks")
                                                .doc(e.id)
                                                .update(task.toJson());
                                            getTasks();
                                          },
                                          value: task.completed,
                                          activeColor: Colors.purple.shade500,
                                        ),
                                        onLongPress: () {
                                          descriptionController.text =
                                              task.description.toString();
                                          notificationTime =
                                              task.notificationTime;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return CustomAlertDialog(
                                                    title: "Editar tarefa",
                                                    controller:
                                                        descriptionController,
                                                    onConfirm: () async {
                                                      task.description =
                                                          descriptionController
                                                              .text;
                                                      await db
                                                          .collection('tasks')
                                                          .doc(e.id)
                                                          .update(
                                                              task.toJson());
                                                      getTasks();
                                                    },
                                                    confirmText: "Salvar",
                                                    fullDay: fullDay,
                                                    notify: notify,
                                                    onfullDayChanged:
                                                        (bool value) {
                                                      setState(() {
                                                        fullDay = value;
                                                      });
                                                    },
                                                    onTaskTimeChanged: (value) {
                                                      taskTime = DateTime(
                                                          pickDate.year,
                                                          pickDate.month,
                                                          pickDate.day,
                                                          value.hour,
                                                          value.minute);
                                                    },
                                                    onNotifyTimeChanged:
                                                        (value) {
                                                      taskTime = DateTime(
                                                          pickDate.year,
                                                          pickDate.month,
                                                          pickDate.day,
                                                          value.hour,
                                                          value.minute);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(child: Text("Próximo dia")),
        ],
      ),
    );
  }
}
