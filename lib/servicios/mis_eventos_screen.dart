import 'package:flutter/material.dart';

import '../barra_navegacion.dart';
import 'evento.dart';
import 'eventos_mock.dart';
import 'evento_card.dart';

/// Entradas fijas de ejemplo. Cancelar solo presenta el diálogo del prototipo.
class MisEventosScreen extends StatelessWidget {
  const MisEventosScreen({super.key});

  void _verEntrada(BuildContext context, Evento e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎟️ Mi entrada', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 140),
            const Text('Entrada de ejemplo · sin validez de acceso'),
            const SizedBox(height: 8),
            const SizedBox(height: 12),
            Text(
              e.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            filaInfo(Icons.calendar_today, e.fecha),
            filaInfo(Icons.access_time, e.hora),
            filaInfo(Icons.location_on, e.ubicacion),
            const SizedBox(height: 8),
            const Text(
              'Estado: INSCRITO ✅',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BarraNavegacion(indiceActual: 1),
      backgroundColor: const Color(0xFFF3F3F8),
      appBar: AppBar(
        title: const Text('Mis eventos'),
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (final evento in misEventosMock) _tarjeta(context, evento),
        ],
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Evento e) {
    final color = colorCategoria(e.categoria);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconoCategoria(e.categoria), color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            filaInfo(Icons.calendar_today, e.fecha),
            filaInfo(Icons.access_time, e.hora),
            filaInfo(Icons.location_on, e.ubicacion),
            const SizedBox(height: 8),
            const Text(
              'Estado: INSCRITO ✅',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.confirmation_number),
                    label: const Text('Ver entrada'),
                    onPressed: () => _verEntrada(context, e),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    onPressed: () => mostrarDemo(
                      context,
                      'Cancelación de ejemplo',
                      'Esta demostración no cancela la inscripción a ${e.nombre}.',
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('Agregar a mi calendario'),
                onPressed: () => mostrarCalendarioDemo(context, e),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
