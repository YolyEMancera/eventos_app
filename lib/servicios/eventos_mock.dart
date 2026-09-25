import 'evento.dart';

/// Muestras fijas de la primera entrega: no se consultan ni se modifican.
const conferenciaIaMock = Evento(
  nombre: 'Conferencia de Inteligencia Artificial',
  descripcion: 'Charla sobre el uso de la IA en la educación y en el desarrollo de software, con invitados de la industria.',
  categoria: 'Tecnología',
  fecha: '2 de octubre de 2026',
  hora: '10:00 a.m.',
  ubicacion: 'Auditorio principal',
  precio: 'Gratis',
  cupos: 80,
);

const tallerFlutterMock = Evento(
  nombre: 'Taller de Flutter',
  descripcion: 'Taller práctico para crear tu primera aplicación móvil con Flutter y Dart.',
  categoria: 'Tecnología',
  fecha: '5 de octubre de 2026',
  hora: '2:00 p.m.',
  ubicacion: 'Sala de sistemas 3',
  precio: '\$15.000',
  cupos: 25,
);

const hackathonMock = Evento(
  nombre: 'Hackathon UNAD',
  descripcion: 'Competencia de 12 horas para resolver retos reales en equipos.',
  categoria: 'Tecnología',
  fecha: '10 de octubre de 2026',
  hora: '8:00 a.m.',
  ubicacion: 'Laboratorio de innovación',
  precio: 'Gratis',
  cupos: 8,
  disponibilidad: 'A punto de cerrar',
);

const voleibolMock = Evento(
  nombre: 'Campeonato de Voleibol',
  descripcion: 'Encuentro interfacultades de voleibol mixto.',
  categoria: 'Deportes',
  fecha: '1 de octubre de 2026',
  hora: '6:00 p.m.',
  ubicacion: 'Cancha Bloque 3',
  precio: 'Gratis',
  cupos: 30,
);

const futbolMock = Evento(
  nombre: 'Torneo universitario de fútbol',
  descripcion: 'Torneo relámpago de fútbol 5. La inscripción es individual.',
  categoria: 'Deportes',
  fecha: '4 de octubre de 2026',
  hora: '3:00 p.m.',
  ubicacion: 'Coliseo central',
  precio: '\$10.000',
  cupos: 40,
);

const carreraMock = Evento(
  nombre: 'Carrera atlética 5K',
  descripcion: 'Carrera recreativa por los alrededores del campus.',
  categoria: 'Deportes',
  fecha: '8 de octubre de 2026',
  hora: '7:00 a.m.',
  ubicacion: 'Entrada principal',
  precio: 'Gratis',
  cupos: 150,
);

const talentosMock = Evento(
  nombre: 'Noche de talentos',
  descripcion: 'Presentaciones musicales de estudiantes de todas las escuelas.',
  categoria: 'Música',
  fecha: '3 de octubre de 2026',
  hora: '7:00 p.m.',
  ubicacion: 'Auditorio B',
  precio: 'Gratis',
  cupos: 60,
);

const conciertoMock = Evento(
  nombre: 'Concierto acústico',
  descripcion:
      'Concierto universitario en formato acústico con artistas invitados.',
  categoria: 'Música',
  fecha: '6 de octubre de 2026',
  hora: '8:00 p.m.',
  ubicacion: 'Plaza central',
  precio: '\$20.000',
  cupos: 35,
);

const festivalMock = Evento(
  nombre: 'Festival universitario',
  descripcion: 'Festival con bandas locales, comida y actividades culturales.',
  categoria: 'Música',
  fecha: '12 de octubre de 2026',
  hora: '6:00 p.m.',
  ubicacion: 'Auditorio B',
  precio: '\$25.000',
  cupos: 100,
);

const eventosMock = [
  conferenciaIaMock,
  tallerFlutterMock,
  hackathonMock,
  voleibolMock,
  futbolMock,
  carreraMock,
  talentosMock,
  conciertoMock,
  festivalMock,
];

// Ejemplos que se muestran en la pantalla Mis eventos.
const misEventosMock = [conferenciaIaMock, conciertoMock];
