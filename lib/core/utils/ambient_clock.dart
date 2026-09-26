import 'dart:async';

import 'package:flutter/foundation.dart';

/// 20fps clock for decorative animation. A looping AnimationController requests a
/// frame every vsync (60fps forever); this only runs while listened to and shares frames.
class AmbientClock extends ChangeNotifier {
  AmbientClock._();

  static final AmbientClock instance = AmbientClock._();

  static const Duration interval = Duration(milliseconds: 50);

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _listenerCount = 0;

  double get seconds => _stopwatch.elapsedMicroseconds / 1e6;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (_listenerCount++ == 0) {
      _stopwatch.start();
      _timer = Timer.periodic(interval, (_) => notifyListeners());
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (--_listenerCount == 0) {
      _timer?.cancel();
      _timer = null;
      _stopwatch.stop();
    }
  }
}
