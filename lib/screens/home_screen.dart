import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/models/models.dart';
import '../services/providers/providers.dart';
import '../services/repositories/common_repo.dart';
import '../services/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<ThemeProvider>(builder: (a, b, c) {
        return FloatingActionButton(
          onPressed: () => b.changeTheme(),
          child: Icon(
              b.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
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
                Consumer<DataProvider>(builder: (a, b, c) {
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
                          context.watch<DataProvider>().dropDownValue == 'Todos'
                              ? CommonRepository<TodoModel>(
                                  model: TodoModel(), uri: Config.todos)
                              : CommonRepository<AlbumModel>(
                                  model: AlbumModel(), uri: Config.albums)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
