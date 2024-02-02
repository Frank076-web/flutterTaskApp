import 'package:flutter/material.dart';
import 'package:flutterapp/src/screens/tasks/widgets/task_manager.dart';
import 'package:flutterapp/src/services/secured_shared.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);
  final SecuredAndSharedPreferencesService _storage =
      SecuredAndSharedPreferencesService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _storage.getSecured('token'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  return TaskManagerScreen();
                } else {
                  return Container();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
