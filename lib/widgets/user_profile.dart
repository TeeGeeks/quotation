import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quotation_app/base_url.dart';

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
