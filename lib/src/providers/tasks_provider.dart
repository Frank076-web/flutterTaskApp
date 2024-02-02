import 'package:flutter/material.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:flutterapp/src/services/tasks_service.dart';

class TaskStatus {
  static const String inProgress = "IN_PROGRESS";
  static const String completed = "COMPLETED";
}

class Task {
  final int id;
  final String title;
  final String description;
  final String completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.completed = TaskStatus.inProgress,
  });

  factory Task.forCreate(Map<String, String> params) {
    return Task(
        id: 0,
        title: params["title"]!,
        description: params["description"]!,
        completed: "");
  }

  factory Task.forEdit(Map<String, String> params) {
    return Task(
        id: int.parse(params["id"]!),
        title: params["title"]!,
        description: params["description"]!,
        completed: params["completed"]!);
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}

class TasksProvider extends ChangeNotifier {
  final TasksService _service = TasksService.getInstance();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    String? token = await SecuredAndSharedPreferencesService.getInstance()
        .getSecured('token');
    try {
      _tasks = await _service.getTasks(token!);
      notifyListeners();
    } catch (e) {
      print('Error al obtener tareas: $e');
    }
  }
}
