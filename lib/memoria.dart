// Importamos los paquetes necesarios de Flutter.
import 'package:flutter/material.dart';
import 'dart:math'; // Para mezclar aleatoriamente las cartas.

/// Widget principal del minijuego de memoria.
class MemoriaPage extends StatefulWidget {
  @override
  _MemoriaPageState createState() => _MemoriaPageState();
}

/// Estado del juego donde se maneja la lógica del emparejamiento.
class _MemoriaPageState extends State<MemoriaPage> {
  List<_CartaMemoria> _cartas = [];      // Lista de cartas mezcladas.
  List<int> _seleccionadas = [];         // Índices de las cartas seleccionadas actualmente.
  bool _bloqueado = false;               // Indica si se debe bloquear temporalmente la interacción.

  @override
  void initState() {
    super.initState();
    _generarCartas(); // Generamos las cartas al iniciar la pantalla.
  }

  /// Genera y mezcla las cartas a partir de una lista de pares de palabras.
  void _generarCartas() {
    final pares = [
      {'es': 'Casa', 'en': 'House'},
      {'es': 'Perro', 'en': 'Dog'},
      {'es': 'Manzana', 'en': 'Apple'},
      {'es': 'Libro', 'en': 'Book'},
    ];

    List<_CartaMemoria> todas = [];

    for (var par in pares) {
      // Creamos dos cartas por par: una en español y otra en inglés, con el mismo id.
      todas.add(_CartaMemoria(texto: par['es']!, id: par['es']!));
      todas.add(_CartaMemoria(texto: par['en']!, id: par['es']!));
    }

    todas.shuffle(Random()); // Mezclamos las cartas aleatoriamente.

    setState(() {
      _cartas = todas;
    });
  }

  /// Controla la lógica al seleccionar una carta.
  void _seleccionarCarta(int index) {
    // Si el juego está bloqueado o la carta ya está girada o descubierta, no hacemos nada.
    if (_bloqueado || _cartas[index].descubierta || _cartas[index].girada) return;

    setState(() {
      _cartas[index].girada = true;
      _seleccionadas.add(index);
    });

    // Cuando hay dos cartas seleccionadas, comprobamos si forman un par.
    if (_seleccionadas.length == 2) {
      _bloqueado = true;

      int i1 = _seleccionadas[0];
      int i2 = _seleccionadas[1];

      bool esPar = _cartas[i1].id == _cartas[i2].id;

      setState(() {
        // Cambiamos el color temporalmente para mostrar si acertó o no.
        _cartas[i1].colorTemporal = esPar ? Colors.green : Colors.red;
        _cartas[i2].colorTemporal = esPar ? Colors.green : Colors.red;
      });

      // Esperamos 1 segundo para mostrar el resultado antes de continuar.
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (esPar) {
            // Si acertó, dejamos las cartas descubiertas.
            _cartas[i1].descubierta = true;
            _cartas[i2].descubierta = true;
          } else {
            // Si falló, las giramos de nuevo.
            _cartas[i1].girada = false;
            _cartas[i2].girada = false;
          }

          // Limpiamos estado temporal.
          _cartas[i1].colorTemporal = null;
          _cartas[i2].colorTemporal = null;
          _seleccionadas.clear();
          _bloqueado = false;
        });
      });
    }
  }

  /// Construye la interfaz del juego.
  @override
  Widget build(BuildContext context) {
    // Verifica si todas las cartas han sido descubiertas.
    bool completado = _cartas.every((c) => c.descubierta);

    return Scaffold(
      appBar: AppBar(
        title: Text('🧩 Juego de Memoria'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF3E5F5),
      body: Column(
        children: [
          SizedBox(height: 20),
          if (completado)
            // Muestra mensaje de éxito si el juego se ha completado.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '🎉 ¡Has encontrado todas las parejas!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            // Grid que muestra todas las cartas.
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: _cartas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columnas.
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final carta = _cartas[index];
                return GestureDetector(
                  onTap: () => _seleccionarCarta(index), // Selecciona la carta al tocarla.
                  child: Container(
                    decoration: BoxDecoration(
                      color: carta.colorTemporal ??
                          (carta.descubierta || carta.girada
                              ? Colors.white
                              : Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      carta.girada || carta.descubierta ? carta.texto : '',
                      style: TextStyle(
                        fontSize: 18,
                        color: carta.girada || carta.descubierta
                            ? Colors.black
                            : Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Clase que representa una carta del juego de memoria.
class _CartaMemoria {
  final String texto; // Texto visible de la carta.
  final String id;    // Identificador para hacer coincidir parejas.
  bool girada = false; // Si la carta está girada temporalmente.
  bool descubierta = false; // Si la carta ya fue emparejada correctamente.
  Color? colorTemporal; // Color para mostrar resultado (acierto/error).

  _CartaMemoria({required this.texto, required this.id});
}

