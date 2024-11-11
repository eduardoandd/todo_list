// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/widgets/custom_alert_dialog.dart';

import '../model/todo_model.dart';
import '../repositories/todo_repositories.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoRepository todoRepository;
  var _tasks = <ToDoModel>[];
  var descriptionController = TextEditingController();
  bool justNotCompleted = true;
  DateTime pickDate = DateTime.now(); // Inicia com a data atual
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  bool _initialized = false; 
  bool notification = false;
  TimeOfDay? notificationTime;
  bool taskTime = false;
  TimeOfDay? taskHour;
  bool watchIcon = false;

  PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    getTasks();
    _initialized = true; 
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

  String formatTimeOfNotification(TimeOfDay? time) {
    if (time == null) return "Notificação"; // Retorna uma string vazia caso o timeNotification seja nulo
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String formatTimeOfTask(TimeOfDay? time) {
    if (time == null) return ""; // Retorna uma string vazia caso o timeNotification seja nulo
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            dateFormat.format(pickDate),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: pickDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  pickDate = selectedDate;
                });
                getTasks();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          descriptionController.text = "";
          notificationTime = null;
          notification = false;
          taskTime = false;
          showDialog(
            context: context,
            builder: (BuildContext bc) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return CustomAlertDialog(
                  title: "Adicionar tarefa",
                  controller: descriptionController,
                  icon: notification ? 
                  Icons.notifications : 
                  Icons.notifications_off,

                  onIconPressed: () async {
                    setState(() {
                      notification = !notification;
                    });
                    if (notification){
                      final pickedTime = await showTimePicker(
                        context: context, 
                        initialTime: TimeOfDay.now()
                      );

                      if (pickedTime !=null) {
                        setState(() {
                          notificationTime = pickedTime;
                          // print(timeNotification);
                        });
                      }
                    }
                  },
                  timeNotification: formatTimeOfNotification(notificationTime),

                  icon2: taskTime ?  
                  Icons.access_time : 
                  Icons.access_time_filled,
                  onIconPressed2: () async{
                    setState (() {
                      taskTime = !taskTime;
                      watchIcon = !watchIcon;
                    });
                    if (taskTime){
                      final pickedTaskTime = await showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now()
                      );
                      if (pickedTaskTime != null){
                        setState((){
                          taskHour = pickedTaskTime;
                        });
                      }
                    }
                  },
                  timeTask: formatTimeOfTask(taskHour),
                  visible:  watchIcon ? true : false,
                  onConfirm: () async {
                      await todoRepository.saveData(
                        ToDoModel.create(descriptionController.text, false, pickDate,notification,notificationTime, taskTime, taskHour ),
                      );
                      getTasks();
                  },
                  confirmText: "Salvar",
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
                        style: TextStyle(fontSize: 18),
                      ),
                      Switch(
                        value: justNotCompleted,
                        onChanged: (bool value) async {
                          justNotCompleted = value;
                          getTasks();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var task = _tasks[index];
                      return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          todoRepository.delete(task);
                          getTasks();
                        },
                        key: Key(task.key.toString()),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(task.description.toString()),
                            ],
                          ),
                          trailing: Switch(
                            onChanged: (bool value) async {
                              task.completed = value;
                              todoRepository.update(task);
                              getTasks();
                            },
                            value: task.completed,
                          ),
                          onLongPress: () {
                            descriptionController.text = task.description.toString();
                            showDialog(
                              context: context,
                              builder: (BuildContext bc) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return CustomAlertDialog(
                                      title: "Editar tarefa",
                                      controller: descriptionController,
                                      icon: notification ? 
                                      Icons.notifications : 
                                      Icons.notifications_off,

                                      onIconPressed: () async {
                                        setState(() {
                                          notification = !notification;
                                        });

                                        if (notification){
                                          final pickedTime = await showTimePicker(
                                            context: context, 
                                            initialTime: TimeOfDay.now()
                                          );

                                          if (pickedTime !=null) {
                                            setState(() {
                                            notificationTime = pickedTime;
                                            });
                                          }
                                        }
                                      },
                                      timeNotification: formatTimeOfNotification(notificationTime),

                                      icon2: taskTime ?  
                                      Icons.access_time : 
                                      Icons.access_time_filled,
                                      onIconPressed2: () async{
                                        setState (() {
                                          taskTime = !taskTime;
                                          watchIcon = !watchIcon;
                                        });
                                        if (taskTime){
                                          final pickedTaskTime = await showTimePicker(
                                              context: context, 
                                              initialTime: TimeOfDay.now()
                                          );
                                          if (pickedTaskTime != null){
                                            setState((){
                                              taskHour = pickedTaskTime;
                                            });
                                          }
                                        }
                                      },
                                      timeTask: formatTimeOfTask(taskHour),
                                      visible:  watchIcon ? true : false,

                                      onConfirm: () async {
                                        await todoRepository.saveData(
                                          ToDoModel.create(descriptionController.text, false, pickDate,notification,notificationTime, taskTime, taskHour ),
                                        );
                                        getTasks();
                                      },
                                      confirmText: "Salvar",
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
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
