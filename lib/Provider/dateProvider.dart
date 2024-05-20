import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateProvider extends ChangeNotifier {
  String? _selectedDate;

  String? get selectedDate => _selectedDate;

  void setDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> saveSelectedDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDate', date);
  }

  Future<void> loadSelectedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedDate = prefs.getString('selectedDate');
    notifyListeners();
  }
}
