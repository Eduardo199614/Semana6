import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Verifica si el usuario fue autenticado correctamente
      if (userCredential.user != null) {
        print("Login exitoso");
        print("Usuario: ${userCredential.user?.email}");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("Error: No se pudo autenticar el usuario.");
        _showErrorDialog("Error: No se pudo autenticar el usuario.");
      }
    } catch (e) {
      String errorMessage = "Ha ocurrido un error desconocido";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuario no encontrado. Verifica tu email.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta. Inténtalo de nuevo.';
            break;
          case 'invalid-email':
            errorMessage = 'Formato de email no válido.';
            break;
          default:
            errorMessage = e.message ?? 'Error desconocido.';
        }
      }
      print("Error: $errorMessage");
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
