// Importamos los paquetes necesarios: Flutter y el plugin just_audio para reproducir sonidos.
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palabramania/services/firestore_service.dart';

/// Pantalla del minijuego simulado de pronunciación.
/// El usuario escucha una frase y simula que la repite.
class PronunciacionSimulada extends StatefulWidget {
  const PronunciacionSimulada({super.key});

  @override
  State<PronunciacionSimulada> createState() => _PronunciacionSimuladaState();
}

class _PronunciacionSimuladaState extends State<PronunciacionSimulada> {
  // Lista de frases con su texto y el nombre del archivo de audio.
  final List<Map<String, String>> frases = [
    {'texto': 'How are you?', 'audio': 'how_are_you.mp3'},
    {'texto': 'Conversación', 'audio': 'conversacion.mp3'},
  ];

  int fraseActual = 0; // Índice de la frase actual.
  final AudioPlayer _audioPlayer = AudioPlayer(); // Reproductor de audio.

  /// Reproduce el archivo de audio correspondiente a la frase.
  Future<void> reproducirAudio(String archivo) async {
    try {
      await _audioPlayer.setAsset('assets/audios/$archivo'); // Carga el audio desde assets.
      await _audioPlayer.play(); // Reproduce el audio.
    } catch (e) {
      print("Error al reproducir audio: $e"); // En caso de error, lo imprime en consola.
    }
  }

  /// Muestra un mensaje de éxito simulando que el usuario ha repetido la frase correctamente.
  void mostrarMensajeExito(String frase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡Buen trabajo!'),
        content: Text('Has practicado la frase:\n\n"$frase"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cierra el diálogo.
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  /// Libera los recursos del reproductor de audio al cerrar la pantalla.
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Construye la interfaz de usuario del minijuego.
  @override
  Widget build(BuildContext context) {
    final frase = frases[fraseActual]; // Obtenemos la frase actual.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reto de Pronunciación'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Repite la frase:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            // Muestra la frase actual en pantalla.
            Text(
              '"${frase['texto']}"',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Botón para escuchar la frase en inglés.
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('Escuchar'),
              onPressed: () => reproducirAudio(frase['audio']!),
            ),

            const SizedBox(height: 20),

            // Botón para simular que el usuario habla (muestra un mensaje de éxito).
            ElevatedButton.icon(
              icon: const Icon(Icons.mic),
              label: const Text('Hablar'),
              onPressed: () => mostrarMensajeExito(frase['texto']!),
            ),

            const SizedBox(height: 40),

            // Botón para pasar a la siguiente frase del reto.
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fraseActual = (fraseActual + 1) % frases.length; // Cicla entre las frases.
                });
              },
              child: const Text('➡️ Otra frase'),
            ),
          ],
        ),
      ),
    );
  }
}

