import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'detalle_evento_screen.dart';
import 'evento_card.dart';
import 'eventos_categoria_screen.dart';
import 'mis_eventos_screen.dart';

/// Pantalla 4 - Home: categorías, buscador y próximos eventos (RF-003).
class HomeScreen extends StatefulWidget {
  final int usuarioId;
  final String nombreUsuario;

  const HomeScreen({super.key, this.usuarioId = 1, this.nombreUsuario = 'Estudiante'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _busquedaCtrl = TextEditingController();
  List<Evento> _proximos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final lista = await DatabaseHelper.instance.obtenerProximosEventos(limite: 5);
    if (!mounted) return;
    setState(() {
      _proximos = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirCategoria(String? categoria, {String busqueda = ''}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventosCategoriaScreen(
          categoria: categoria,
          busquedaInicial: busqueda,
          usuarioId: widget.usuarioId,
        ),
      ),
    );
    _cargar();
  }

  Future<void> _abrirDetalle(Evento e) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleEventoScreen(eventoId: e.id, usuarioId: widget.usuarioId),
      ),
    );
    _cargar();
  }

  Future<void> _onNavegar(int indice) async {
    switch (indice) {
      case 1:
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MisEventosScreen(usuarioId: widget.usuarioId)),
        );
        _cargar();
        break;
      case 2:
        abrirRuta(context, '/wallet/wallet'); // pantalla de Johana
        break;
      case 3:
        abrirRuta(context, '/perfil'); // pantalla de Yoly
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F8),
      body: RefreshIndicator(
        onRefresh: _cargar,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _encabezado(context),
            const SizedBox(height: 16),
            _categorias(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 4),
              child: Row(
                children: [
                  const Text('Próximos eventos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _abrirCategoria(null),
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
            ),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_proximos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No hay eventos próximos')),
              )
            else
              ..._proximos.map((e) => EventoCard(evento: e, onTap: () => _abrirDetalle(e))),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimario,
        onTap: _onNavegar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.celebration), label: 'Mis eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Billetera'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _encabezado(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 24, 20, 28),
      decoration: const BoxDecoration(
        color: kPrimario,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Hola, ${widget.nombreUsuario}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: kPrimario),
                  onPressed: () => abrirRuta(context, '/notifications'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('¿Qué evento deseas descubrir hoy?',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          TextField(
            controller: _busquedaCtrl,
            textInputAction: TextInputAction.search,
            onSubmitted: (texto) => _abrirCategoria(null, busqueda: texto),
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

  Widget _categorias() {
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
          const Text('Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _itemCategoria('Tecnología'),
              _itemCategoria('Deportes'),
              _itemCategoria('Música'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemCategoria(String categoria) {
    final color = colorCategoria(categoria);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _abrirCategoria(categoria),
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
            Text(categoria),
          ],
        ),
      ),
    );
  }
}
