import 'package:flutter/material.dart';

// La misma barra se usa en las cuatro pantallas principales.
class BarraNavegacion extends StatelessWidget {
  final int indiceActual;

  const BarraNavegacion({super.key, required this.indiceActual});

  @override
  Widget build(BuildContext context) {
    const rutas = ['/home', '/mis-eventos', '/wallet/wallet', '/perfil'];

    return BottomNavigationBar(
      currentIndex: indiceActual,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF5B5FEF),
      onTap: (indice) {
        if (indice == indiceActual) return;

        // Cambiar de sección sin acumular pantallas en el botón Atrás.
        Navigator.pushNamedAndRemoveUntil(
          context,
          rutas[indice],
          (route) => false,
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.celebration),
          label: 'Mis eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Billetera',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
