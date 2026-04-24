import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == "liae@gmail.com" && password == "23112005") {
      return "dummy_token_123";
    }

    return null;
  }
}