import 'package:flutter/material.dart';
import 'package:flutterapp/src/screens/tasks/widgets/add_task.dart';
import 'package:flutterapp/src/screens/tasks/widgets/task_list.dart';
import 'package:flutterapp/src/services/secured_shared.dart';

class TaskManagerScreen extends StatelessWidget {
  TaskManagerScreen({super.key});
  final SecuredAndSharedPreferencesService _storage =
      SecuredAndSharedPreferencesService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Tareas'),
        automaticallyImplyLeading: false,
        actions: [
          const Text("LogOut"),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _storage.deleteSecured('token');
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/", (route) => false);
            },
          ),
        ],
      ),
      body: const TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
