// Importamos los paquetes necesarios para usar Flutter y Firebase.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Inicializa Firebase en la app.
import 'package:firebase_auth/firebase_auth.dart'; // Gestiona la autenticación de usuarios con Firebase.

// Importamos nuestras pantallas personalizadas.
import 'pantalla_inicio.dart';   // Pantalla de bienvenida para usuarios no autenticados.
import 'pantalla_juegos.dart';   // Pantalla principal con los minijuegos.
import 'auth_screen.dart';       // Pantalla de login/registro.

/// Función principal que se ejecuta al iniciar la app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter esté correctamente inicializado antes de usar Firebase.
  await Firebase.initializeApp();            // Inicializamos Firebase.
  runApp(const PalabraManiaApp());           // Lanzamos la aplicación.
}

/// Widget principal de la app PalabraManía.
class PalabraManiaApp extends StatelessWidget {
  const PalabraManiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PalabraManía', // Título de la app.
      theme: ThemeData(primarySwatch: Colors.deepOrange), // Tema visual (color principal).
      debugShowCheckedModeBanner: false, // Oculta la etiqueta "debug" en la esquina.
      
      // Determina la pantalla inicial según el estado de autenticación del usuario.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Escucha los cambios de estado del usuario (login/logout).
        builder: (context, snapshot) {
          // Si aún está cargando la conexión con Firebase, mostramos un indicador de carga.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } 
          // Si el usuario está autenticado, lo llevamos directamente a los juegos.
          else if (snapshot.hasData) {
            return PantallaJuegos();
          } 
          // Si no hay usuario autenticado, mostramos la pantalla de inicio.
          else {
            return const PantallaInicio();
          }
        },
      ),
    );
  }
}


