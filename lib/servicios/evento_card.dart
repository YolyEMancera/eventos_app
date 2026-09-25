import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

/// Utilidades y widgets compartidos por las pantallas de eventos.

const Color kPrimario = Color(0xFF5B5FEF);

const List<String> _meses = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio',
  'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
];

String formatoFecha(DateTime d) => '${d.day} de ${_meses[d.month - 1]}';

String formatoHora(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour < 12 ? 'a.m.' : 'p.m.'}';
}

String formatoPrecio(double valor) {
  if (valor <= 0) return 'Gratis';
  final s = valor.toStringAsFixed(0);
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '\$$buf';
}

IconData iconoCategoria(String categoria) {
  switch (categoria) {
    case 'Tecnología':
      return Icons.computer;
    case 'Deportes':
      return Icons.sports_soccer;
    case 'Música':
      return Icons.music_note;
    default:
      return Icons.event;
  }
}

Color colorCategoria(String categoria) {
  switch (categoria) {
    case 'Tecnología':
      return kPrimario;
    case 'Deportes':
      return Colors.teal;
    case 'Música':
      return Colors.deepOrange;
    default:
      return Colors.grey;
  }
}

/// RF-012: abre el calendario del dispositivo con el evento prellenado.
Future<void> agregarAlCalendario(BuildContext context, Evento e) async {
  final eventoCalendario = Event(
    title: e.nombre,
    description: e.descripcion,
    location: e.ubicacion,
    startDate: e.fechaHora,
    endDate: e.fechaHora.add(const Duration(hours: 2)),
  );
  final ok = await Add2Calendar.addEvent2Cal(eventoCalendario);
  if (!context.mounted) return;
  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el calendario del dispositivo')),
    );
  }
}

/// Navega a una pantalla de otra compañera por nombre de ruta
/// ('/payment', '/wallet/wallet', '/perfil', '/notifications').
/// Si la ruta aún no está registrada en main.dart, muestra un aviso.
Future<Object?> abrirRuta(BuildContext context, String ruta, {Object? argumentos}) async {
  try {
    return await Navigator.pushNamed(context, ruta, arguments: argumentos);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La pantalla $ruta aún no está integrada')),
      );
    }
    return null;
  }
}

Widget filaInfo(IconData icono, String texto, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(icono, size: 16, color: color ?? Colors.black54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(texto,
              style: TextStyle(fontSize: 13, color: color ?? Colors.black87)),
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

    String estado;
    Color colorEstado;
    if (evento.cupos <= 0) {
      estado = 'Agotado';
      colorEstado = Colors.red;
    } else if (evento.cupos <= 10) {
      estado = 'A punto de cerrar';
      colorEstado = Colors.orange;
    } else {
      estado = 'Disponible';
      colorEstado = Colors.green;
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
                child: Icon(iconoCategoria(evento.categoria), size: 40, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evento.nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    filaInfo(Icons.calendar_today, formatoFecha(evento.fechaHora)),
                    filaInfo(Icons.access_time, formatoHora(evento.fechaHora)),
                    filaInfo(Icons.location_on, evento.ubicacion),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: colorEstado),
                        const SizedBox(width: 4),
                        Text(estado, style: TextStyle(fontSize: 12, color: colorEstado)),
                        const Spacer(),
                        Text(formatoPrecio(evento.precio),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('Ver más ›',
                          style: TextStyle(color: kPrimario, fontSize: 12)),
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
