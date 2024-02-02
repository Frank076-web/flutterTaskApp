import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  final String _baseApiPath = dotenv.env["BASE_PATH"]!;
  final String _registerPath = dotenv.env["AUTH_REGISTER_PATH"]!;

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseApiPath/$_registerPath"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw Exception('Error en el registro $e');
    }
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error en el registro'),
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
