import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _sliderValue = 50.0;
  String _selectedChip = 'Espacios';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            const Text(
              'Bienvenido al Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Tarjeta con estadísticas
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ocupación del Parqueadero',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // SLIDER - Widget nuevo y diferente
                    Text(
                      'Capacidad ocupada: ${_sliderValue.round()}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: '${_sliderValue.round()}%',
                      onChanged: (double value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                    
                    // Indicador visual
                    LinearProgressIndicator(
                      value: _sliderValue / 100,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _sliderValue > 80 
                            ? Colors.red 
                            : _sliderValue > 50 
                                ? Colors.orange 
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Sección con Chips
            const Text(
              'Filtros rápidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // CHIPS - Otro widget diferente
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text('Espacios'),
                  selected: _selectedChip == 'Espacios',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChip = selected ? 'Espacios' : '';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Vehículos'),
                  selected: _selectedChip == 'Vehículos',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChip = selected ? 'Vehículos' : '';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Reportes'),
                  selected: _selectedChip == 'Reportes',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChip = selected ? 'Reportes' : '';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Historial'),
                  selected: _selectedChip == 'Historial',
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChip = selected ? 'Historial' : '';
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Información adicional
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_parking,
                      size: 80,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Filtro seleccionado: $_selectedChip',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
