import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/localizacao_servico.dart';
import '../services/hospitais_servico.dart';

class HomePage extends StatefulWidget {
  final VoidCallback aoAlternarTema;
  final bool isModoEscuro;

  const HomePage({
    super.key,
    required this.aoAlternarTema,
    required this.isModoEscuro,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _localizacaoServico = LocalizacaoServico();
  final _hospitaisServico = HospitaisServico();

  Position? _posicao;
  String _enderecoExibido = 'Obtendo localização...';
  List<Hospital> _hospitais = [];
  bool _carregandoLocalizacao = true;
  bool _carregandoHospitais = true;
  String? _erroLocalizacao;

  @override
  void initState() {
    super.initState();
    _carregarLocalizacaoEHospitais();
  }

  Future<void> _carregarLocalizacaoEHospitais() async {
    setState(() {
      _carregandoLocalizacao = true;
      _carregandoHospitais = true;
      _erroLocalizacao = null;
    });

    final resultado = await _localizacaoServico.obterLocalizacaoAtual();

    if (!mounted) return;

    if (resultado.sucesso && resultado.posicao != null) {
      final posicao = resultado.posicao!;
      final hospitais = _hospitaisServico.buscarProximos(
        latUsuario: posicao.latitude,
        lngUsuario: posicao.longitude,
      );

      setState(() {
        _posicao = posicao;
        _enderecoExibido = _localizacaoServico.formatarCoordenadas(posicao);
        _hospitais = hospitais;
        _carregandoLocalizacao = false;
        _carregandoHospitais = false;
      });
    } else {
      setState(() {
        _erroLocalizacao = resultado.erro;
        _enderecoExibido = 'Localização indisponível';
        _carregandoLocalizacao = false;
        _carregandoHospitais = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final azulPrincipal = colorScheme.primary;
    final backgroundColor = colorScheme.surface;
    final surfaceColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AJUDA 192',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: azulPrincipal,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.aoAlternarTema,
            icon: Icon(
              widget.isModoEscuro ? Icons.light_mode : Icons.dark_mode,
              color: azulPrincipal,
            ),
            tooltip: widget.isModoEscuro ? 'Modo Claro' : 'Modo Escuro',
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: azulPrincipal),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: azulPrincipal),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              widget.isModoEscuro
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _carregarLocalizacaoEHospitais,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildWelcomeHeader(
                    azulPrincipal,
                    textColor,
                    secondaryTextColor,
                    surfaceColor,
                  ),
                  _buildEmergencyButton(azulPrincipal),
                  _buildServicesSection(azulPrincipal, textColor, surfaceColor),
                  _buildNearbyHospitals(
                    azulPrincipal,
                    textColor,
                    secondaryTextColor,
                    surfaceColor,
                  ),
                  _buildHealthTips(
                    azulPrincipal,
                    textColor,
                    secondaryTextColor,
                    surfaceColor,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Header com localização real ─────────────────────────────────────────

  Widget _buildWelcomeHeader(
      Color azulPrincipal,
      Color textColor,
      Color secondaryTextColor,
      Color surfaceColor,
      ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: widget.isModoEscuro
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.blueGrey.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: azulPrincipal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: azulPrincipal, size: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                  Text(
                    'Usuário SAMU',
                    style: TextStyle(
                      color: azulPrincipal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bloco de localização
          GestureDetector(
            onTap: _carregarLocalizacaoEHospitais,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: azulPrincipal.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: azulPrincipal.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: azulPrincipal, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUA LOCALIZAÇÃO ATUAL',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _carregandoLocalizacao
                            ? Row(
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: azulPrincipal,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Obtendo localização...',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          _erroLocalizacao != null
                              ? 'Toque para tentar novamente'
                              : _enderecoExibido,
                          style: TextStyle(
                            color: _erroLocalizacao != null
                                ? Colors.red
                                : textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_erroLocalizacao != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _erroLocalizacao!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _carregandoLocalizacao
                      ? const SizedBox.shrink()
                      : Icon(
                    _erroLocalizacao != null
                        ? Icons.refresh
                        : Icons.my_location,
                    color: azulPrincipal,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Botão emergência ────────────────────────────────────────────────────

  Widget _buildEmergencyButton(Color azulPrincipal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // TODO: url_launcher → tel:192
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: azulPrincipal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(double.infinity, 65),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 28),
            SizedBox(width: 12),
            Text(
              'LIGAR PARA EMERGÊNCIA 192',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Serviços rápidos ────────────────────────────────────────────────────

  Widget _buildServicesSection(
      Color azulPrincipal,
      Color textColor,
      Color surfaceColor,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serviços Rápidos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 0.9,
            children: [
              _buildServiceCard(
                icon: Icons.local_hospital,
                label: 'Hospitais',
                color: azulPrincipal,
                surfaceColor: surfaceColor,
              ),
              _buildServiceCard(
                icon: Icons.emergency,
                label: 'Emergência',
                color: Colors.red,
                surfaceColor: surfaceColor,
              ),
              _buildServiceCard(
                icon: Icons.airport_shuttle,
                label: 'Ambulâncias',
                color: Colors.green,
                surfaceColor: surfaceColor,
              ),
              _buildServiceCard(
                icon: Icons.medication,
                label: 'Farmácias',
                color: Colors.purple,
                surfaceColor: surfaceColor,
              ),
              _buildServiceCard(
                icon: Icons.call,
                label: 'Contatos',
                color: Colors.orange,
                surfaceColor: surfaceColor,
              ),
              _buildServiceCard(
                icon: Icons.info,
                label: 'Dicas',
                color: Colors.teal,
                surfaceColor: surfaceColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color surfaceColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.blueGrey.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Hospitais próximos (dados reais) ────────────────────────────────────

  Widget _buildNearbyHospitals(
      Color azulPrincipal,
      Color textColor,
      Color secondaryTextColor,
      Color surfaceColor,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hospitais Próximos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: _carregarLocalizacaoEHospitais,
                style: TextButton.styleFrom(foregroundColor: azulPrincipal),
                child: const Text(
                  'Atualizar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Estado de carregamento / erro / lista
          if (_carregandoHospitais)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: azulPrincipal),
              ),
            )
          else if (_erroLocalizacao != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _erroLocalizacao!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _hospitais.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _buildHospitalItem(
                hospital: _hospitais[i],
                azulPrincipal: azulPrincipal,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                surfaceColor: surfaceColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHospitalItem({
    required Hospital hospital,
    required Color azulPrincipal,
    required Color textColor,
    required Color secondaryTextColor,
    required Color surfaceColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.isModoEscuro
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.blueGrey.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hospital.emergencia24h
                  ? Colors.red.withValues(alpha: 0.1)
                  : azulPrincipal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_hospital,
              color: hospital.emergencia24h ? Colors.red : azulPrincipal,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.nome,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      hospital.distanciaFormatada,
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: secondaryTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      hospital.horario,
                      style: TextStyle(
                        color: hospital.emergencia24h
                            ? Colors.green
                            : secondaryTextColor,
                        fontSize: 13,
                        fontWeight: hospital.emergencia24h
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hospital.telefone,
                  style: TextStyle(
                    color: azulPrincipal,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: secondaryTextColor),
        ],
      ),
    );
  }

  // ─── Dicas de saúde ──────────────────────────────────────────────────────

  Widget _buildHealthTips(
      Color azulPrincipal,
      Color textColor,
      Color secondaryTextColor,
      Color surfaceColor,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dicas de Saúde',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTipCard(
                  title: 'Primeiros Socorros',
                  description: 'Saiba o que fazer em caso de engasgo',
                  icon: Icons.help_outline,
                  color: Colors.orange,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(width: 15),
                _buildTipCard(
                  title: 'Prevenção',
                  description: 'Dicas para evitar acidentes domésticos',
                  icon: Icons.shield_outlined,
                  color: Colors.green,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(width: 15),
                _buildTipCard(
                  title: 'Sinais Vitais',
                  description: 'Como medir sua pressão em casa',
                  icon: Icons.favorite_border,
                  color: azulPrincipal,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.blueGrey.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: secondaryTextColor, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
