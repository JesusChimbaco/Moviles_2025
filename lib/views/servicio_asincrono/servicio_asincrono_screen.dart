import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import '../../services/servicio_simulado.dart';

class ServicioAsincronoScreen extends StatefulWidget {
  const ServicioAsincronoScreen({super.key});

  @override
  State<ServicioAsincronoScreen> createState() => _ServicioAsincronoScreenState();
}

class _ServicioAsincronoScreenState extends State<ServicioAsincronoScreen> {
  // Estados para diferentes operaciones
  bool _cargandoVehiculos = false;
  bool _cargandoEspacios = false;
  bool _cargandoRegistro = false;
  
  List<String>? _vehiculos;
  Map<String, int>? _espacios;
  String? _ticketId;
  
  String? _errorVehiculos;
  String? _errorEspacios;
  String? _errorRegistro;
  
  final TextEditingController _placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios Asincrónicos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demostración de Async/Await',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Sección 1: Consultar Vehículos
            _buildSeccionVehiculos(),
            const SizedBox(height: 20),
            
            // Sección 2: Consultar Espacios
            _buildSeccionEspacios(),
            const SizedBox(height: 20),
            
            // Sección 3: Registrar Vehículo
            _buildSeccionRegistro(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionVehiculos() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Consultar Vehículos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _cargandoVehiculos ? null : _consultarVehiculos,
                  child: _cargandoVehiculos 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Consultar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Estados
            if (_cargandoVehiculos) ...[
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Cargando vehículos...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ] else if (_errorVehiculos != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $_errorVehiculos',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_vehiculos != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Éxito: Vehículos encontrados',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _vehiculos!.map((placa) => Chip(
                        label: Text(placa),
                        backgroundColor: Colors.blue.shade100,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionEspacios() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_parking, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Consultar Espacios',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _cargandoEspacios ? null : _consultarEspacios,
                  child: _cargandoEspacios 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Consultar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Estados
            if (_cargandoEspacios) ...[
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Consultando espacios...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ] else if (_errorEspacios != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $_errorEspacios',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_espacios != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Éxito: Espacios consultados',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEspacioStat('Total', _espacios!['total']!, Colors.blue),
                        _buildEspacioStat('Ocupados', _espacios!['ocupados']!, Colors.red),
                        _buildEspacioStat('Disponibles', _espacios!['disponibles']!, Colors.green),
                        _buildEspacioStat('Reservados', _espacios!['reservados']!, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionRegistro() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Registrar Vehículo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _placaController,
                    decoration: const InputDecoration(
                      labelText: 'Placa del vehículo',
                      hintText: 'Ej: ABC-123',
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_cargandoRegistro,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _cargandoRegistro ? null : _registrarVehiculo,
                  child: _cargandoRegistro 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Registrar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Estados
            if (_cargandoRegistro) ...[
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Registrando vehículo...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ] else if (_errorRegistro != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $_errorRegistro',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_ticketId != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Éxito: Vehículo registrado\nTicket: $_ticketId',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEspacioStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Métodos async/await
  Future<void> _consultarVehiculos() async {
    print('🎯 [UI] Usuario solicitó consulta de vehículos');
    
    setState(() {
      _cargandoVehiculos = true;
      _vehiculos = null;
      _errorVehiculos = null;
    });

    try {
      print('⏳ [UI] Esperando respuesta del servicio...');
      final vehiculos = await ServicioSimulado.consultarVehiculos();
      
      if (mounted) {
        setState(() {
          _cargandoVehiculos = false;
          _vehiculos = vehiculos;
        });
        print('🎉 [UI] Vehículos mostrados en pantalla');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargandoVehiculos = false;
          _errorVehiculos = e.toString().replaceFirst('Exception: ', '');
        });
        print('💥 [UI] Error mostrado en pantalla: $e');
      }
    }
  }

  Future<void> _consultarEspacios() async {
    print('🎯 [UI] Usuario solicitó consulta de espacios');
    
    setState(() {
      _cargandoEspacios = true;
      _espacios = null;
      _errorEspacios = null;
    });

    try {
      print('⏳ [UI] Esperando respuesta del servicio...');
      final espacios = await ServicioSimulado.consultarEspacios();
      
      if (mounted) {
        setState(() {
          _cargandoEspacios = false;
          _espacios = espacios;
        });
        print('🎉 [UI] Espacios mostrados en pantalla');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargandoEspacios = false;
          _errorEspacios = e.toString().replaceFirst('Exception: ', '');
        });
        print('💥 [UI] Error mostrado en pantalla: $e');
      }
    }
  }

  Future<void> _registrarVehiculo() async {
    final placa = _placaController.text.trim();
    if (placa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una placa válida')),
      );
      return;
    }

    print('🎯 [UI] Usuario solicitó registro de vehículo: $placa');
    
    setState(() {
      _cargandoRegistro = true;
      _ticketId = null;
      _errorRegistro = null;
    });

    try {
      print('⏳ [UI] Esperando respuesta del servicio...');
      final ticket = await ServicioSimulado.registrarVehiculo(placa);
      
      if (mounted) {
        setState(() {
          _cargandoRegistro = false;
          _ticketId = ticket;
        });
        _placaController.clear();
        print('🎉 [UI] Registro exitoso mostrado en pantalla');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargandoRegistro = false;
          _errorRegistro = e.toString().replaceFirst('Exception: ', '');
        });
        print('💥 [UI] Error de registro mostrado en pantalla: $e');
      }
    }
  }

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
  }
}