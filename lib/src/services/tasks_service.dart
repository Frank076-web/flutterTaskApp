import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/src/providers/tasks_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksService {
  final String _baseUrl = dotenv.env['BASE_PATH']!;
  final String _tasksUrl = dotenv.env['TASKS_PATH']!;

  TasksService._private();

  static final TasksService _instance = TasksService._private();

  static TasksService getInstance() {
    return _instance;
  }

  Future<List<Task>> getTasks(String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/$_tasksUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      List<Task> tasks = (json.decode(response.body) as List<dynamic>)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();

      return tasks;
    } else {
      throw Exception('Error al obtener las tareas');
    }
  }

  Future<Task> createTask(String token, Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$_tasksUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'title': task.title,
        'description': task.description,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear la tarea');
    }
  }

  Future<Task> updateTask(String token, Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$_tasksUrl/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'completed': task.completed,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar la tarea');
    }
  }

  Future<void> deleteTask(String token, String taskId) async {
    final response = await http
        .delete(Uri.parse('$_baseUrl/$_tasksUrl/$taskId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la tarea');
    }
  }
}
