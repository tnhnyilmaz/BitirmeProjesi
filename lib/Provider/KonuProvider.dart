import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  String _dailyTopic = "Günün Konusu Henüz Belirlenmedi!";

  String get dailyTopic => _dailyTopic;

  void setDailyTopic(String topic) {
    _dailyTopic = topic;
    notifyListeners();
  }
}
