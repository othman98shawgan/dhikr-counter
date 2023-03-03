import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'store_manager.dart';

class DikhrNotifier with ChangeNotifier {
  int _dikhrCount = 100;
  bool _vibrateOnTap = true;
  bool _vibrateOnCountTarget = true;
  
  int getDikhrTarget() => _dikhrCount;
  bool getVibrateOnTap() => _vibrateOnTap;
  bool getVibrateOnCountTarget() => _vibrateOnCountTarget;

  DikhrNotifier() {
    StorageManager.readData('DikhrCount').then((value) {
      _dikhrCount = value ?? 33;
      notifyListeners();
    });
    StorageManager.readData('VibrateOnTap').then((value) {
      _vibrateOnTap = value ?? true;
      notifyListeners();
    });
    StorageManager.readData('VibrateOnCountTarget').then((value) {
      _vibrateOnCountTarget = value ?? true;
      notifyListeners();
    });
  }

  void setDikhrCount(int val) async {
    _dikhrCount = val;
    StorageManager.saveData('DikhrCount', val);
    notifyListeners();
  }

  void enableVibrateOnTap() async {
    _vibrateOnTap = true;
    StorageManager.saveData('VibrateOnTap', true);
    notifyListeners();
  }

  void disableVibrateOnTap() async {
    _vibrateOnTap = false;
    StorageManager.saveData('VibrateOnTap', false);
    notifyListeners();
  }

  void enableVibrateOnCountTarget() async {
    _vibrateOnCountTarget = true;
    StorageManager.saveData('VibrateOnCountTarget', true);
    notifyListeners();
  }

  void disableVibrateOnCountTarget() async {
    _vibrateOnCountTarget = false;
    StorageManager.saveData('VibrateOnCountTarget', false);
    notifyListeners();
  }
}
