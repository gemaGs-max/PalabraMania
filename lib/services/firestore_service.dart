import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> guardarPuntuacion(String juego, int nuevaPuntuacion) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final uid = user.uid;
  final docRef = FirebaseFirestore.instance
      .collection('puntuaciones')
      .doc('${uid}_$juego');

  final doc = await docRef.get();
  int puntosAntiguos = 0;

  if (doc.exists) {
    final datos = doc.data();
    puntosAntiguos = datos?['puntos'] ?? 0;

    if (nuevaPuntuacion > puntosAntiguos) {
      await docRef.set({
        'email': user.email,
        'juego': juego,
        'puntos': nuevaPuntuacion,
        'fecha': FieldValue.serverTimestamp(),
      });
    } else {
      return; // No supera la puntuación anterior, salimos
    }
  } else {
    await docRef.set({
      'email': user.email,
      'juego': juego,
      'puntos': nuevaPuntuacion,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  // 🔢 Actualizar total acumulado en colección 'usuarios'
  final userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
  final userDoc = await userRef.get();
  final puntosTotales = (userDoc.data()?['puntos'] ?? 0) - puntosAntiguos + nuevaPuntuacion;

  await userRef.update({
    'puntos': puntosTotales,
  });
}


