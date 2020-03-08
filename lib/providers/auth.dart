import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _tokenExpiry;
  Timer _authTimer;

  String get token {
    if ((_token != null && _tokenExpiry != null) &&
        _tokenExpiry.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  bool get auth {
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyClbG-4ylFG3kD-Dg4vmf0ogKMyK0oADZA",
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HTTPException(responseData['error']['message']);
      }

      final token = responseData['idToken'];
      final tokenExpiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _token = token;
      _tokenExpiry = tokenExpiry;
      _userId = responseData['localId'];
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      var userData = json.encode({
        'token': _token,
        'userId': _userId,
        'tokenExpiry': _tokenExpiry.toIso8601String(),
      });
      prefs.setString("userId", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogin() async {
    try {
       final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userId')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['tokenExpiry']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _tokenExpiry = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, "accounts:signUp");
  }

  Future<void> signIn(String email, String password) async {
    await _authenticate(email, password, "accounts:signInWithPassword");
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    // prefs.remove("userId");
    prefs.clear();
    _token = null;
    _tokenExpiry = null;
    _userId = null;
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _tokenExpiry.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
