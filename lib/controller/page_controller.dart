import 'package:flutter/material.dart';

class PageNumController with ChangeNotifier {
  int _pageNumber = 0;

  int get pagenumber => _pageNumber;

  void changePage(int pagenum) {
    _pageNumber = pagenum;
    notifyListeners();
  }
}
