import 'package:flutter/material.dart';
import 'auth_screen.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('PalabraManía'),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 180),
            const SizedBox(height: 25),
            const Text(
              '¡Bienvenida a PalabraManía!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aprende idiomas jugando y diviértete al máximo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('¡Empezar ya!', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


