abstract class BaseModel {
  final int? id;
  final String? title;

  BaseModel({required this.id, required this.title});
  fromJson(Map<String, dynamic> json);
}
