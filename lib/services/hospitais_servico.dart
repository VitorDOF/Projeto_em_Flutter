import 'dart:math';

/// Modelo de hospital.
class Hospital {
  final String id;
  final String nome;
  final String endereco;
  final double latitude;
  final double longitude;
  final bool emergencia24h;
  final String horario;
  final String telefone;
  double? distanciaKm;

  Hospital({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    required this.emergencia24h,
    required this.horario,
    required this.telefone,
    this.distanciaKm,
  });

  String get distanciaFormatada {
    if (distanciaKm == null) return '—';
    if (distanciaKm! < 1) {
      return '${(distanciaKm! * 1000).toStringAsFixed(0)} m';
    }
    return '${distanciaKm!.toStringAsFixed(1)} km';
  }
}

/// Serviço que busca hospitais próximos à posição do usuário.
/// Em produção, substitua [_hospitaisFixos] por chamada à API (ex: Google Places).
class HospitaisServico {
  /// Dados mockados — substitua por integração real com API.
  final List<Hospital> _hospitaisFixos = [
    Hospital(
      id: '1',
      nome: 'Hospital de Urgências de Goiânia (HUGO)',
      endereco: 'Av. Anhanguera, 6479 - St. Oeste, Goiânia',
      latitude: -16.6792,
      longitude: -49.2640,
      emergencia24h: true,
      horario: 'Aberto 24h',
      telefone: '(62) 3201-6600',
    ),
    Hospital(
      id: '2',
      nome: 'Hospital das Clínicas UFG',
      endereco: 'Primeira Avenida, s/n - St. Leste Universitário, Goiânia',
      latitude: -16.6860,
      longitude: -49.2560,
      emergencia24h: true,
      horario: 'Aberto 24h',
      telefone: '(62) 3209-6100',
    ),
    Hospital(
      id: '3',
      nome: 'Hospital Estadual de Goiânia (HEG)',
      endereco: 'R. C-245 - St. Nova Suíça, Goiânia',
      latitude: -16.7021,
      longitude: -49.2851,
      emergencia24h: true,
      horario: 'Aberto 24h',
      telefone: '(62) 3201-7600',
    ),
    Hospital(
      id: '4',
      nome: 'Hospital Araújo Jorge',
      endereco: 'Av. DelphinoBuffer, 110 - St. Aeroporto, Goiânia',
      latitude: -16.7143,
      longitude: -49.2501,
      emergencia24h: false,
      horario: 'Fecha às 18h',
      telefone: '(62) 3096-5000',
    ),
    Hospital(
      id: '5',
      nome: 'Hospital Santa Casa de Goiânia',
      endereco: 'R. 235, 55 - St. Leste Universitário, Goiânia',
      latitude: -16.6900,
      longitude: -49.2500,
      emergencia24h: true,
      horario: 'Aberto 24h',
      telefone: '(62) 3224-5000',
    ),
  ];

  /// Retorna os hospitais ordenados por distância até [latUsuario], [lngUsuario].
  /// [limitar] define quantos resultados retornar (padrão: 5).
  List<Hospital> buscarProximos({
    required double latUsuario,
    required double lngUsuario,
    int limitar = 5,
  }) {
    for (final h in _hospitaisFixos) {
      h.distanciaKm = _calcularDistanciaKm(
        latUsuario,
        lngUsuario,
        h.latitude,
        h.longitude,
      );
    }

    final ordenados = List<Hospital>.from(_hospitaisFixos)
      ..sort((a, b) => (a.distanciaKm ?? 0).compareTo(b.distanciaKm ?? 0));

    return ordenados.take(limitar).toList();
  }

  /// Fórmula de Haversine para calcular distância entre dois pontos GPS.
  double _calcularDistanciaKm(
      double lat1,
      double lng1,
      double lat2,
      double lng2,
      ) {
    const raioTerraKm = 6371.0;
    final dLat = _grausParaRad(lat2 - lat1);
    final dLng = _grausParaRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_grausParaRad(lat1)) *
            cos(_grausParaRad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return raioTerraKm * c;
  }

  double _grausParaRad(double graus) => graus * pi / 180;
}
