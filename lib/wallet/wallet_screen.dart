import "package:flutter/material.dart";

import '../barra_navegacion.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BarraNavegacion(indiceActual: 2),
      appBar: AppBar(title: const Text("Mi billetera")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saldo disponible:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "\$100.000",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Botón para recargar saldo
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recharge');
              },
              child: const Text("Recargar saldo"),
            ),
            const SizedBox(height: 30),

            const Text(
              "Ultimos movimientos:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.arrow_downward),
              ),
              title: Text("Conferencia de Flutter"),
              subtitle: Text("Pago de evento"),
              trailing: Text(
                "-\$20.000",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Divider(),

            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.arrow_upward),
              ),
              title: Text("Reembolso de evento"),
              subtitle: Text("Evento cancelado"),
              trailing: Text(
                "+\$20.000",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
