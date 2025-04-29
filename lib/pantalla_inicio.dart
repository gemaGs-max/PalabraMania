// Importamos los paquetes necesarios: Flutter y la pantalla de autenticación.
import 'package:flutter/material.dart';
import 'auth_screen.dart';

/// Pantalla de bienvenida de la app PalabraManía.
/// Desde aquí, el usuario puede iniciar sesión o registrarse.
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Color de fondo claro (crema).
      appBar: AppBar(
        title: const Text('PalabraManía'), // Título de la app.
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos.
          children: [
            // Logo de la app (debe estar en la carpeta assets).
            Image.asset('assets/logo.png', width: 180),

            const SizedBox(height: 25), // Espacio entre elementos.

            // Mensaje de bienvenida destacado.
            const Text(
              '¡Bienvenida a PalabraManía!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),

            const SizedBox(height: 10),

            // Subtítulo o descripción.
            const Text(
              'Aprende idiomas jugando y diviértete al máximo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Botón para comenzar (lleva a la pantalla de login/registro).
            ElevatedButton(
              onPressed: () {
                // Navegamos a la pantalla de autenticación.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                '¡Empezar ya!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

