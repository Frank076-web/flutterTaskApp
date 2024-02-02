import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String _baseApiPath = dotenv.env["BASE_PATH"]!;
  final String _loginPath = dotenv.env["AUTH_LOGIN_PATH"]!;
  final SecuredAndSharedPreferencesService _storage =
      SecuredAndSharedPreferencesService.getInstance();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseApiPath/$_loginPath"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        await _storage.writeSecured(
            'token', jsonDecode(response.body)['token']);
        return true;
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw Exception('Error de autenticación $e');
    }
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de autenticación'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
