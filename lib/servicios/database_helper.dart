import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// ===============================================================
///  MODELOS
/// ===============================================================

class Evento {
  final int id;
  final String nombre;
  final String descripcion;
  final String categoria; // Tecnología | Deportes | Música
  final String fecha; // formato yyyy-MM-dd
  final String hora; // formato HH:mm (24 h)
  final String ubicacion;
  final double precio; // 0 = gratis
  final int cupos;

  Evento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.fecha,
    required this.hora,
    required this.ubicacion,
    required this.precio,
    required this.cupos,
  });

  bool get esGratis => precio <= 0;

  DateTime get fechaHora => DateTime.parse('${fecha}T$hora:00');

  /// Regla de negocio: solo se cancela con al menos 24 horas de antelación.
  bool get cancelable =>
      fechaHora.difference(DateTime.now()) >= const Duration(hours: 24);

  factory Evento.fromMap(Map<String, dynamic> m) => Evento(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        descripcion: m['descripcion'] as String,
        categoria: m['categoria'] as String,
        fecha: m['fecha'] as String,
        hora: m['hora'] as String,
        ubicacion: m['ubicacion'] as String,
        precio: (m['precio'] as num).toDouble(),
        cupos: m['cupos'] as int,
      );
}

class InscripcionDetalle {
  final int inscripcionId;
  final String estado;
  final String fechaInscripcion;
  final Evento evento;

  InscripcionDetalle({
    required this.inscripcionId,
    required this.estado,
    required this.fechaInscripcion,
    required this.evento,
  });
}

