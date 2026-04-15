import 'package:flutter/material.dart';
import 'telas/login_tela.dart';
import 'telas/home_page.dart';
import 'themes.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  bool _isModoEscuro = false;

  void _alternarTema() {
    setState(() {
      _isModoEscuro = !_isModoEscuro;
    });
  }

  bool _estaLogado = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAMU 192',
      debugShowCheckedModeBanner: false,
      theme: AppTemas.temaClaro(),
      darkTheme: AppTemas.temaEscuro(),
      themeMode: _isModoEscuro ? ThemeMode.dark : ThemeMode.light,
      home: _estaLogado
          ? HomePage(
        aoAlternarTema: _alternarTema,
        isModoEscuro: _isModoEscuro,
      )
          : TelaLogin(
        aoAlternarTema: _alternarTema,
        isModoEscuro: _isModoEscuro,
      ),
    );
  }
}