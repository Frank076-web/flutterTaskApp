import 'package:flutter/material.dart';
import 'package:flutterapp/src/services/register_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp passwordRegExp =
      RegExp(r"^(?=.*[A-Z])(?=.*[0-9])(?=.*[\W_]).{8,}$");

  final RegisterService service = RegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Registro', style: TextStyle(color: Colors.white)),
        ),
        body: _buildRegisterForm(context));
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNameInput(),
              const SizedBox(height: 20),
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
                      if (await service.register(_nameController.text,
                          _emailController.text, _passwordController.text)) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registro satisfactorio'),
                              content: const Text(
                                  "Usuario registrado correctamente"),
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
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      service.showErrorDialog(context, e.toString());
                    }
                  }
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce un nombre';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        errorMaxLines: 2,
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce una contraseña';
        } else if (value.length < 8) {
          return 'La contraseña debe tener al menos 8 caracteres';
        } else if (!passwordRegExp.hasMatch(value)) {
          return "La contraseña debe tener al menos una letra mayúscula, una minúscula, un número y un carácter especial";
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
