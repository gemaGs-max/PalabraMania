// Importamos el paquete principal de Flutter para construir interfaces gráficas.
import 'package:flutter/material.dart';

/// Widget principal que representa la pantalla del minijuego "Completa la frase".
class CompletaFrasePage extends StatefulWidget {
  @override
  _CompletaFrasePageState createState() => _CompletaFrasePageState();
}

/// Estado del widget, donde se maneja la lógica del juego.
class _CompletaFrasePageState extends State<CompletaFrasePage> {
  // Lista de frases con opciones y la respuesta correcta.
  final List<Map<String, dynamic>> _frases = [
    {
      'texto': 'She ___ a teacher.', // Frase a completar
      'opciones': ['is', 'are', 'be'], // Opciones de respuesta
      'correcta': 'is', // Respuesta correcta
    },
    {
      'texto': 'I ___ from Spain.',
      'opciones': ['am', 'is', 'are'],
      'correcta': 'am',
    },
    {
      'texto': 'They ___ football on Sundays.',
      'opciones': ['plays', 'play', 'played'],
      'correcta': 'play',
    },
  ];

  int _indice = 0; // Índice actual de la frase que se muestra.
  String _respuestaSeleccionada = ''; // Almacena la opción elegida por el usuario.
  bool _mostrandoResultado = false; // Indica si se está mostrando el resultado (correcto/incorrecto).

  /// Verifica si la respuesta del usuario es correcta y muestra el resultado.
  void _verificarRespuesta(String opcion) {
    if (_mostrandoResultado) return; // Si ya se está mostrando el resultado, no hacer nada.

    setState(() {
      _respuestaSeleccionada = opcion;
      _mostrandoResultado = true;
    });

    // Espera 2 segundos antes de pasar a la siguiente frase.
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _indice = (_indice + 1) % _frases.length; // Avanza a la siguiente frase.
        _respuestaSeleccionada = '';
        _mostrandoResultado = false;
      });
    });
  }

  /// Construye la interfaz gráfica del minijuego.
  @override
  Widget build(BuildContext context) {
    final fraseActual = _frases[_indice]; // Obtenemos la frase actual a mostrar.
    final esCorrecta = _respuestaSeleccionada == fraseActual['correcta']; // Comprobamos si la respuesta es correcta.

    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0), // Color de fondo claro.
      appBar: AppBar(
        title: Text('✍️ Completa la frase'),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostramos el texto de la frase con espacio para completar.
            Text(
              fraseActual['texto'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Generamos los botones de opciones dinámicamente.
            ...fraseActual['opciones'].map<Widget>((opcion) {
              Color color = Colors.blueAccent; // Color por defecto del botón.

              // Si ya se ha respondido, cambiamos el color según si es correcta o incorrecta.
              if (_mostrandoResultado) {
                if (opcion == fraseActual['correcta']) {
                  color = Colors.green; // Correcta
                } else if (opcion == _respuestaSeleccionada) {
                  color = Colors.red; // Incorrecta seleccionada
                } else {
                  color = Colors.grey; // Resto desactivadas
                }
              }

              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _verificarRespuesta(opcion), // Comprobamos la respuesta al pulsar.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(opcion, style: TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
            // Si se ha respondido, mostramos si fue correcto o incorrecto.
            if (_mostrandoResultado)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  esCorrecta ? ' ¡Correcto!' : ' ¡Incorrecto!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: esCorrecta ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
