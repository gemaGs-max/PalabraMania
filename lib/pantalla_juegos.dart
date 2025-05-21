import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'flashcards.dart';
import 'completa_frase.dart';
import 'memoria.dart';
import 'pronunciacion_simulada.dart';
import 'pantalla_perfil.dart';
import 'pantalla_ranking.dart';

class PantallaJuegos extends StatefulWidget {
  @override
  _PantallaJuegosState createState() => _PantallaJuegosState();
}

class _PantallaJuegosState extends State<PantallaJuegos> {
  String nombreUsuario = '';
  int puntosTotales = 0;
  Map<String, int> mejoresPuntuaciones = {};

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
    _cargarMejoresPuntuaciones();
  }

  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email_usuario') ?? 'Invitada/o';
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        setState(() {
          nombreUsuario = email;
          puntosTotales = doc.data()?['puntos'] ?? 0;
        });
      }
    }
  }

  Future<void> _cargarMejoresPuntuaciones() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final juegos = ['flashcards', 'completa_frase', 'memoria'];
    final puntuaciones = <String, int>{};

    for (final juego in juegos) {
      final doc = await FirebaseFirestore.instance
          .collection('puntuaciones')
          .doc('${uid}_$juego')
          .get();

      if (doc.exists) {
        puntuaciones[juego] = doc.data()?['puntos'] ?? 0;
      }
    }

    setState(() {
      mejoresPuntuaciones = puntuaciones;
    });
  }

  int nivelUsuario() => (puntosTotales / 100).floor() + 1;
  double progresoNivel() => (puntosTotales % 100) / 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        title: Text('¡Hola, $nombreUsuario!'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Ver perfil',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PantallaPerfil()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Puntuación total: $puntosTotales',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '📶 Nivel: ${nivelUsuario()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progresoNivel(),
              backgroundColor: const Color(0xFFD0D0D0),
              color: Colors.lightBlueAccent,
              minHeight: 10,
            ),
            const SizedBox(height: 4),
            Text(
              '${(progresoNivel() * 100).round()}% para el siguiente nivel',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ...mejoresPuntuaciones.entries.map((e) => Text(
              '🔹 ${_nombreJuego(e.key)}: ${e.value} puntos',
              style: const TextStyle(fontSize: 16),
            )),
            const SizedBox(height: 20),
            const Text(
              'Elige un juego para comenzar 🎮',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  BotonJuego(
                    titulo: '🧠 Flashcards',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardsPage())),
                  ),
                  const SizedBox(height: 20),
                  BotonJuego(
                    titulo: '✍️ Completa la frase',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CompletaFrasePage())),
                  ),
                  const SizedBox(height: 20),
                  BotonJuego(
                    titulo: '🧩 Juego de Memoria',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MemoriaPage())),
                  ),
                  const SizedBox(height: 20),
                  BotonJuego(
                    titulo: '🎤 Reto de Pronunciación',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PronunciacionSimulada())),
                  ),
                  const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaRanking()),
                    );
                  },
                  icon: const Icon(Icons.leaderboard, color: Colors.black),
                  label: const Text(
                    'Ver Ranking',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black54,
                  ),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nombreJuego(String key) {
    switch (key) {
      case 'flashcards':
        return 'Flashcards';
      case 'completa_frase':
        return 'Completa la frase';
      case 'memoria':
        return 'Memoria';
      default:
        return key;
    }
  }
}

class BotonJuego extends StatelessWidget {
  final String titulo;
  final VoidCallback onTap;

  const BotonJuego({required this.titulo, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        shadowColor: Colors.black54,
        elevation: 10,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}