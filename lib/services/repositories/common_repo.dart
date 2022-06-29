import '../models/models.dart';
import '../shared.dart';
import 'impl_repo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommonRepository<T extends BaseModel> implements IRepository<T> {
  /// Generic Model from `BaseModel`
  T model;

  /// Endpoint api
  String uri;

  CommonRepository({required this.model, required this.uri});

  @override
  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse(Config.baseUrl + uri));

    return jsonDecode(response.body)
        .map<T>((x) => model.fromJson(x) as T)
        .toList();
  }
}
