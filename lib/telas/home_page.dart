import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color azulPrincipal = colorScheme.primary;

    final Color backgroundColor = colorScheme.surface;
    final Color surfaceColor = theme.cardColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color secondaryTextColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AJUDA 192',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
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
            onPressed: () {
              // TODO: Implementar notificações
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: azulPrincipal),
            onPressed: () {
              // TODO: Implementar perfil
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
]            colors: [
              backgroundColor,
              widget.isModoEscuro
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildWelcomeHeader(azulPrincipal, textColor, secondaryTextColor, surfaceColor),
                _buildEmergencyButton(azulPrincipal),
                _buildServicesSection(azulPrincipal, textColor, surfaceColor),
                _buildNearbyHospitals(azulPrincipal, textColor, secondaryTextColor, surfaceColor),
                _buildHealthTips(azulPrincipal, textColor, secondaryTextColor, surfaceColor),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(
      Color azulPrincipal,
      Color textColor,
      Color secondaryTextColor,
      Color surfaceColor
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
                child: Icon(
                  Icons.person,
                  color: azulPrincipal,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
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

          Container(
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
                      Text(
                        'Rua das Flores, 123 - Centro',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.my_location, color: azulPrincipal, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(Color azulPrincipal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implementar chamada de emergência
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
                icon: Icons.local_car_wash_sharp,
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
          onTap: () {
            // TODO: Implementar navegação
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
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
                onPressed: () {
                  // TODO: Implementar ver todos
                },
                style: TextButton.styleFrom(
                  foregroundColor: azulPrincipal,
                ),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildHospitalItem(
            name: 'Hospital Municipal',
            distance: '2.5 km',
            status: 'Aberto 24h',
            emergency: true,
            azulPrincipal: azulPrincipal,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            surfaceColor: surfaceColor,
          ),
          const SizedBox(height: 12),
          _buildHospitalItem(
            name: 'Hospital Santa Casa',
            distance: '3.8 km',
            status: 'Aberto 24h',
            emergency: true,
            azulPrincipal: azulPrincipal,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            surfaceColor: surfaceColor,
          ),
          const SizedBox(height: 12),
          _buildHospitalItem(
            name: 'Clínica São João',
            distance: '1.2 km',
            status: 'Fecha às 20h',
            emergency: false,
            azulPrincipal: azulPrincipal,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            surfaceColor: surfaceColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalItem({
    required String name,
    required String distance,
    required String status,
    required bool emergency,
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
              color: emergency
                  ? Colors.red.withValues(alpha: 0.1)
                  : azulPrincipal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_hospital,
              color: emergency ? Colors.red : azulPrincipal,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
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
                      distance,
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
                      status,
                      style: TextStyle(
                        color: emergency ? Colors.green : secondaryTextColor,
                        fontSize: 13,
                        fontWeight: emergency ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: secondaryTextColor),
        ],
      ),
    );
  }

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
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
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
            style: TextStyle(
              fontSize: 12,
              color: secondaryTextColor,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}