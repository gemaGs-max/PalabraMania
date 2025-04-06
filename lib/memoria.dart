import 'package:flutter/material.dart';
import 'dart:math';

class MemoriaPage extends StatefulWidget {
  @override
  _MemoriaPageState createState() => _MemoriaPageState();
}

class _MemoriaPageState extends State<MemoriaPage> {
  List<_CartaMemoria> _cartas = [];
  List<int> _seleccionadas = [];
  bool _bloqueado = false;

  @override
  void initState() {
    super.initState();
    _generarCartas();
  }

  void _generarCartas() {
    final pares = [
      {'es': 'Casa', 'en': 'House'},
      {'es': 'Perro', 'en': 'Dog'},
      {'es': 'Manzana', 'en': 'Apple'},
      {'es': 'Libro', 'en': 'Book'},
    ];

    List<_CartaMemoria> todas = [];

    for (var par in pares) {
      todas.add(_CartaMemoria(texto: par['es']!, id: par['es']!));
      todas.add(_CartaMemoria(texto: par['en']!, id: par['es']!));
    }

    todas.shuffle(Random());
    setState(() {
      _cartas = todas;
    });
  }

  void _seleccionarCarta(int index) {
    if (_bloqueado || _cartas[index].descubierta || _cartas[index].girada) return;

    setState(() {
      _cartas[index].girada = true;
      _seleccionadas.add(index);
    });

    if (_seleccionadas.length == 2) {
      _bloqueado = true;

      int i1 = _seleccionadas[0];
      int i2 = _seleccionadas[1];

      bool esPar = _cartas[i1].id == _cartas[i2].id;

      setState(() {
        _cartas[i1].colorTemporal = esPar ? Colors.green : Colors.red;
        _cartas[i2].colorTemporal = esPar ? Colors.green : Colors.red;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          if (esPar) {
            _cartas[i1].descubierta = true;
            _cartas[i2].descubierta = true;
          } else {
            _cartas[i1].girada = false;
            _cartas[i2].girada = false;
          }

          _cartas[i1].colorTemporal = null;
          _cartas[i2].colorTemporal = null;
          _seleccionadas.clear();
          _bloqueado = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '🎉 ¡Has encontrado todas las parejas!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: _cartas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final carta = _cartas[index];
                return GestureDetector(
                  onTap: () => _seleccionarCarta(index),
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

class _CartaMemoria {
  final String texto;
  final String id;
  bool girada = false;
  bool descubierta = false;
  Color? colorTemporal;

  _CartaMemoria({required this.texto, required this.id});
}

