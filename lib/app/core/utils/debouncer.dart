import 'dart:async';

import 'package:flutter/material.dart';

class SDeBouncer {
  final Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  SDeBouncer({required this.delay});

  void run(VoidCallback callback) {
    _timer?.cancel();
    _callback = callback;
    _timer = Timer(delay, () {
      _callback?.call();
      _timer = null;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
