import "package:geolocator/geolocator.dart";

/// Resultado encapsulado da busca de localização.
class ResultadoLocalizacao {
  final Position? posicao;
  final String? erro;
  final bool sucesso;

  const ResultadoLocalizacao._({
    this.posicao,
    this.erro,
    required this.sucesso,
  });

  factory ResultadoLocalizacao.sucesso(Position posicao) =>
      ResultadoLocalizacao._(posicao: posicao, sucesso: true);

  factory ResultadoLocalizacao.falha(String mensagem) =>
      ResultadoLocalizacao._(erro: mensagem, sucesso: false);
}

/// Serviço responsável por obter a localização GPS do usuário.
class LocalizacaoServico {
  /// Obtém a localização atual do dispositivo.
  /// Solicita permissão se necessário.
  Future<ResultadoLocalizacao> obterLocalizacaoAtual() async {
    // 1. Verifica se o serviço de localização está ativo
    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      return ResultadoLocalizacao.falha(
        'Serviço de localização desativado. Ative o GPS nas configurações.',
      );
    }

    // 2. Verifica/solicita permissão
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return ResultadoLocalizacao.falha(
          'Permissão de localização negada.',
        );
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      return ResultadoLocalizacao.falha(
        'Permissão negada permanentemente. Ative nas configurações do app.',
      );
    }

    // 3. Obtém a posição
    try {
      final posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      return ResultadoLocalizacao.sucesso(posicao);
    } catch (e) {
      return ResultadoLocalizacao.falha(
        'Não foi possível obter a localização: $e',
      );
    }
  }

  /// Converte coordenadas em texto legível (ex: "Lat: -15.78, Lng: -47.93").
  String formatarCoordenadas(Position posicao) {
    return 'Lat: ${posicao.latitude.toStringAsFixed(4)}, '
        'Lng: ${posicao.longitude.toStringAsFixed(4)}';
  }
}
