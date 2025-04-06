import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PronunciacionSimulada extends StatefulWidget {
  const PronunciacionSimulada({super.key});

  @override
  State<PronunciacionSimulada> createState() => _PronunciacionSimuladaState();
}

class _PronunciacionSimuladaState extends State<PronunciacionSimulada> {
  final List<Map<String, String>> frases = [
    {'texto': 'How are you?', 'audio': 'how_are_you.mp3'},
    {'texto': 'Conversación', 'audio': 'conversacion.mp3'},
  ];

  int fraseActual = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> reproducirAudio(String archivo) async {
    try {
      await _audioPlayer.setAsset('assets/audios/$archivo');
      await _audioPlayer.play();
    } catch (e) {
      print("Error al reproducir audio: $e");
    }
  }

  void mostrarMensajeExito(String frase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡Buen trabajo!'),
        content: Text('Has practicado la frase:\n\n"$frase"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frase = frases[fraseActual];

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
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('Escuchar'),
              onPressed: () => reproducirAudio(frase['audio']!),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.mic),
              label: const Text('Hablar'),
              onPressed: () => mostrarMensajeExito(frase['texto']!),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fraseActual = (fraseActual + 1) % frases.length;
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

