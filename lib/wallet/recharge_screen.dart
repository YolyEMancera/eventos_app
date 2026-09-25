import 'package:flutter/material.dart';

class RechargeScreen extends StatefulWidget { /// para introducir datos
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {

  final TextEditingController _valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Recargar saldo'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,         
          children: [
             //Sección de saldo actual
            const Text('Saldo actual: \$100.000',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            //Sección de recarga de saldo
            
            // Campo de texto para ingresar el monto a recargar
            const SizedBox(height: 10),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number, 
              // para que solo se puedan ingresar números
          
              decoration: InputDecoration(
                hintText: 'Ej: 10.000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // para redondear los bordes del TextField
                ),  
              ),
            ),

            const SizedBox(height: 25),
            // Botón para recargar saldo
            SizedBox(
              width: double.infinity,
              
              child: ElevatedButton(
                onPressed: () {
                  // Acción para recargar saldo
                  final valor = _valorController.text.trim();

                  // Validar que el valor ingresado no esté vacío
                  if (valor.isEmpty) {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Monto inválido'),
                        content: const Text(
                          'Por favor, ingrese un monto válido.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // Simulación de recarga exitosa
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Recarga exitosa'),
                      content: Text('La recarga de \$$valor fue exitosa.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                  },
                child: const Text('Recargar saldo'),
              ),
            ),
          ],
      ),
    ),
  );
  } // Fin del método build
// Dispose del controlador de texto para liberar recursos
  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }
}