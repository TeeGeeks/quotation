import 'dart:async';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier {
  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  Future<void> login(String token, String userId) async {
    _token = token;
    _userId = userId;
    notifyListeners();
    print("userId: $_userId");
  }

  Future<void> loginWithGoogle() async {}

  void logout() {
    _token = null;
    _userId = null;
    notifyListeners();
  }
}
