import 'package:flutter/material.dart';

import 'evento.dart';
import 'eventos_mock.dart';
import 'detalle_evento_screen.dart';
import 'evento_card.dart';

// Catálogo de ejemplo. El buscador es solo visual en esta entrega.
class EventosCategoriaScreen extends StatelessWidget {
  final String categoria;

  const EventosCategoriaScreen({
    super.key,
    this.categoria = 'Todos los eventos',
  });

  void _abrirDetalle(BuildContext context, Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleEventoScreen(evento: evento)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Elegir los ejemplos de la categoría que se abrió.
    final List<Evento> eventos = [];
    for (final evento in eventosMock) {
      if (categoria == 'Todos los eventos' || evento.categoria == categoria) {
        eventos.add(evento);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      appBar: AppBar(
        title: Text(categoria),
        backgroundColor: colorPrimario,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Encuentra eventos para ti',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => mostrarDemo(
                    context,
                    'Búsqueda de ejemplo',
                    'El catálogo muestra datos de ejemplo. La búsqueda estará disponible en una próxima entrega.',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos...',
                    helperText: 'Vista de ejemplo · búsqueda no disponible',
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
              child: Text(
                'Eventos disponibles (${eventos.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: eventos.isEmpty
                ? const Center(child: Text('No se encontraron eventos'))
                : ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, i) => EventoCard(
                      evento: eventos[i],
                      onTap: () => _abrirDetalle(context, eventos[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
