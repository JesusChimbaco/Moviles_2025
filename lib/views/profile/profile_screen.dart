import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: 'Información',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Preferencias',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Historial',
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Información Personal
          _buildInformacionTab(),
          // Tab 2: Preferencias
          _buildPreferenciasTab(),
          // Tab 3: Historial
          _buildHistorialTab(),
        ],
      ),
    );
  }

  Widget _buildInformacionTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Personal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Juan Pérez'),
              subtitle: Text('Nombre completo'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.green),
              title: Text('juan.perez@email.com'),
              subtitle: Text('Correo electrónico'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.phone, color: Colors.orange),
              title: Text('+57 300 123 4567'),
              subtitle: Text('Teléfono'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.purple),
              title: Text('15 de marzo, 1990'),
              subtitle: Text('Fecha de nacimiento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenciasTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferencias',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: SwitchListTile(
              title: const Text('Notificaciones'),
              subtitle: const Text('Recibir notificaciones push'),
              value: true,
              onChanged: (bool value) {
                // Aquí manejarías el cambio de preferencia
              },
              secondary: const Icon(Icons.notifications),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Modo oscuro'),
              subtitle: const Text('Activar tema oscuro'),
              value: false,
              onChanged: (bool value) {
                // Aquí manejarías el cambio de tema
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text('Idioma'),
              subtitle: Text('Español'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Ubicación'),
              subtitle: Text('Permitir acceso a ubicación'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialTab() {
    final List<Map<String, String>> historial = [
      {
        'fecha': '18 Sep 2025',
        'accion': 'Ingreso al parqueadero',
        'detalle': 'Vehículo ABC-123'
      },
      {
        'fecha': '17 Sep 2025',
        'accion': 'Pago realizado',
        'detalle': 'Factura #001234'
      },
      {
        'fecha': '16 Sep 2025',
        'accion': 'Reserva de espacio',
        'detalle': 'Espacio A-15'
      },
      {
        'fecha': '15 Sep 2025',
        'accion': 'Actualización de perfil',
        'detalle': 'Cambio de teléfono'
      },
      {
        'fecha': '14 Sep 2025',
        'accion': 'Ingreso al parqueadero',
        'detalle': 'Vehículo XYZ-789'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial de Actividades',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final item = historial[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['accion']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['detalle']!),
                        const SizedBox(height: 4),
                        Text(
                          item['fecha']!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}