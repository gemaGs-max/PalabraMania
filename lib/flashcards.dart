import 'dart:async';
import 'package:flutter/material.dart';
import 'package:palabramania/services/firestore_service.dart';

class FlashcardsPage extends StatefulWidget {
  @override
  _FlashcardsPageState createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<Map<String, String>> _flashcardsOriginales = [
    {'front': 'Manzana', 'back': 'Apple'},
    {'front': 'Perro', 'back': 'Dog'},
    {'front': 'Casa', 'back': 'House'},
    {'front': 'Libro', 'back': 'Book'},
    {'front': 'Escuela', 'back': 'School'},
  ];

  late List<Map<String, String>> _flashcards;
  int _currentIndex = 0;
  int _puntos = 0;
  int _tiempoRestante = 10;
  bool _mostrarFeedback = false;
  bool _bloquear = false;
  String _feedback = '';
  Timer? _timer;

  final TextEditingController _respuestaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reiniciarJuego();
  }

  void _reiniciarJuego() {
    _flashcards = List.from(_flashcardsOriginales);
    _flashcards.shuffle();
    _currentIndex = 0;
    _puntos = 0;
    _mostrarFeedback = false;
    _bloquear = false;
    _respuestaController.clear();
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer?.cancel();
    _tiempoRestante = 10;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoRestante--;
      });

      if (_tiempoRestante == 0) {
        timer.cancel();
        _mostrarRespuestaAutomatica();
      }
    });
  }

  void _mostrarRespuestaAutomatica() {
    final correcta = _flashcards[_currentIndex]['back']!;
    setState(() {
      _feedback = '⏰ Tiempo agotado. Era: $correcta';
      _mostrarFeedback = true;
      _bloquear = true;
    });

    Future.delayed(Duration(seconds: 2), _pasarSiguiente);
  }

  void _comprobarRespuesta() {
    if (_bloquear) return;

    final correcta = _flashcards[_currentIndex]['back']!.toLowerCase().trim();
    final respuesta = _respuestaController.text.toLowerCase().trim();

    _timer?.cancel();

    setState(() {
      if (respuesta == correcta) {
        _puntos++;
        _feedback = '🎉 ¡Correcto!';
      } else {
        _feedback = '❌ Era: ${_flashcards[_currentIndex]['back']}';
      }
      _mostrarFeedback = true;
      _bloquear = true;
    });

    Future.delayed(Duration(seconds: 2), _pasarSiguiente);
  }

  void _pasarSiguiente() {
    if (_currentIndex + 1 >= _flashcards.length) {
      _mostrarDialogoFinal();
      guardarPuntuacion('flashcards', _puntos);
      return;
    }

    setState(() {
      _currentIndex++;
      _respuestaController.clear();
      _mostrarFeedback = false;
      _bloquear = false;
    });

    _iniciarTemporizador();
  }

  void _mostrarDialogoFinal() {
    _timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('✅ Juego completado'),
        content: Text('Has conseguido $_puntos puntos.\n¿Quieres reintentar?'),
        actions: [
          TextButton(
            child: Text('Salir'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra diálogo
              Navigator.of(context).pop(); // Vuelve a pantalla de juegos
            },
          ),
          ElevatedButton(
            child: Text('Reintentar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra diálogo
              setState(() {
                _reiniciarJuego(); // Reinicia todo
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _respuestaController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _flashcards[_currentIndex];

    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        title: const Text('🧠 Flashcards'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
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
            TextField(
              controller: _respuestaController,
              enabled: !_bloquear,
              decoration: InputDecoration(
                hintText: 'Escribe la palabra en inglés',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bloquear ? null : _comprobarRespuesta,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Comprobar'),
            ),
            const SizedBox(height: 20),
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


