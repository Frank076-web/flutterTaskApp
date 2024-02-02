import 'package:flutter/material.dart';
import 'package:flutterapp/src/providers/tasks_provider.dart';
import 'package:flutterapp/src/screens/home_screen.dart';
import 'package:flutterapp/src/screens/login_screen.dart';
import 'package:flutterapp/src/screens/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapp/src/screens/tasks/tasks_screen.dart';
import 'package:flutterapp/src/services/secured_shared.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await SecuredAndSharedPreferencesService.configurePrefs();
  runApp(ChangeNotifierProvider(
    create: (context) => TasksProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tasks': (context) => TasksScreen(),
      },
    );
  }
}
