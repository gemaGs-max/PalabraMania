// Importamos los paquetes necesarios de Flutter y Firebase.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pantalla_juegos.dart'; // Importamos la pantalla que se mostrará tras el login.

/// Pantalla de autenticación: permite iniciar sesión o registrarse.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controladores para los campos de texto (email y contraseña).
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;       // Determina si estamos en modo "iniciar sesión" o "registrarse".
  bool _isLoading = false;    // Muestra el indicador de carga mientras se procesa.
  String _error = '';         // Mensaje de error a mostrar si ocurre un problema.

  /// Método para manejar el envío del formulario (login o registro).
  Future<void> _submit() async {
    final auth = FirebaseAuth.instance;

    // Activamos el indicador de carga y limpiamos errores anteriores.
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      UserCredential userCredential;

      // Si estamos en modo login, intentamos iniciar sesión con Firebase.
      if (_isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),    // Eliminamos espacios extra.
          password: _passwordController.text.trim(),
        );
      } else {
        // Si no, intentamos registrar un nuevo usuario.
        userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      // Si el login o registro fue exitoso, vamos a la pantalla de juegos.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PantallaJuegos()),
      );
    } on FirebaseAuthException catch (e) {
      // Si ocurre un error, lo mostramos al usuario.
      setState(() {
        _error = e.message ?? 'Ha ocurrido un error.';
      });
    } finally {
      // Quitamos el indicador de carga.
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Construye la interfaz de usuario.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Color crema de fondo.
      appBar: AppBar(
        title: Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView( // Permite que el contenido sea desplazable.
            child: Column(
              children: [
                // Muestra el mensaje de error si existe.
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                // Campo de entrada de correo electrónico.
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                // Campo de entrada de contraseña.
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true, // Oculta el texto para mayor seguridad.
                ),
                const SizedBox(height: 30),
                // Muestra un indicador de carga o el botón de enviar.
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      _isLogin ? 'Entrar' : 'Registrarse',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                // Botón para cambiar entre login y registro.
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin; // Cambiamos el modo.
                      _error = '';          // Limpiamos errores anteriores.
                    });
                  },
                  child: Text(_isLogin
                      ? '¿No tienes cuenta? Regístrate'
                      : '¿Ya tienes cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
