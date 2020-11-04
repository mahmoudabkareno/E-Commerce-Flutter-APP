import 'package:flutter/cupertino.dart';

class AdminMode extends ChangeNotifier{
  bool isAdmin = false;
  changeIsAdmin(bool v){
    isAdmin = v;
    notifyListeners();
  }
}