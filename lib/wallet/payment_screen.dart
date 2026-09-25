import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realizar Pago"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detalles del pago:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
            
              child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text(
                  "Conferencia de Flutter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                

                SizedBox(height: 15),

                Text(
                  "Fecha: 15 de octubre, 2026",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  "Ubicación: Auditorio Principal",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text("2:00 PM - 5:00 PM", style: TextStyle(fontSize: 16)),
              ],
            ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Monto a pagar: \$20.000",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Pago Exitoso"),
                      content: const Text(
                          "¡Gracias por tu pago! Tu registro ha sido confirmado."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: const Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
                // Acción para procesar el pago
              },
              child: const Text("Pagar"),
            ),
          ],
        ),
      ),
    );
  }
}