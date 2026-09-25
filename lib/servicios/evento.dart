// Los datos ya tienen el formato en que aparecen en la pantalla.
class Evento {
  final String nombre;
  final String descripcion;
  final String categoria;
  final String fecha;
  final String hora;
  final String ubicacion;
  final String precio;
  final int cupos;
  final String disponibilidad;

  const Evento({
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.fecha,
    required this.hora,
    required this.ubicacion,
    required this.precio,
    required this.cupos,
    this.disponibilidad = 'Disponible',
  });
}
