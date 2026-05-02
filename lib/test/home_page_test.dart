import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_em_flutter/telas/home_page.dart';

void main() {
  Widget _buildApp({bool modoEscuro = false}) {
    return MaterialApp(
      home: HomePage(
        aoAlternarTema: () {},
        isModoEscuro: modoEscuro,
      ),
    );
  }

  group('HomePage — estrutura da UI', () {
    testWidgets('exibe título AJUDA 192 na AppBar', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('AJUDA 192'), findsOneWidget);
    });

    testWidgets('exibe saudação de boas-vindas', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Bem-vindo de volta!'), findsOneWidget);
    });

    testWidgets('exibe botão de emergência 192', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('LIGAR PARA EMERGÊNCIA 192'), findsOneWidget);
    });

    testWidgets('exibe seção de Serviços Rápidos', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Serviços Rápidos'), findsOneWidget);
    });

    testWidgets('exibe cards de serviço', (tester) async {
      await tester.pumpWidget(_buildApp());
      // Aguarda carregamento do GPS (timeout simulado)
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Hospitais'), findsOneWidget);
      expect(find.text('Emergência'), findsOneWidget);
      expect(find.text('Ambulâncias'), findsOneWidget);
      expect(find.text('Farmácias'), findsOneWidget);
      expect(find.text('Contatos'), findsOneWidget);
      expect(find.text('Dicas'), findsOneWidget);
    });

    testWidgets('exibe seção de Hospitais Próximos', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Hospitais Próximos'), findsOneWidget);
    });

    testWidgets('exibe seção de Dicas de Saúde', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Dicas de Saúde'), findsOneWidget);
    });

    testWidgets('exibe ícone de modo escuro inicialmente', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('exibe ícone de modo claro em modo escuro', (tester) async {
      await tester.pumpWidget(_buildApp(modoEscuro: true));
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });
  });

  group('HomePage — interações', () {
    testWidgets('ícone de notificação está presente', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('ícone de perfil está presente', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('indicador de carregamento aparece para GPS', (tester) async {
      await tester.pumpWidget(_buildApp());
      // Logo após montar, está carregando
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });
}
