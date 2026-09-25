import 'package:flutter/material.dart';

import 'evento.dart';

/// Utilidades y widgets compartidos por las pantallas de eventos.

const Color colorPrimario = Color(0xFF5B5FEF);

IconData iconoCategoria(String categoria) {
  if (categoria == 'Tecnología') return Icons.computer;
  if (categoria == 'Deportes') return Icons.sports_soccer;
  return Icons.music_note;
}

Color colorCategoria(String categoria) {
  if (categoria == 'Tecnología') return colorPrimario;
  if (categoria == 'Deportes') return Colors.teal;
  return Colors.deepOrange;
}

/// Las acciones de esta entrega solo muestran una vista de demostración.
void mostrarDemo(BuildContext context, String titulo, String mensaje) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

void mostrarCalendarioDemo(BuildContext context, Evento evento) {
  mostrarDemo(
    context,
    'Calendario de ejemplo',
    '${evento.nombre}\n${evento.fecha} · ${evento.hora}\n'
        'Esta vista no agrega eventos al calendario del dispositivo.',
  );
}

Widget filaInfo(IconData icono, String texto) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(icono, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}

/// Tarjeta de evento usada en Home y en Eventos por categoría.
class EventoCard extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;

  const EventoCard({super.key, required this.evento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = colorCategoria(evento.categoria);

    final estado = evento.disponibilidad;
    Color colorEstado = Colors.green;
    if (estado == 'A punto de cerrar') {
      colorEstado = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconoCategoria(evento.categoria),
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    filaInfo(Icons.calendar_today, evento.fecha),
                    filaInfo(Icons.access_time, evento.hora),
                    filaInfo(Icons.location_on, evento.ubicacion),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: colorEstado),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            estado,
                            style: TextStyle(fontSize: 12, color: colorEstado),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            evento.precio,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Ver más ›',
                        style: TextStyle(color: colorPrimario, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
