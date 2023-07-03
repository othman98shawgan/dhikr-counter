import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'store_manager.dart';

class VolumeKeyTasbeehNotifier with ChangeNotifier {
  bool? _volumeKeyTasbeeh;

  bool get volumeKeyTasbeeh => _volumeKeyTasbeeh ?? false;

  VolumeKeyTasbeehNotifier() {
    StorageManager.readData('VolumeKeyTasbeeh').then((value) {
      _volumeKeyTasbeeh = value ?? false;
      notifyListeners();
    });
  }

  void enableVolumeKeyTasbeeh() async {
    _volumeKeyTasbeeh = true;
    StorageManager.saveData('VolumeKeyTasbeeh', true);
    notifyListeners();
  }

  void disableVolumeKeyTasbeeh() async {
    _volumeKeyTasbeeh = false;
    StorageManager.saveData('VolumeKeyTasbeeh', false);
    notifyListeners();
  }
}
