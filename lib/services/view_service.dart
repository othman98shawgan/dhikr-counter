import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'store_manager.dart';

class ViewNotifier with ChangeNotifier {
  bool _showTotalView = true;
  
  bool get showTotalView => _showTotalView;
  bool getView() => _showTotalView;

  ViewNotifier() {
    StorageManager.readData('ShowTotal').then((value) {
      _showTotalView = value ?? true;
      notifyListeners();
    });
  }

  void enableTotalView() async {
    _showTotalView = true;
    StorageManager.saveData('ShowTotal', true);
    notifyListeners();
  }

  void disableTotalView() async {
    _showTotalView = false;
    StorageManager.saveData('ShowTotal', false);
    notifyListeners();
  }
}
