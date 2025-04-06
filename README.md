import 'package:flutter/material.dart';

void main() {
runApp(PalabraManiaApp());
}

class PalabraManiaApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'PalabraManía',
theme: ThemeData(
primarySwatch: Colors.orange,
),
home: WelcomeScreen(),
debugShowCheckedModeBanner: false,
);
}
}

class WelcomeScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.orange[100],
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Image.asset('assets/logo.png', width: 120),
SizedBox(height: 20),
Text(
'¡Bienvenido a PalabraManía!',
style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
textAlign: TextAlign.center,
),
SizedBox(height: 30),
ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => FlashcardScreen()),
);
},
child: Text('Empezar'),
)
],
),
),
);
}
}

class FlashcardScreen extends StatefulWidget {
@override
_FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
int index = 0;

final List<Map<String, String>> flashcards = [
{'es': 'Manzana', 'en': 'Apple'},
{'es': 'Perro', 'en': 'Dog'},
{'es': 'Casa', 'en': 'House'},
{'es': 'Libro', 'en': 'Book'},
];

void nextCard() {
setState(() {
index = (index + 1) % flashcards.length;
});
}

@override
Widget build(BuildContext context) {
final card = flashcards[index];

    return Scaffold(
      appBar: AppBar(title: Text('Flashcards')),
      body: Center(
        child: GestureDetector(
          onTap: nextCard,
          child: Card(
            elevation: 8,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(40),
              width: double.infinity,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    card['es']!,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    card['en']!,
                    style: TextStyle(fontSize: 24, color: Colors.grey[700]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
}
}

