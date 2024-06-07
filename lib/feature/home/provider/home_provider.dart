import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _filterSelect = 0;

  int get filterSelect => _filterSelect;

  void setFilter(int value) {
    _filterSelect = value;
    notifyListeners();
  }
}
