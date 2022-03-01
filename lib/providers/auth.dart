import "dart:convert";

import "package:flutter/material.dart";
import "../models/http_exception.dart";
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  
  bool get isAuth {
    // if token exists then user is authenticated
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBxsEWkB4sgCP3grvSZeFDqHrEDKC7iE-s");
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        })
      );
      final responseBody = json.decode(response.body);

      if (responseBody["error"] != null) {
        throw HttpException(responseBody["error"]["message"]);
      }

      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseBody["expiresIn"])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp (String email, String password) async {
    return _authenticate(email, password, "signup");
  }

  Future<void> signIn (String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}