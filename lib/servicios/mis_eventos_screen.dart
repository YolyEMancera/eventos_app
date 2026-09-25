import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'evento_card.dart';

/// Pantalla 7 - Mis eventos: eventos inscritos (RF-006), cancelar
/// inscripción con 24 h de antelación (RF-005), ver entrada y
/// agregar al calendario (RF-012).
class MisEventosScreen extends StatefulWidget {
  final int usuarioId;

  const MisEventosScreen({super.key, this.usuarioId = 1});

  @override
  State<MisEventosScreen> createState() => _MisEventosScreenState();
}

class _MisEventosScreenState extends State<MisEventosScreen> {
  List<InscripcionDetalle> _inscripciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await DatabaseHelper.instance.obtenerMisEventos(widget.usuarioId);
    if (!mounted) return;
    setState(() {
      _inscripciones = lista;
      _cargando = false;
    });
  }

  Future<void> _cancelar(InscripcionDetalle ins) async {
    if (!ins.evento.cancelable) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No es posible cancelar'),
          content: const Text(
              'Solo puedes cancelar tu inscripción con al menos 24 horas de antelación al evento.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendido')),
          ],
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cancelar inscripción?'),
        content: Text('Vas a cancelar tu inscripción a "${ins.evento.nombre}".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final error = await DatabaseHelper.instance.cancelarInscripcion(ins.inscripcionId);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    await _cargar();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('❌ Inscripción cancelada'),
        content: Text('Tu inscripción a "${ins.evento.nombre}" fue cancelada.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Aceptar')),
        ],
      ),
    );
  }

  void _verEntrada(InscripcionDetalle ins) {
    final e = ins.evento;
    final codigo = 'EVU-${ins.inscripcionId.toString().padLeft(5, '0')}';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎟️ Mi entrada', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 140),
            Text(codigo, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 12),
            Text(e.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            filaInfo(Icons.calendar_today, formatoFecha(e.fechaHora)),
            filaInfo(Icons.access_time, formatoHora(e.fechaHora)),
            filaInfo(Icons.location_on, e.ubicacion),
            const SizedBox(height: 8),
            const Text('Estado: INSCRITO ✅',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      appBar: AppBar(
        title: const Text('Mis eventos'),
        backgroundColor: kPrimario,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _inscripciones.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.black38),
                      SizedBox(height: 8),
                      Text('Aún no te has inscrito a ningún evento'),
                    ],
                  ),
                )
              // ListView.builder = equivalente en Flutter al RecyclerView
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _inscripciones.length,
                  itemBuilder: (context, i) => _tarjeta(_inscripciones[i]),
                ),
    );
  }

  Widget _tarjeta(InscripcionDetalle ins) {
    final e = ins.evento;
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
                  child: Text(e.nombre,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            filaInfo(Icons.calendar_today, formatoFecha(e.fechaHora)),
            filaInfo(Icons.access_time, formatoHora(e.fechaHora)),
            filaInfo(Icons.location_on, e.ubicacion),
            const SizedBox(height: 8),
            const Text('Estado: INSCRITO ✅',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.confirmation_number),
                    label: const Text('Ver entrada'),
                    onPressed: () => _verEntrada(ins),
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
                    onPressed: () => _cancelar(ins),
                  ),
                ),
              ],
            ),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('Agregar a mi calendario'),
                onPressed: () => agregarAlCalendario(context, e),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
