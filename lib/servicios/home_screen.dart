import 'package:flutter/material.dart';

import '../barra_navegacion.dart';
import 'evento.dart';
import 'eventos_mock.dart';
import 'detalle_evento_screen.dart';
import 'evento_card.dart';
import 'eventos_categoria_screen.dart';

/// Inicio del prototipo con categorías y eventos de ejemplo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirCategoria(BuildContext context, String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventosCategoriaScreen(categoria: categoria),
      ),
    );
  }

  void _abrirDetalle(BuildContext context, Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleEventoScreen(evento: evento)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _encabezado(context),
          const SizedBox(height: 16),
          _categorias(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Próximos eventos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _abrirCategoria(context, 'Todos los eventos'),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
          ),
          for (final evento in eventosMock)
            EventoCard(
              evento: evento,
              onTap: () => _abrirDetalle(context, evento),
            ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const BarraNavegacion(indiceActual: 0),
    );
  }

  Widget _encabezado(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 24,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        color: colorPrimario,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hola, Estudiante',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: colorPrimario),
                  onPressed: () => mostrarDemo(
                    context,
                    'Notificaciones',
                    'No tienes notificaciones en esta demostración.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '¿Qué evento deseas descubrir hoy?',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (texto) =>
                _abrirCategoria(context, 'Todos los eventos'),
            decoration: InputDecoration(
              hintText: 'Buscar eventos...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categorias(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorías',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _itemCategoria(context, 'Tecnología')),
              Expanded(child: _itemCategoria(context, 'Deportes')),
              Expanded(child: _itemCategoria(context, 'Música')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemCategoria(BuildContext context, String categoria) {
    final color = colorCategoria(categoria);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _abrirCategoria(context, categoria),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withAlpha(40),
              child: Icon(iconoCategoria(categoria), color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(categoria, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
