import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'detalle_evento_screen.dart';
import 'evento_card.dart';

/// Pantalla 5 - Eventos por categoría + búsqueda (RF-003).
/// El contenido cambia según la categoría recibida (null = todas).
class EventosCategoriaScreen extends StatefulWidget {
  final String? categoria;
  final String busquedaInicial;
  final int usuarioId;

  const EventosCategoriaScreen({
    super.key,
    this.categoria,
    this.busquedaInicial = '',
    this.usuarioId = 1,
  });

  @override
  State<EventosCategoriaScreen> createState() => _EventosCategoriaScreenState();
}

class _EventosCategoriaScreenState extends State<EventosCategoriaScreen> {
  late final TextEditingController _busquedaCtrl;
  List<Evento> _eventos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _busquedaCtrl = TextEditingController(text: widget.busquedaInicial);
    _cargar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final lista = await DatabaseHelper.instance.obtenerEventos(
      categoria: widget.categoria,
      busqueda: _busquedaCtrl.text,
    );
    if (!mounted) return;
    setState(() {
      _eventos = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirDetalle(Evento e) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleEventoScreen(eventoId: e.id, usuarioId: widget.usuarioId),
      ),
    );
    _cargar(); // refresca cupos al volver
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.categoria ?? 'Todos los eventos';
    final subtitulo = widget.categoria == null
        ? 'Encuentra todos los eventos'
        : 'Encuentra eventos de ${widget.categoria!.toLowerCase()}';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: kPrimario,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitulo,
                    style: const TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 12),
                TextField(
                  controller: _busquedaCtrl,
                  onChanged: (_) => _cargar(),
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Eventos disponibles (${_eventos.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _eventos.isEmpty
                    ? const Center(child: Text('No se encontraron eventos'))
                    // ListView.builder = equivalente en Flutter al RecyclerView
                    : ListView.builder(
                        itemCount: _eventos.length,
                        itemBuilder: (context, i) => EventoCard(
                          evento: _eventos[i],
                          onTap: () => _abrirDetalle(_eventos[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