/// ===============================================================
///  BASE DE DATOS SQLite - EventosU
///  USUARIO ── BILLETERA ── MOVIMIENTO
///     └──── INSCRIPCION ──── EVENTO
/// ===============================================================

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), 'eventosu.db');
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await _crearTablas(db);
        await _insertarEventosDemo(db);
      },
    );
  }

  Future<void> _crearTablas(Database db) async {
    // --- Tablas de Yoly y Johana (se dejan para que el esquema esté completo) ---
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        fotoPerfil TEXT
      )''');
    await db.execute('''
      CREATE TABLE billetera (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        saldo REAL NOT NULL DEFAULT 0,
        FOREIGN KEY (usuarioId) REFERENCES usuario(id)
      )''');
    await db.execute('''
      CREATE TABLE movimiento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billeteraId INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        valor REAL NOT NULL,
        fecha TEXT NOT NULL,
        descripcion TEXT,
        FOREIGN KEY (billeteraId) REFERENCES billetera(id)
      )''');

    // --- Tablas de Deisy: EVENTO e INSCRIPCION ---
    await db.execute('''
      CREATE TABLE evento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        ubicacion TEXT NOT NULL,
        precio REAL NOT NULL DEFAULT 0,
        cupos INTEGER NOT NULL
      )''');
    await db.execute('''
      CREATE TABLE inscripcion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        eventoId INTEGER NOT NULL,
        fechaInscripcion TEXT NOT NULL,
        estado TEXT NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuario(id),
        FOREIGN KEY (eventoId) REFERENCES evento(id)
      )''');
  }

  /// Eventos de ejemplo. Las fechas se calculan desde el día en que se
  /// instala la app, para que siempre haya eventos "próximos".
  Future<void> _insertarEventosDemo(Database db) async {
    final hoy = DateTime.now();
    String dia(int n) {
      final d = hoy.add(Duration(days: n));
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final eventos = <Map<String, Object>>[
      {'nombre': 'Conferencia de Inteligencia Artificial', 'descripcion': 'Charla sobre el uso de la IA en la educación y en el desarrollo de software, con invitados de la industria.', 'categoria': 'Tecnología', 'fecha': dia(2), 'hora': '10:00', 'ubicacion': 'Auditorio principal', 'precio': 0, 'cupos': 80},
      {'nombre': 'Taller de Flutter', 'descripcion': 'Taller práctico para crear tu primera aplicación móvil con Flutter y Dart.', 'categoria': 'Tecnología', 'fecha': dia(5), 'hora': '14:00', 'ubicacion': 'Sala de sistemas 3', 'precio': 15000, 'cupos': 25},
      {'nombre': 'Hackathon UNAD', 'descripcion': 'Competencia de 12 horas para resolver retos reales en equipos.', 'categoria': 'Tecnología', 'fecha': dia(10), 'hora': '08:00', 'ubicacion': 'Laboratorio de innovación', 'precio': 0, 'cupos': 8},
      {'nombre': 'Campeonato de Voleibol', 'descripcion': 'Encuentro interfacultades de voleibol mixto.', 'categoria': 'Deportes', 'fecha': dia(1), 'hora': '18:00', 'ubicacion': 'Cancha Bloque 3', 'precio': 0, 'cupos': 30},
      {'nombre': 'Torneo universitario de fútbol', 'descripcion': 'Torneo relámpago de fútbol 5. La inscripción es individual.', 'categoria': 'Deportes', 'fecha': dia(4), 'hora': '15:00', 'ubicacion': 'Coliseo central', 'precio': 10000, 'cupos': 40},
      {'nombre': 'Carrera atlética 5K', 'descripcion': 'Carrera recreativa por los alrededores del campus.', 'categoria': 'Deportes', 'fecha': dia(8), 'hora': '07:00', 'ubicacion': 'Entrada principal', 'precio': 0, 'cupos': 150},
      {'nombre': 'Noche de talentos', 'descripcion': 'Presentaciones musicales de estudiantes de todas las escuelas.', 'categoria': 'Música', 'fecha': dia(3), 'hora': '19:00', 'ubicacion': 'Auditorio B', 'precio': 0, 'cupos': 60},
      {'nombre': 'Concierto acústico', 'descripcion': 'Concierto universitario en formato acústico con artistas invitados.', 'categoria': 'Música', 'fecha': dia(6), 'hora': '20:00', 'ubicacion': 'Plaza central', 'precio': 20000, 'cupos': 35},
      {'nombre': 'Festival universitario', 'descripcion': 'Festival con bandas locales, comida y actividades culturales.', 'categoria': 'Música', 'fecha': dia(12), 'hora': '18:00', 'ubicacion': 'Auditorio B', 'precio': 25000, 'cupos': 100},
    ];

    final batch = db.batch();
    for (final e in eventos) {
      batch.insert('evento', e);
    }
    await batch.commit(noResult: true);
  }

  // =============================================================
  //  RF-003  Buscar eventos
  // =============================================================
  Future<List<Evento>> obtenerEventos({String? categoria, String busqueda = ''}) async {
    final db = await database;
    final condiciones = <String>[];
    final argumentos = <Object>[];

    if (categoria != null) {
      condiciones.add('categoria = ?');
      argumentos.add(categoria);
    }
    if (busqueda.trim().isNotEmpty) {
      final b = '%${busqueda.trim()}%';
      condiciones.add('(nombre LIKE ? OR descripcion LIKE ? OR ubicacion LIKE ?)');
      argumentos.addAll([b, b, b]);
    }

    final filas = await db.query(
      'evento',
      where: condiciones.isEmpty ? null : condiciones.join(' AND '),
      whereArgs: argumentos.isEmpty ? null : argumentos,
      orderBy: 'fecha, hora',
    );
    return filas.map((f) => Evento.fromMap(f)).toList();
  }

  Future<List<Evento>> obtenerProximosEventos({int limite = 5}) async {
    final db = await database;
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    final filas = await db.query(
      'evento',
      where: 'fecha >= ?',
      whereArgs: [hoy],
      orderBy: 'fecha, hora',
      limit: limite,
    );
    return filas.map((f) => Evento.fromMap(f)).toList();
  }

  Future<Evento?> obtenerEvento(int id) async {
    final db = await database;
    final filas = await db.query('evento', where: 'id = ?', whereArgs: [id]);
    return filas.isEmpty ? null : Evento.fromMap(filas.first);
  }

  /// Devuelve el id de la inscripción activa, o null si no está inscrito.
  Future<int?> inscripcionActiva(int usuarioId, int eventoId) async {
    final db = await database;
    final filas = await db.query(
      'inscripcion',
      where: 'usuarioId = ? AND eventoId = ? AND estado = ?',
      whereArgs: [usuarioId, eventoId, 'INSCRITO'],
    );
    return filas.isEmpty ? null : filas.first['id'] as int;
  }

  // =============================================================
  //  RF-004  Inscribirse a un evento
  //  Devuelve null si salió bien, o un mensaje de error.
  // =============================================================
  Future<String?> inscribir(int usuarioId, int eventoId) async {
    final db = await database;
    return db.transaction<String?>((txn) async {
      final ev = await txn.query('evento', where: 'id = ?', whereArgs: [eventoId]);
      if (ev.isEmpty) return 'El evento no existe';

      final cupos = ev.first['cupos'] as int;
      if (cupos <= 0) return 'No hay cupos disponibles';

      final ya = await txn.query(
        'inscripcion',
        where: 'usuarioId = ? AND eventoId = ? AND estado = ?',
        whereArgs: [usuarioId, eventoId, 'INSCRITO'],
      );
      if (ya.isNotEmpty) return 'Ya estás inscrito en este evento';

      await txn.insert('inscripcion', {
        'usuarioId': usuarioId,
        'eventoId': eventoId,
        'fechaInscripcion': DateTime.now().toIso8601String(),
        'estado': 'INSCRITO',
      });
      await txn.update('evento', {'cupos': cupos - 1},
          where: 'id = ?', whereArgs: [eventoId]);
      return null;
    });
  }

  // =============================================================
  //  RF-005  Cancelar inscripción (mínimo 24 h antes)
  // =============================================================
  Future<String?> cancelarInscripcion(int inscripcionId) async {
    final db = await database;
    return db.transaction<String?>((txn) async {
      final filas = await txn.rawQuery('''
        SELECT i.eventoId, i.estado, e.fecha, e.hora
        FROM inscripcion i JOIN evento e ON e.id = i.eventoId
        WHERE i.id = ?''', [inscripcionId]);
      if (filas.isEmpty) return 'La inscripción no existe';

      final f = filas.first;
      if (f['estado'] != 'INSCRITO') return 'La inscripción ya estaba cancelada';

      final inicio = DateTime.parse('${f['fecha']}T${f['hora']}:00');
      if (inicio.difference(DateTime.now()) < const Duration(hours: 24)) {
        return 'Solo puedes cancelar con al menos 24 horas de antelación';
      }

      await txn.update('inscripcion', {'estado': 'CANCELADO'},
          where: 'id = ?', whereArgs: [inscripcionId]);
      await txn.rawUpdate(
          'UPDATE evento SET cupos = cupos + 1 WHERE id = ?', [f['eventoId']]);
      return null;
    });
  }

  // =============================================================
  //  RF-006  Ver eventos inscritos
  // =============================================================
  Future<List<InscripcionDetalle>> obtenerMisEventos(int usuarioId) async {
    final db = await database;
    final filas = await db.rawQuery('''
      SELECT e.*, i.id AS inscripcionId, i.estado AS estadoInscripcion,
             i.fechaInscripcion
      FROM inscripcion i JOIN evento e ON e.id = i.eventoId
      WHERE i.usuarioId = ? AND i.estado = 'INSCRITO'
      ORDER BY e.fecha, e.hora''', [usuarioId]);

    return filas
        .map((f) => InscripcionDetalle(
              inscripcionId: f['inscripcionId'] as int,
              estado: f['estadoInscripcion'] as String,
              fechaInscripcion: f['fechaInscripcion'] as String,
              evento: Evento.fromMap(f),
            ))
        .toList();
  }
}
