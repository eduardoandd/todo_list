import 'package:hive/hive.dart';
part 'todo_model.g.dart';


@HiveType(typeId: 1)
class ToDoModel extends HiveObject{

  ToDoModel();

  ToDoModel.create(this.description,this.completed);

  @HiveField(0)
  String? description = "";

  @HiveField(1)
  bool completed = false;

}