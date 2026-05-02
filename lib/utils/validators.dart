/// Biblioteca centralizada de validações do AJUDA 192
/// Todas as validações de formulário do app ficam aqui.
class Validators {
  Validators._(); // Impede instanciação

  // ─── Nome ────────────────────────────────────────────────────────────────

  /// Valida nome completo (mínimo nome + sobrenome).
  static String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
    final partes = valor.trim().split(RegExp(r'\s+'));
    if (partes.length < 2) {
      return 'Informe nome e sobrenome';
    }
    if (partes.any((p) => p.length < 2)) {
      return 'Cada parte do nome deve ter ao menos 2 letras';
    }
    final apenasLetras = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");
    if (!apenasLetras.hasMatch(valor.trim())) {
      return 'O nome não pode conter números ou símbolos especiais';
    }
    return null;
  }

  // ─── E-mail ───────────────────────────────────────────────────────────────

  /// Valida formato de e-mail.
  static String? validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu e-mail';
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(valor.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  // ─── Senha ────────────────────────────────────────────────────────────────

  /// Valida força mínima da senha (≥ 6 caracteres).
  static String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Crie uma senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter ao menos 6 caracteres';
    }
    return null;
  }

  /// Valida a confirmação de senha.
  static String? validarConfirmacaoSenha(String? valor, String senhaOriginal) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha';
    }
    if (valor != senhaOriginal) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  /// Valida senha no contexto de login (só verifica preenchimento).
  static String? validarSenhaLogin(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe sua senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter ao menos 6 caracteres';
    }
    return null;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Retorna true se o e-mail tiver formato válido (sem mensagem de erro).
  static bool emailValido(String email) => validarEmail(email) == null;

  /// Retorna true se a senha atender ao critério mínimo.
  static bool senhaValida(String senha) => validarSenha(senha) == null;
}
