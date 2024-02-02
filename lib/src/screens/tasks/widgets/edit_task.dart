import 'package:flutter/material.dart';
import 'package:flutterapp/src/providers/tasks_provider.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:flutterapp/src/services/tasks_service.dart';

// ignore: must_be_immutable
class EditTaskScreen extends StatelessWidget {
  final Task task;
  final TasksService _service = TasksService.getInstance();

  EditTaskScreen({super.key, required this.task});

  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre de la tarea',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción de la tarea',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            PopupMenuButton<String>(
              onSelected: (String choice) {
                _selectedOption = choice;
              },
              initialValue: _selectedOption,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: TaskStatus.completed,
                    child: Text(TaskStatus.completed),
                  ),
                  const PopupMenuItem<String>(
                    value: TaskStatus.inProgress,
                    child: Text(TaskStatus.inProgress),
                  ),
                ];
              },
              child: Row(children: [
                const Text('Completado: '),
                Text(_selectedOption),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.more_vert),
              ]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                String? token =
                    await SecuredAndSharedPreferencesService.getInstance()
                        .getSecured("token");

                await _service.updateTask(
                    token!,
                    Task.forEdit({
                      "id": task.id.toString(),
                      "title": nameController.text,
                      "description": descriptionController.text,
                      "completed": _selectedOption
                    }));

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(token);
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
