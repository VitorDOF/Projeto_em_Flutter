import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_em_flutter/services/hospitais_servico.dart';

void main() {
  late HospitaisServico servico;

  setUp(() {
    servico = HospitaisServico();
  });

  group('HospitaisServico.buscarProximos', () {
    // Coordenadas do centro de Goiânia
    const latGoiania = -16.6869;
    const lngGoiania = -49.2648;

    test('retorna lista não vazia', () {
      final resultado = servico.buscarProximos(
        latUsuario: latGoiania,
        lngUsuario: lngGoiania,
      );
      expect(resultado, isNotEmpty);
    });

    test('limita resultado ao número solicitado', () {
      final resultado = servico.buscarProximos(
        latUsuario: latGoiania,
        lngUsuario: lngGoiania,
        limitar: 2,
      );
      expect(resultado.length, lessThanOrEqualTo(2));
    });

    test('retorna padrão de 5 hospitais', () {
      final resultado = servico.buscarProximos(
        latUsuario: latGoiania,
        lngUsuario: lngGoiania,
      );
      expect(resultado.length, lessThanOrEqualTo(5));
    });

    test('hospitais estão ordenados por distância crescente', () {
      final resultado = servico.buscarProximos(
        latUsuario: latGoiania,
        lngUsuario: lngGoiania,
      );
      for (int i = 0; i < resultado.length - 1; i++) {
        expect(
          resultado[i].distanciaKm,
          lessThanOrEqualTo(resultado[i + 1].distanciaKm!),
        );
      }
    });

    test('distância calculada é positiva', () {
      final resultado = servico.buscarProximos(
        latUsuario: latGoiania,
        lngUsuario: lngGoiania,
      );
      for (final h in resultado) {
        expect(h.distanciaKm, greaterThanOrEqualTo(0));
      }
    });

    test('distância é zero para o próprio ponto de um hospital', () {
      // Usa a lat/lng exata do HUGO
      final resultado = servico.buscarProximos(
        latUsuario: -16.6792,
        lngUsuario: -49.2640,
      );
      // O primeiro da lista deve ter distância < 0.1 km
      expect(resultado.first.distanciaKm, lessThan(0.1));
    });
  });

  group('Hospital.distanciaFormatada', () {
    test('exibe metros quando distância < 1 km', () {
      final h = Hospital(
        id: 'test',
        nome: 'Teste',
        endereco: 'Rua X',
        latitude: 0,
        longitude: 0,
        emergencia24h: false,
        horario: 'Aberto',
        telefone: '0000',
      );
      h.distanciaKm = 0.350;
      expect(h.distanciaFormatada, contains('m'));
      expect(h.distanciaFormatada, isNot(contains('km')));
    });

    test('exibe km quando distância >= 1 km', () {
      final h = Hospital(
        id: 'test',
        nome: 'Teste',
        endereco: 'Rua X',
        latitude: 0,
        longitude: 0,
        emergencia24h: false,
        horario: 'Aberto',
        telefone: '0000',
      );
      h.distanciaKm = 2.5;
      expect(h.distanciaFormatada, contains('km'));
    });

    test('exibe traço quando distância é null', () {
      final h = Hospital(
        id: 'test',
        nome: 'Teste',
        endereco: 'Rua X',
        latitude: 0,
        longitude: 0,
        emergencia24h: false,
        horario: 'Aberto',
        telefone: '0000',
      );
      expect(h.distanciaFormatada, '—');
    });
  });
}
