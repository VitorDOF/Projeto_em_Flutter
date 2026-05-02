import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_em_flutter/telas/login_tela.dart';

void main() {
  Widget _buildApp({bool modoEscuro = false}) {
    return MaterialApp(
      home: TelaLogin(
        aoAlternarTema: () {},
        isModoEscuro: modoEscuro,
      ),
    );
  }

  group('TelaLogin — estrutura da UI', () {
    testWidgets('exibe logo e título AJUDA 192', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('AJUDA 192'), findsOneWidget);
      expect(find.byIcon(Icons.local_hospital), findsOneWidget);
    });

    testWidgets('exibe campos de e-mail e senha', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Seu e-mail'), findsOneWidget);
      expect(find.text('Sua senha'), findsOneWidget);
    });

    testWidgets('exibe botão de entrar', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Entrar na minha conta'), findsOneWidget);
    });

    testWidgets('exibe link para cadastro', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Criar uma conta'), findsOneWidget);
    });

    testWidgets('exibe botão de continuar com Google', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Continuar com Google'), findsOneWidget);
    });

    testWidgets('ícone de tema está presente', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('ícone de tema muda no modo escuro', (tester) async {
      await tester.pumpWidget(_buildApp(modoEscuro: true));
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });
  });

  group('TelaLogin — validação de formulário', () {
    testWidgets('exibe erros ao submeter formulário vazio', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.tap(find.text('Entrar na minha conta'));
      await tester.pump();

      expect(find.text('Informe seu e-mail'), findsOneWidget);
      expect(find.text('Informe sua senha'), findsOneWidget);
    });

    testWidgets('exibe erro de e-mail inválido', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextFormField).first, 'emailinvalido');
      await tester.tap(find.text('Entrar na minha conta'));
      await tester.pump();

      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('exibe erro de senha curta', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.first, 'ok@ok.com');
      await tester.enterText(campos.last, '123');
      await tester.tap(find.text('Entrar na minha conta'));
      await tester.pump();

      expect(find.text('A senha deve ter ao menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('não exibe erros com dados válidos', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.first, 'usuario@gmail.com');
      await tester.enterText(campos.last, 'minhasenha');
      await tester.tap(find.text('Entrar na minha conta'));
      await tester.pump();

      expect(find.text('Informe seu e-mail'), findsNothing);
      expect(find.text('Informe sua senha'), findsNothing);
    });
  });

  group('TelaLogin — interações', () {
    testWidgets('toggle de visibilidade da senha funciona', (tester) async {
      await tester.pumpWidget(_buildApp());
      // Ícone inicial: olho fechado
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Após tap: olho aberto
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
