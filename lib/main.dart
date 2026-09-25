import 'package:flutter/material.dart';

import 'registro.dart';
import 'login.dart';
import 'perfil.dart';
import 'wallet/wallet_screen.dart';
import 'wallet/payment_screen.dart';
import 'wallet/recharge_screen.dart';

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

      home: const WalletScreen(),

      routes: {
        '/registro': (context) => const Registro(),
        '/login': (context) => const Login(),
        '/perfil': (context) => const Perfil(),
        '/wallet/wallet': (context) => const WalletScreen(),
        // pantalla de pago
        '/payment': (context) => const PaymentScreen(),
        // pantalla de recarga
        '/recharge': (context) => const RechargeScreen(),
      },
    );
  }
}