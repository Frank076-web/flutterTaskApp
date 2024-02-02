import 'package:flutter/material.dart';
import 'package:flutterapp/src/providers/tasks_provider.dart';
import 'package:flutterapp/src/screens/tasks/widgets/edit_task.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:flutterapp/src/services/tasks_service.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, taskProvider, _) {
        taskProvider.fetchTasks();
        if (taskProvider.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              return _TaskItem(task: taskProvider.tasks[index]);
            },
          );
        }
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final TasksService _service = TasksService.getInstance();

  _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nombre: ${task.title}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text('Descripción: ${task.description}'),
          const SizedBox(height: 4.0),
          Text(
            'Estado: ${task.completed == TaskStatus.completed ? "Completado" : "En progreso"}',
            style: TextStyle(
              color: task.completed == TaskStatus.completed
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task)),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                String? token =
                    await SecuredAndSharedPreferencesService.getInstance()
                        .getSecured("token");

                await _service.deleteTask(token!, task.id.toString());
              }),
        ],
      ),
    );
  }
}
