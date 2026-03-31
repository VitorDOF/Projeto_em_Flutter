import 'package:flutter/material.dart';
import 'home_page.dart';

class TelaLogin extends StatefulWidget {
  final VoidCallback aoAlternarTema;
  final bool isModoEscuro;

  const TelaLogin({
    super.key,
    required this.aoAlternarTema,
    required this.isModoEscuro,
  });

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // 1. Adicionar a chave do formulário
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Controle para ver/ocultar senha
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Método para alternar visibilidade da senha
  void _toggleVisibilidadeSenha() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquemaCores = tema.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              esquemaCores.background,
              widget.isModoEscuro
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                // 2. Envolver a Column principal com Form
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _construirCabecalho(tema, esquemaCores),
                      const SizedBox(height: 16),
                      _construirSubtitulo(tema),
                      const SizedBox(height: 32),
                      _construirCampoEmail(esquemaCores),
                      const SizedBox(height: 16),
                      _construirCampoSenha(esquemaCores),
                      const SizedBox(height: 8),
                      _construirEsqueciSenha(esquemaCores),
                      const SizedBox(height: 16),
                      _construirBotaoEntrar(),
                      const SizedBox(height: 20),
                      _construirDivisorOu(tema),
                      const SizedBox(height: 20),
                      _construirBotaoGoogle(tema, esquemaCores),
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

  Widget _construirCabecalho(ThemeData tema, ColorScheme esquemaCores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: esquemaCores.primary.withOpacity(0.1),
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
      'Serviço de Atendimento Móvel de Urgência',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: tema.textTheme.bodySmall?.color),
    );
  }

  // 3. Trocar TextField para TextFormField com validator
  Widget _construirCampoEmail(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Seu e-mail',
        prefixIcon: Icon(Icons.email_outlined, color: esquemaCores.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Informe seu e-mail';
        }
        // Regex simples de e-mail
        final emailValido = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
        if (!emailValido.hasMatch(valor.trim())) {
          return 'E-mail inválido';
        }
        return null;
      },
    );
  }

  // 3. Trocar TextField para TextFormField com validator
  Widget _construirCampoSenha(ColorScheme esquemaCores) {
    return TextFormField(
      controller: _senhaController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Sua senha',
        prefixIcon: Icon(Icons.lock_outline, color: esquemaCores.primary),
        suffixIcon: IconButton(
          onPressed: _toggleVisibilidadeSenha,
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Informe sua senha';
        }
        if (valor.length < 6) {
          return 'A senha deve ter ao menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _construirEsqueciSenha(ColorScheme esquemaCores) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Esqueci minha senha',
          style: TextStyle(color: esquemaCores.primary),
        ),
      ),
    );
  }

  // 4. Atualizar o botão Entrar para validar antes de navegar
  Widget _construirBotaoEntrar() {
    return ElevatedButton(
      onPressed: () {
        // ✅ Só navega se todos os campos forem válidos
        if (_formKey.currentState!.validate()) {
          print('Email: ${_emailController.text}');
          print('Senha: ${_senhaController.text}');

          // Navegar para HomePage
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
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Entrar na minha conta'),
    );
  }

  Widget _construirDivisorOu(ThemeData tema) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou',
            style: TextStyle(color: tema.textTheme.bodySmall?.color),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _construirBotaoGoogle(ThemeData tema, ColorScheme esquemaCores) {
    return OutlinedButton.icon(
      onPressed: () {
        //login + Google
      },
      icon: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
        height: 24,
        width: 24,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.g_mobiledata, color: Colors.grey[600]),
          );
        },
      ),
      label: const Text('Continuar com Google'),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: tema.dividerColor),
        backgroundColor: tema.colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _construirRodape(ThemeData tema, ColorScheme esquemaCores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'Ainda não tem uma conta? ',
            style: TextStyle(color: tema.textTheme.bodySmall?.color),
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Navegar para cadastro
          },
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Criar uma conta',
              style: TextStyle(color: esquemaCores.primary),
            ),
          ),
        ),
      ],
    );
  }
}