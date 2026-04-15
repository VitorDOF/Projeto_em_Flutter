import 'package:flutter/material.dart';
import 'home_page.dart';

class TelaCadastro extends StatefulWidget {
  final VoidCallback aoAlternarTema;
  final bool isModoEscuro;

  const TelaCadastro({
    super.key,
    required this.aoAlternarTema,
    required this.isModoEscuro,
  });

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _obscureSenha = true;
  bool _obscureConfirmar = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _toggleSenha() => setState(() => _obscureSenha = !_obscureSenha);
  void _toggleConfirmar() => setState(() => _obscureConfirmar = !_obscureConfirmar);

  void _submeterCadastro() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            aoAlternarTema: widget.aoAlternarTema,
            isModoEscuro: widget.isModoEscuro,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquemaCores = tema.colorScheme;
    final isDark = widget.isModoEscuro;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              esquemaCores.surface,
              isDark
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _construirCabecalho(esquemaCores),
                      const SizedBox(height: 8),
                      _construirSubtitulo(tema),
                      const SizedBox(height: 32),
                      _construirCampoNome(esquemaCores),
                      const SizedBox(height: 16),
                      _construirCampoEmail(esquemaCores),
                      const SizedBox(height: 16),
                      _construirCampoSenha(esquemaCores),
                      const SizedBox(height: 16),
                      _construirCampoConfirmarSenha(esquemaCores),
                      const SizedBox(height: 28),
                      _construirBotaoCadastrar(),
                      const SizedBox(height: 20),
                      _construirRodape(tema, esquemaCores),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirCabecalho(ColorScheme esquemaCores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botão voltar
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: esquemaCores.primary),
        ),
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: esquemaCores.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_hospital,
                size: 48,
                color: esquemaCores.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AJUDA 192',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: esquemaCores.primary,
              ),
            ),
          ],
        ),
        // Espaço para alinhar o título ao centro
        IconButton(
          onPressed: widget.aoAlternarTema,
          icon: Icon(
            widget.isModoEscuro ? Icons.light_mode : Icons.dark_mode,
            color: esquemaCores.primary,
          ),
        ),
      ],
    );
  }

  Widget _construirSubtitulo(ThemeData tema) {
    return Text(
      'Crie sua conta para continuar',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: tema.textTheme.bodySmall?.color),
    );
  }

  Widget _construirCampoNome(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _nomeController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nome completo',
        prefixIcon: Icon(Icons.person_outline, color: esquemaCores.primary),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Informe seu nome completo';
        }
        if (valor.trim().split(' ').length < 2) {
          return 'Informe nome e sobrenome';
        }
        return null;
      },
    );
  }

  Widget _construirCampoEmail(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Seu e-mail',
        prefixIcon: Icon(Icons.email_outlined, color: esquemaCores.primary),
      ),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Informe seu e-mail';
        }
        final emailValido = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
        if (!emailValido.hasMatch(valor.trim())) {
          return 'E-mail inválido';
        }
        return null;
      },
    );
  }

  Widget _construirCampoSenha(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _senhaController,
      obscureText: _obscureSenha,
      decoration: InputDecoration(
        labelText: 'Crie uma senha',
        prefixIcon: Icon(Icons.lock_outline, color: esquemaCores.primary),
        suffixIcon: IconButton(
          onPressed: _toggleSenha,
          icon: Icon(
            _obscureSenha ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Crie uma senha';
        }
        if (valor.length < 6) {
          return 'A senha deve ter ao menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _construirCampoConfirmarSenha(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _confirmarSenhaController,
      obscureText: _obscureConfirmar,
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        prefixIcon: Icon(Icons.lock_outline, color: esquemaCores.primary),
        suffixIcon: IconButton(
          onPressed: _toggleConfirmar,
          icon: Icon(
            _obscureConfirmar ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Confirme sua senha';
        }
        if (valor != _senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _construirBotaoCadastrar() {
    return ElevatedButton(
      onPressed: _submeterCadastro,
      child: const Text('Criar minha conta'),
    );
  }

  Widget _construirRodape(ThemeData tema, ColorScheme esquemaCores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta? ',
          style: TextStyle(color: tema.textTheme.bodySmall?.color),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Entrar',
            style: TextStyle(color: esquemaCores.primary),
          ),
        ),
      ],
    );
  }
}