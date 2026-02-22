import 'package:flutter/material.dart';

class MapModeNotifier extends ChangeNotifier {
  final bool _isLoading = false;
  final String _message = "";



  bool get isLoading => _isLoading;
  String get message => _message;

}