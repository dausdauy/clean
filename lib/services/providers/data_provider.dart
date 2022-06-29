import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
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