
import 'package:flutter/cupertino.dart';

class ModelHub extends ChangeNotifier{
  bool isLoading = false;
  changIsLoading(bool v){
    isLoading = v;
    notifyListeners();
  }
}