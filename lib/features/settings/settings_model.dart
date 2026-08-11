import 'package:flutter/material.dart';

/// Local, in-memory settings toggles. Nothing here persists across
/// restarts, and the dark mode toggle doesn't actually switch the app
/// theme yet — it's a UI placeholder.
class SettingsModel extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _useImperialUnits = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get useImperialUnits => _useImperialUnits;

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setDarkModeEnabled(bool value) {
    _darkModeEnabled = value;
    notifyListeners();
  }

  void setUseImperialUnits(bool value) {
    _useImperialUnits = value;
    notifyListeners();
  }
}
