import 'package:flutter/material.dart';
import 'package:flutterapp/src/screens/tasks/tasks_screen.dart';
import 'package:flutterapp/src/services/login_service.dart';
import 'package:flutterapp/src/services/secured_shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final LoginService service = LoginService();
  final SecuredAndSharedPreferencesService _storage =
      SecuredAndSharedPreferencesService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<String?>(
        future: _storage.getSecured('token'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => TasksScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
              return Container();
            } else {
              return _buildLoginForm(context);
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildEmailInput(),
            const SizedBox(height: 20),
            _buildPasswordInput(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Colors.black, // Cambiar el color del texto del botón
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    if (await service.login(
                        _emailController.text, _passwordController.text)) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/tasks');
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    service.showErrorDialog(context, e.toString());
                  }
                }
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce una contraseña';
        }
        return null;
      },
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce un correo electrónico';
        }
        if (!emailRegExp.hasMatch(value)) {
          return "Por favor, introducce un tipo de correo válido";
        }
        return null;
      },
    );
  }
}
