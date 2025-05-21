i// Importamos librerías necesarias: control de tiempo y diseño con Flutter.
import 'dart:async';
import 'package:flutter/material.dart';

/// Pantalla del minijuego de Flashcards para practicar vocabulario.
class FlashcardsPage extends StatefulWidget {
  @override
  _FlashcardsPageState createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  // Lista de tarjetas con palabra en español (front) e inglés (back).
  final List<Map<String, String>> _flashcards = [
    {'front': 'Manzana', 'back': 'Apple'},
    {'front': 'Perro', 'back': 'Dog'},
    {'front': 'Casa', 'back': 'House'},
    {'front': 'Libro', 'back': 'Book'},
    {'front': 'Escuela', 'back': 'School'},
  ];

  int _currentIndex = 0; // Índice de la tarjeta actual.
  int _puntos = 0; // Puntuación del usuario.
  int _tiempoRestante = 10; // Tiempo para responder (en segundos).
  bool _mostrarFeedback = false; // Si se muestra el mensaje correcto/incorrecto.
  bool _bloquear = false; // Si se bloquea la interacción tras responder.
  String _feedback = ''; // Mensaje de feedback mostrado al usuario.
  Timer? _timer; // Temporizador para controlar el tiempo de respuesta.

  final TextEditingController _respuestaController = TextEditingController(); // Controlador del campo de texto.

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador(); // Iniciamos el temporizador al comenzar.
  }

  /// Inicia o reinicia el temporizador para cada tarjeta.
  void _iniciarTemporizador() {
    _timer?.cancel(); // Cancelamos el temporizador anterior si existía.
    _tiempoRestante = 10;

    // Temporizador que se ejecuta cada segundo.
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoRestante--;
      });

      // Si el tiempo se agota, mostramos la respuesta correcta.
      if (_tiempoRestante == 0) {
        timer.cancel();
        _mostrarRespuestaAutomatica();
      }
    });
  }

  /// Muestra automáticamente la respuesta correcta si el tiempo se agota.
  void _mostrarRespuestaAutomatica() {
    final correcta = _flashcards[_currentIndex]['back']!;
    setState(() {
      _feedback = '⏰ Tiempo agotado. Era: $correcta';
      _mostrarFeedback = true;
      _bloquear = true;
    });

    // Esperamos 2 segundos antes de pasar a la siguiente tarjeta.
    Future.delayed(Duration(seconds: 2), _pasarSiguiente);
  }

  /// Compara la respuesta del usuario con la correcta.
  void _comprobarRespuesta() {
    if (_bloquear) return; // Si está bloqueado, no hacemos nada.

    final correcta = _flashcards[_currentIndex]['back']!.toLowerCase().trim();
    final respuesta = _respuestaController.text.toLowerCase().trim();

    _timer?.cancel(); // Paramos el temporizador.

    setState(() {
      if (respuesta == correcta) {
        _puntos++; // Sumamos puntos si acierta.
        _feedback = '🎉 ¡Correcto!';
      } else {
        _feedback = '❌ Era: ${_flashcards[_currentIndex]['back']}';
      }
      _mostrarFeedback = true;
      _bloquear = true;
    });

    // Mostramos la siguiente tarjeta tras 2 segundos.
    Future.delayed(Duration(seconds: 2), _pasarSiguiente);
  }

  /// Pasa a la siguiente tarjeta y reinicia el estado.
  void _pasarSiguiente() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length; // Cicla entre tarjetas.
      _respuestaController.clear(); // Limpia el campo de texto.
      _mostrarFeedback = false;
      _bloquear = false;
    });
    _iniciarTemporizador(); // Reinicia el temporizador.
  }

  /// Limpieza al destruir el widget.
  @override
  void dispose() {
    _respuestaController.dispose(); // Libera recursos del controlador.
    _timer?.cancel(); // Cancela temporizador.
    super.dispose();
  }

  /// Construcción de la interfaz del minijuego.
  @override
  Widget build(BuildContext context) {
    final currentCard = _flashcards[_currentIndex];

    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA), // Color de fondo.
      appBar: AppBar(
        title: const Text('🧠 Flashcards'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          // Muestra la puntuación y el tiempo restante.
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text('Puntos: $_puntos  ⏱️ $_tiempoRestante s'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra la palabra en español (front).
            Container(
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              height: 150,
              width: 300,
              alignment: Alignment.center,
              child: Text(
                currentCard['front']!,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // Campo donde el usuario escribe la palabra en inglés.
            TextField(
              controller: _respuestaController,
              enabled: !_bloquear, // Se desactiva tras responder.
              decoration: InputDecoration(
                hintText: 'Escribe la palabra en inglés',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Botón para comprobar la respuesta.
            ElevatedButton(
              onPressed: _bloquear ? null : _comprobarRespuesta,
              child: const Text('Comprobar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),

            const SizedBox(height: 20),

            // Muestra el resultado si ya se ha respondido.
            if (_mostrarFeedback)
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  _feedback,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _feedback.contains('Correcto') ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
