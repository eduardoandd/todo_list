// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:hive/hive.dart';
import 'package:todo_list/model/todo_model.dart';

class TodoRepository {

  static late Box _box;

  TodoRepository._create();
  

  static Future<TodoRepository> loadData() async {
    // await Hive.deleteBoxFromDisk('todoModel');
    if(Hive.isBoxOpen('todoModel')){
      _box = Hive.box('todoModel');
    }
    else{
      _box = await Hive.openBox('todoModel');
    }
    return TodoRepository._create();
  } 

  List<ToDoModel> get(bool justNotCompleted, DateTime date){
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    if(justNotCompleted){
      return _box.values.cast<ToDoModel>().where(
        (element) => !element.completed && 
         DateTime(element.date.year, element.date.month, element.date.day) == normalizedDate,
      ).toList();
    }
    else{
      return _box.values.cast<ToDoModel>().where(
        (element) => DateTime(element.date.year, element.date.month, element.date.day) == normalizedDate,
      ).toList();
    }
  }

  update(ToDoModel model){
    model.save();
  }

  delete(ToDoModel model){
    model.delete();
  }

  saveData(ToDoModel model) {
    _box.add(model);
  }



}