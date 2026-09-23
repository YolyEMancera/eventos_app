import 'package:flutter_test/flutter_test.dart';
import 'package:eventos_app/main.dart';

void main() {
  testWidgets('La aplicación de eventos inicia correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EventosApp());

    expect(find.text('CREAR CUENTA'), findsOneWidget);
  });
}