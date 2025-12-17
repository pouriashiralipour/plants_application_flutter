import 'dart:async';
import 'package:flutter/foundation.dart';

enum AppMessageType { success, error, warning, info }

class AppMessage {
  AppMessage({required this.text, required this.type, this.duration = const Duration(seconds: 3)})
    : id = DateTime.now().microsecondsSinceEpoch;

  final int id;
  final String text;
  final AppMessageType type;
  final Duration duration;
}

class AppMessageController extends ChangeNotifier {
  AppMessage? _current;
  Timer? _timer;

  AppMessage? get current => _current;

  void show(AppMessage message) {
    _timer?.cancel();
    _current = message;
    notifyListeners();

    _timer = Timer(message.duration, dismiss);
  }

  void showSuccess(String text, {Duration duration = const Duration(seconds: 3)}) {
    show(AppMessage(text: text, type: AppMessageType.success, duration: duration));
  }

  void showError(String text, {Duration duration = const Duration(seconds: 3)}) {
    show(AppMessage(text: text, type: AppMessageType.error, duration: duration));
  }

  void dismiss() {
    _timer?.cancel();
    _timer = null;

    if (_current == null) return;
    _current = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
