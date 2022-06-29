import 'base_model.dart';

class TodoModel extends BaseModel {
  int? userId;
  int? idTodo;
  String? titleTodo;
  bool? completed;

  TodoModel({
    this.userId,
    this.completed,
    this.idTodo,
    this.titleTodo,
  }) : super(id: idTodo, title: titleTodo);

  @override
  BaseModel fromJson(Map<String, dynamic> json) => TodoModel(
        userId: json["userId"],
        idTodo: json["id"],
        titleTodo: json["title"],
        completed: json["completed"],
      );
}
