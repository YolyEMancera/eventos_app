import 'package:flutter/material.dart';

import 'registro.dart';
import 'login.dart';
import 'perfil.dart';

void main() {
  runApp(const EventosApp());
}

class EventosApp extends StatelessWidget {
  const EventosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      home: const Registro(),

      routes: {
        '/registro': (context) => const Registro(),
        '/login': (context) => const Login(),
        '/perfil': (context) => const Perfil(),
      },
    );
  }
}