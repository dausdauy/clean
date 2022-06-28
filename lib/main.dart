///This data resource from `https://jsonplaceholder.typicode.com/`
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        builder: (context, widget) {
          return MaterialApp(
            theme: context.watch<ThemeProvider>().isDark
                ? ThemeData.dark()
                : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              floatingActionButton: Consumer<ThemeProvider>(builder: (a, b, c) {
                return FloatingActionButton(
                  onPressed: () => b.changeTheme(),
                  child: Icon(b.isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded),
                );
              }),
              appBar: AppBar(
                title: const Text(
                  'Fetch data from jsonplaceholder.typicode.com',
                  style: TextStyle(fontSize: 14),
                ),
                centerTitle: true,
              ),
              body: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Consumer<MyProvider>(builder: (a, b, c) {
                          return DropdownButton(
                            value: b.dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: b.listDropDown.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text('List $items',
                                    style: const TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) =>
                                b.onChangeDropDown(newValue),
                          );
                        }),
                        Expanded(
                          child: MyListWidget(
                              dataRepository:
                                  context.watch<MyProvider>().dropDownValue ==
                                          'Todos'
                                      ? CommonRepository<TodoModel>(
                                          model: TodoModel(), uri: Config.todos)
                                      : CommonRepository<AlbumModel>(
                                          model: AlbumModel(),
                                          uri: Config.albums)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MyListWidget extends StatelessWidget {
  const MyListWidget({Key? key, required this.dataRepository})
      : super(key: key);

  final CommonRepository dataRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataRepository.getAll(),
      builder: (BuildContext c, AsyncSnapshot s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (s.hasError) {
          return Center(
            child: Text(
              'Ada yang error!!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          );
        } else if (s.data.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada data!!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          );
        }
        final sData = s.data! as List<BaseModel>;
        return ListView.builder(
          itemCount: sData.length,
          itemBuilder: (BuildContext c, int i) {
            final data = sData[i];
            return Card(
              child: ListTile(
                title: Text('${data.id}. ${data.title}'),
              ),
            );
          },
        );
      },
    );
  }
}

abstract class BaseModel {
  final int? id;
  final String? title;

  BaseModel({required this.id, required this.title});
  fromJson(Map<String, dynamic> json);
}

abstract class IRepository<T> {
  Future<List<T>> getAll();
}

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

class AlbumModel extends BaseModel {
  int? userId;
  int? idAlbum;
  String? titleAlbum;

  AlbumModel({
    this.userId,
    this.idAlbum,
    this.titleAlbum,
  }) : super(id: idAlbum, title: titleAlbum);

  @override
  BaseModel fromJson(Map<String, dynamic> json) => AlbumModel(
        userId: json["userId"],
        idAlbum: json["id"],
        titleAlbum: json["title"],
      );
}

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

class Config {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/';
  static const String todos = 'todos';
  static const String albums = 'albums';
}

class MyProvider with ChangeNotifier {
  String dropDownValue = 'Todos';
  List<String> listDropDown = ['Todos', 'Albums'];

  String? onChangeDropDown(String? newValue) {
    if (newValue == dropDownValue) {
      return null;
    } else {
      dropDownValue = newValue!;
    }
    notifyListeners();
    return dropDownValue;
  }
}

class ThemeProvider with ChangeNotifier {
  bool isDark = true;

  void changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
