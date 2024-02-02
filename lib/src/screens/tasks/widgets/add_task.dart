import 'package:flutter/material.dart';
import 'package:flutterapp/src/providers/tasks_provider.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:flutterapp/src/services/tasks_service.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TasksService _service = TasksService.getInstance();

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre de la tarea',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Descripción de la tarea',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String? token =
                    await SecuredAndSharedPreferencesService.getInstance()
                        .getSecured("token");

                await _service.createTask(
                    token!,
                    Task.forCreate({
                      "title": nameController.text,
                      "description": descriptionController.text,
                    }));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Agregar Tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
