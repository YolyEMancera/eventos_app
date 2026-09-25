import 'package:flutter/material.dart';

import 'registro.dart';
import 'login.dart';
import 'perfil.dart';
import 'wallet/wallet_screen.dart';
import 'wallet/recharge_screen.dart';
import 'servicios/home_screen.dart';
import 'servicios/mis_eventos_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      initialRoute: '/login',

      routes: {
        '/registro': (context) => const Registro(),
        '/login': (context) => const Login(),
        '/perfil': (context) => const Perfil(),
        '/wallet/wallet': (context) => const WalletScreen(),
        '/recharge': (context) => const RechargeScreen(),
        '/home': (context) => const HomeScreen(),
        '/mis-eventos': (context) => const MisEventosScreen(),
      },
    );
  }
}
