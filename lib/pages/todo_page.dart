import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/model/task_model.dart';
import 'package:todo_list/notifications/notification_helper.dart';
import 'package:todo_list/shared/widgets/alert_dialog_edit_widget.dart';
import 'package:todo_list/shared/widgets/alert_dialog_widget.dart';
import 'package:todo_list/shared/widgets/custom_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/shared/widgets/custom_appbar_widget.dart';
import '../shared/widgets/custom_drawer_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
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
  DateTime? taskTime;
  DateTime? notifyTime;
  String notifyOption = "";
  PageController _pageController = PageController(initialPage: 1);
  DateTime? taskTimeEdit;
  DateTime? notifyTimeEdit;
  String notifyOptionEdit = "";



  // Time? testeTaskTime;
  // Time? testeNotificationTime;
  

  final db = FirebaseFirestore.instance;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _initialized = true;
    loadUser();
  }

    void onSetTime(DateTime? selectedTaskTime, DateTime? selectedNotifyTime, String selectedNotifyOption) {
      taskTime = selectedTaskTime;
      notifyTime = selectedNotifyTime;
      notifyOption = selectedNotifyOption;

      print("Tarefa confirmada:");
      print("taskTime: $taskTime");
      print("notifyTime: $notifyTime");
      print("notifyOption: $notifyOption");
    }

    void onSetTimeEdit(DateTime? selectedTaskTimeEdit, DateTime? notifyTimeEdit_, String? optionEdit) {
      taskTimeEdit = selectedTaskTimeEdit;
      notifyTimeEdit = notifyTimeEdit_;
      notifyOptionEdit=optionEdit ?? "30 minutos antes";

    }

    

    void onConfirm(bool value) async{
      if(value == false){
        var task =TaskModel(
          description: descriptionController.text, 
          completed: false, 
          date: pickDate, 
          day: pickDate.day, 
          fullDay: value,
          taskTime: taskTime,
          notificationTime: notifyTime,
          notifyOption:notifyOption,
          notify: true, 
          userId: userId
        );
        await db.collection('tasks').add(task.toJson());
        // NotificationHelper.scheduledNotification(
        //       'Hoje às ${task.taskTime?.hour}${task.taskTime?.minute != null ? ":" + task.taskTime!.minute.toString().padLeft(2, '0') : ''}',
        //       '${task.description}',
        //       notifyTime!,
        //     );
        
      }
      else{
        var task =TaskModel(
          description: descriptionController.text, 
          completed: false, 
          date: pickDate, 
          day: pickDate.day, 
          fullDay: value,
          taskTime: null,
          notificationTime: null,
          notifyOption:notifyOption,
          notify: true, 
          userId: userId
        );
        await db.collection('tasks').add(task.toJson());
      }
    }

    

   

  loadUser() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(name: "LoadUserOpen");

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
    setState(() {});
  }

  void updateDate(bool nextDay) {
    setState(() {
      pickDate = pickDate.add(Duration(days: nextDay ? 1 : -1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                  return AlertDialogWidget(
                    title: 'Adicionar tarefa', 
                    description: descriptionController, 
                    onSetTime: onSetTime, pickdate: pickDate, onConfirm: onConfirm
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
                                    },
                                    key: Key(e.id),
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: task.completed
                                              ? (Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade800
                                                  : Colors.purple.shade50)
                                              : (Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade900
                                                  : Colors.white),
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
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black),
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
                                          },
                                          value: task.completed,
                                          activeColor: Colors.purple.shade500,
                                        ),
                                        onLongPress: () {
                                          descriptionController.text =
                                              task.description.toString();
                                          
                                          
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return task.taskTime != null || taskTimeEdit != null ?
                                                   AlertDialogEditWidget(
                                                    description: descriptionController,
                                                    taskTimeSelected: task.taskTime, 
                                                    onSetTime:onSetTimeEdit, 
                                                    optionNotify: task.notifyOption,
                                                    pickDate: pickDate, onConfirm: () async{ 
                                                      var taskEdit = TaskModel(
                                                        description: descriptionController.text, 
                                                        completed: false, 
                                                        date: pickDate, 
                                                        day: pickDate.day,
                                                        taskTime: taskTimeEdit, 
                                                        fullDay: false, 
                                                        notify: false, 
                                                        userId: task.userId
                                                      );
                                                      await db
                                                          .collection('tasks')
                                                          .doc(e.id)
                                                          .update(
                                                              taskEdit.toJson());
                                                     }
                                                  )
                                                  :
                                                  AlertDialogEditWidget(
                                                    description: descriptionController, pickDate: pickDate, onConfirm: () async { 
                                                      var taskEdit = TaskModel(
                                                        description: descriptionController.text, 
                                                        completed: false, 
                                                        date: pickDate, 
                                                        day: pickDate.day,
                                                        fullDay: false, 
                                                        notify: false, 
                                                        userId: task.userId
                                                      );
                                                      await db
                                                          .collection('tasks')
                                                          .doc(e.id)
                                                          .update(
                                                              taskEdit.toJson());
                                                     }, optionNotify: task.notifyOption,
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