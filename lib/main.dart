import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pantalla_inicio.dart';
import 'pantalla_juegos.dart';
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PalabraManiaApp());
}

class PalabraManiaApp extends StatelessWidget {
  const PalabraManiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PalabraManía',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {
            return PantallaJuegos(); // Usuario ya logueado
          } else {
            return const PantallaInicio(); // Usuario no logueado
          }
        },
      ),
    );
  }
}

