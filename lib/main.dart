```dart
import 'package:flutter/material.dart';

import 'registro.dart';
import 'login.dart';
import 'perfil.dart';
import 'servicios/home_screen.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: const RechargeScreen(),

      routes: {
        '/registro': (context) => const Registro(),
        '/login': (context) => const Login(),
        '/perfil': (context) => const Perfil(),

        // Pantalla principal de eventos
        '/home': (context) => const HomeScreen(),

        // Pantallas de billetera
        '/wallet/wallet': (context) => const WalletScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/recharge': (context) => const RechargeScreen(),
      },
    );
  }
}
```
