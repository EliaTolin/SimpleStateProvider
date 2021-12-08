import 'package:flutter/material.dart';

class NumberModel extends ChangeNotifier {
  int num = 0;
  void add() {
    num++;
    notifyListeners();
  }

  void initizialize() {
    num = 0;
    notifyListeners();
  }

  void setNum(int n) {
    num = n;
    notifyListeners();
  }
}
