import 'package:flutter/material.dart';

import 'evento.dart';
import 'evento_card.dart';
import '../wallet/payment_screen.dart';

/// Detalle visual: las acciones abren ejemplos sin registrar ni cobrar.
class DetalleEventoScreen extends StatelessWidget {
  final Evento evento;

  const DetalleEventoScreen({super.key, required this.evento});

  void _mostrarInscripcionDemo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Inscripción de ejemplo'),
        content: Text(
          '${evento.nombre}\nEsta demostración no guarda inscripciones.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamed(context, '/mis-eventos');
            },
            child: const Text('Ver mis eventos'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      body: _contenido(evento),
      bottomNavigationBar: _botones(context, evento),
    );
  }

  Widget _contenido(Evento e) {
    final color = colorCategoria(e.categoria);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(iconoCategoria(e.categoria), size: 80, color: color),
        ),
        const SizedBox(height: 16),
        Chip(label: Text(e.categoria)),
        const SizedBox(height: 8),
        Text(
          e.nombre,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        filaInfo(Icons.calendar_today, e.fecha),
        filaInfo(Icons.access_time, e.hora),
        filaInfo(Icons.location_on, e.ubicacion),
        const Divider(height: 32),
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(e.descripcion),
        const Divider(height: 32),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Precio', style: TextStyle(color: Colors.black54)),
                  Text(
                    e.precio,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cupos', style: TextStyle(color: Colors.black54)),
                  Text(
                    '${e.cupos} disponibles',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _botones(BuildContext context, Evento e) {
    final textoBoton = e.precio == 'Gratis'
        ? 'INSCRIBIRME'
        : 'PAGAR ${e.precio}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimario,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (e.precio == 'Gratis') {
                    _mostrarInscripcionDemo(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(evento: e),
                      ),
                    );
                  }
                },
                child: Text(textoBoton),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Agregar a mi calendario'),
              onPressed: () => mostrarCalendarioDemo(context, e),
            ),
          ],
        ),
      ),
    );
  }
}
