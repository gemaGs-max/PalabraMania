// Importamos librerías necesarias.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para recuperar datos guardados localmente.
import 'package:firebase_auth/firebase_auth.dart'; // 👈 Para cerrar sesión con Firebase.
import 'auth_screen.dart'; // 👈 Para volver a la pantalla de login tras logout.

import 'flashcards.dart';
import 'completa_frase.dart';
import 'memoria.dart';
import 'pronunciacion_simulada.dart';

/// Pantalla principal donde se eligen los minijuegos.
class PantallaJuegos extends StatefulWidget {
  @override
  _PantallaJuegosState createState() => _PantallaJuegosState();
}

class _PantallaJuegosState extends State<PantallaJuegos> {
  String nombreUsuario = ''; // Nombre que se muestra en el saludo del AppBar.

  @override
  void initState() {
    super.initState();
    _cargarNombre(); // Cargamos el nombre desde SharedPreferences.
  }

  /// Recupera el nombre del usuario almacenado localmente.
  Future<void> _cargarNombre() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('nombre_usuario') ?? 'Invitada/o';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE), // Azul claro.
      appBar: AppBar(
        title: Text('¡Hola, $nombreUsuario!'), // Muestra el saludo con el nombre recuperado.
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          // Botón para cerrar sesión.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Cierra sesión de Firebase.
              // Redirige a la pantalla de autenticación.
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Elige un juego para comenzar 🎮',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Botón para el minijuego Flashcards.
            BotonJuego(
              titulo: '🧠 Flashcards',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashcardsPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón para el minijuego Completa la frase.
            BotonJuego(
              titulo: '✍️ Completa la frase',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletaFrasePage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón para el minijuego Memoria.
            BotonJuego(
              titulo: '🧩 Juego de Memoria',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoriaPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón para el reto de pronunciación.
            BotonJuego(
              titulo: '🎤 Reto de Pronunciación',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PronunciacionSimulada(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget personalizado para los botones de los juegos.
/// Recibe un título (texto con emoji) y una acción al hacer clic.
class BotonJuego extends StatelessWidget {
  final String titulo;
  final VoidCallback onTap;

  const BotonJuego({required this.titulo, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // Acción al pulsar.
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
      ),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
