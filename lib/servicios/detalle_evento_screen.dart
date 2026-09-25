import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'evento_card.dart';

/// Pantalla 6 - Detalle del evento con inscripción (RF-004) y
/// opción de agregar al calendario (RF-012).
///
/// Flujo:
///   GRATIS  -> inscribir directamente
///   DE PAGO -> abre PaymentScreen ('/payment', de Johana). Solo si esa
///              pantalla responde Navigator.pop(context, true) se inscribe.
class DetalleEventoScreen extends StatefulWidget {
  final int eventoId;
  final int usuarioId;

  const DetalleEventoScreen({super.key, required this.eventoId, this.usuarioId = 1});

  @override
  State<DetalleEventoScreen> createState() => _DetalleEventoScreenState();
}

class _DetalleEventoScreenState extends State<DetalleEventoScreen> {
  Evento? _evento;
  bool _inscrito = false;
  bool _cargando = true;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final db = DatabaseHelper.instance;
    final evento = await db.obtenerEvento(widget.eventoId);
    final inscripcion = await db.inscripcionActiva(widget.usuarioId, widget.eventoId);
    if (!mounted) return;
    setState(() {
      _evento = evento;
      _inscrito = inscripcion != null;
      _cargando = false;
    });
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _inscribirme() async {
    final e = _evento!;
    setState(() => _procesando = true);

    if (!e.esGratis) {
      // La inscripción NO se completa hasta que el pago sea exitoso.
      final pagado = await abrirRuta(context, '/payment', argumentos: e);
      if (pagado != true) {
        if (mounted) setState(() => _procesando = false);
        return;
      }
    }

    final error = await DatabaseHelper.instance.inscribir(widget.usuarioId, e.id);
    if (!mounted) return;
    setState(() => _procesando = false);

    if (error != null) {
      _mensaje(error);
      return;
    }
    await _cargar();
    if (!mounted) return;
    _mostrarInscripcionExitosa();
  }

  void _mostrarInscripcionExitosa() {
    final e = _evento!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ Inscripción exitosa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            filaInfo(Icons.calendar_today, formatoFecha(e.fechaHora)),
            filaInfo(Icons.access_time, formatoHora(e.fechaHora)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: const Text('Agregar a mi calendario'),
            onPressed: () {
              Navigator.pop(ctx);
              agregarAlCalendario(context, e);
            },
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
        backgroundColor: kPrimario,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _evento == null
              ? const Center(child: Text('Evento no encontrado'))
              : _contenido(_evento!),
      bottomNavigationBar: (_evento == null) ? null : _botones(_evento!),
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
        Text(e.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        filaInfo(Icons.calendar_today, formatoFecha(e.fechaHora)),
        filaInfo(Icons.access_time, formatoHora(e.fechaHora)),
        filaInfo(Icons.location_on, e.ubicacion),
        const Divider(height: 32),
        const Text('Descripción', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text(formatoPrecio(e.precio),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cupos', style: TextStyle(color: Colors.black54)),
                  Text('${e.cupos} disponibles',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        if (_inscrito) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Estado: INSCRITO ✅',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }

  Widget _botones(Evento e) {
    String textoBoton;
    if (_inscrito) {
      textoBoton = 'YA ESTÁS INSCRITO';
    } else if (e.cupos <= 0) {
      textoBoton = 'SIN CUPOS';
    } else if (e.esGratis) {
      textoBoton = 'INSCRIBIRME';
    } else {
      textoBoton = 'PAGAR ${formatoPrecio(e.precio)}';
    }
    final habilitado = !_inscrito && e.cupos > 0 && !_procesando;

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
                  backgroundColor: kPrimario,
                  foregroundColor: Colors.white,
                ),
                onPressed: habilitado ? _inscribirme : null,
                child: _procesando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(textoBoton),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Agregar a mi calendario'),
              onPressed: () => agregarAlCalendario(context, e),
            ),
          ],
        ),
      ),
    );
  }
}
