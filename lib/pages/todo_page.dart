// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_conditional_assignment

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../model/todo_model.dart';
import '../repositories/todo_repositories.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);


  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  late TodoRepository todoRepository;
  var _tasks = <ToDoModel> [];

  var descriptionController = TextEditingController();
  bool justNotCompleted = true;
  // late DateTime today;
  String formattedDate = '';
  DateTime? pickDate =DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');



  @override
  void initState() {
    super.initState();
    // today = DateTime(2024, 11, 7);
    // formattedDate = dateFormat.format(today);
    // print(formattedDate);
    
    getTasks();
  }

  void getTasks() async {
    todoRepository = await TodoRepository.loadData();

    _tasks = todoRepository.get(justNotCompleted, pickDate!);

    setState(() {});
  }

  // void updateDate(bool nextDay){
  //   print(nextDay);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: pickDate == null 
          ? Text(
            dateFormat.format(DateTime.now())
          )
          : Text(
            dateFormat.format(pickDate!)
          )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async{
              pickDate = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime.now(), 
                lastDate: DateTime(2100)
              );
              setState(() {  });
              getTasks();
            }, 
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          descriptionController.text = "";
          showDialog(
            context: context, 
            builder: (BuildContext bc) {
              return AlertDialog(
                title: Text("Adicionar tarefa"),
                content: TextField(
                  controller: descriptionController,
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text("Cancelar")
                  ),
                  TextButton(
                    onPressed: () async {
                      await todoRepository.saveData(
                        ToDoModel.create(descriptionController.text, false, pickDate!)
                      );
                      Navigator.pop(context);
                      getTasks();
                      // setState(() {});

                    }, 
                    child: Text("Salvar")
                  )
                ],
              );
            }
          );
        },
      ),

      body: PageView(
        onPageChanged: (index){
          // updateDate(index > 0);
        },
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Apenas não concluidos", style: TextStyle(fontSize: 18),),
                      Switch(
                        value: justNotCompleted, 
                        onChanged: (bool value) async {
                          justNotCompleted=value;
                          // print(value);
                          print(justNotCompleted);
                          // todoRepository.update(task);
                          getTasks();
                        }

                      )
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
                          title: Text(task.description.toString()),
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
                              builder: (BuildContext bc){
                                return AlertDialog(
                                  title:Text("Editar tarefa"),
                                  content: TextField(
                                    controller: descriptionController,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: Text("Cancelar")
                                    ),
                                    TextButton(
                                      onPressed: () async{
                                        task.description=descriptionController.text;
                                        await todoRepository.update(task);
                                        Navigator.pop(context);
                                        getTasks();
                                      }, 
                                      child: Text("Editar")
                                    )
                                  ],
                                );
                              }
                            );

                          },
                        )
                      );

                      
                    }
                  ),
                )
              ]
            ),

          ),
        ],
      ),

   


    );
  }
}