import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = true;

  void changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
