import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _keyColor = 'primary_color_value';

  Color _primaryColor = Colors.lightBlue; // 初期色（好きな色でOK）

  Color get primaryColor => _primaryColor;

  ThemeData get themeData => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
    useMaterial3: true,
  );

  ///アプリ起動時にSharedPreferencesから色を読む
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_keyColor);
    if (value != null) {
      _primaryColor = Color(value);
      notifyListeners();
    }
  }

  //ユーザーが色を変えたとき呼ぶ
  Future<void> changeColor(Color color) async {
    _primaryColor = color;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    await prefs.setInt(_keyColor, color.value);
  }
}
