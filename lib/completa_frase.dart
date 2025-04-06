import 'package:flutter/material.dart';

class CompletaFrasePage extends StatefulWidget {
  @override
  _CompletaFrasePageState createState() => _CompletaFrasePageState();
}

class _CompletaFrasePageState extends State<CompletaFrasePage> {
  final List<Map<String, dynamic>> _frases = [
    {
      'texto': 'She ___ a teacher.',
      'opciones': ['is', 'are', 'be'],
      'correcta': 'is',
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

  int _indice = 0;
  String _respuestaSeleccionada = '';
  bool _mostrandoResultado = false;

  void _verificarRespuesta(String opcion) {
    if (_mostrandoResultado) return;

    setState(() {
      _respuestaSeleccionada = opcion;
      _mostrandoResultado = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _indice = (_indice + 1) % _frases.length;
        _respuestaSeleccionada = '';
        _mostrandoResultado = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final fraseActual = _frases[_indice];
    final esCorrecta = _respuestaSeleccionada == fraseActual['correcta'];

    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0),
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
            Text(
              fraseActual['texto'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ...fraseActual['opciones'].map<Widget>((opcion) {
              Color color = Colors.blueAccent;
              if (_mostrandoResultado) {
                if (opcion == fraseActual['correcta']) {
                  color = Colors.green;
                } else if (opcion == _respuestaSeleccionada) {
                  color = Colors.red;
                } else {
                  color = Colors.grey;
                }
              }

              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _verificarRespuesta(opcion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(opcion, style: TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
            if (_mostrandoResultado)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  esCorrecta ? '✅ ¡Correcto!' : '❌ ¡Incorrecto!',
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
