import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_em_flutter/telas/cadastro_tela.dart';
void main() {
  Widget _buildApp() {
    return MaterialApp(
      home: TelaCadastro(
        aoAlternarTema: () {},
        isModoEscuro: false,
      ),
    );
  }

  group('TelaCadastro — estrutura da UI', () {
    testWidgets('exibe logo e título AJUDA 192', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('AJUDA 192'), findsOneWidget);
    });

    testWidgets('exibe os 4 campos do formulário', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Nome completo'), findsOneWidget);
      expect(find.text('Seu e-mail'), findsOneWidget);
      expect(find.text('Crie uma senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsOneWidget);
    });

    testWidgets('exibe botão de criar conta', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Criar minha conta'), findsOneWidget);
    });

    testWidgets('exibe link para voltar ao login', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Entrar'), findsOneWidget);
    });
  });

  group('TelaCadastro — validação', () {
    testWidgets('exibe todos os erros ao submeter vazio', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('Informe seu nome completo'), findsOneWidget);
      expect(find.text('Informe seu e-mail'), findsOneWidget);
      expect(find.text('Informe uma senha'), findsOneWidget);
      expect(find.text('Confirme sua senha'), findsOneWidget);
    });

    testWidgets('exibe erro de nome incompleto', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), 'Maria');
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('Informe nome e sobrenome'), findsOneWidget);
    });

    testWidgets('exibe erro de e-mail inválido', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), 'Maria Silva');
      await tester.enterText(campos.at(1), 'emailruim');
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('exibe erro de senha curta', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), 'Maria Silva');
      await tester.enterText(campos.at(1), 'ok@ok.com');
      await tester.enterText(campos.at(2), '123');
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('A senha deve ter ao menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('exibe erro quando senhas não coincidem', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), 'Maria Silva');
      await tester.enterText(campos.at(1), 'ok@ok.com');
      await tester.enterText(campos.at(2), '123456');
      await tester.enterText(campos.at(3), '654321');
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('As senhas não coincidem'), findsOneWidget);
    });

    testWidgets('não exibe erros com dados válidos', (tester) async {
      await tester.pumpWidget(_buildApp());
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), 'Maria Silva');
      await tester.enterText(campos.at(1), 'maria@email.com');
      await tester.enterText(campos.at(2), '123456');
      await tester.enterText(campos.at(3), '123456');
      await tester.tap(find.text('Criar minha conta'));
      await tester.pump();

      expect(find.text('Informe seu nome completo'), findsNothing);
      expect(find.text('E-mail inválido'), findsNothing);
      expect(find.text('As senhas não coincidem'), findsNothing);
    });
  });

  group('TelaCadastro — interações', () {
    testWidgets('toggles de senha funcionam', (tester) async {
      await tester.pumpWidget(_buildApp());
      final olhosOcultos = find.byIcon(Icons.visibility_off);
      // Inicialmente há 2 ícones de senha oculta
      expect(olhosOcultos, findsNWidgets(2));

      await tester.tap(olhosOcultos.first);
      await tester.pump();
      // Após tap: 1 oculto + 1 visível
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
