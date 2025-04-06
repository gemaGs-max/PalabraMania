import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pantalla_juegos.dart';

class PantallaNombre extends StatefulWidget {
  @override
  _PantallaNombreState createState() => _PantallaNombreState();
}

class _PantallaNombreState extends State<PantallaNombre> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _guardarNombreYContinuar() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe tu nombre.')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre_usuario', nombre);

      // Login anónimo con Firebase
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      // Ir a juegos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PantallaJuegos()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('¿Cómo te llamas?'),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escribe tu nombre para comenzar:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Tu nombre',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _guardarNombreYContinuar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Empezar a jugar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
