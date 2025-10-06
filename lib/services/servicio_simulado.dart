import 'dart:math';

/// Servicio simulado para demostrar operaciones asíncronas
class ServicioSimulado {
  /// Simula una consulta de vehículos con diferentes resultados posibles
  static Future<List<String>> consultarVehiculos() async {
    print('🚀 [ServicioSimulado] Iniciando consulta de vehículos...');
    
    // Simular tiempo de respuesta de 2-3 segundos
    final duracion = 2 + Random().nextInt(2); // 2-3 segundos
    print('⏳ [ServicioSimulado] Consultando... (${duracion}s)');
    
    await Future.delayed(Duration(seconds: duracion));
    
    // Simular diferentes resultados: 70% éxito, 30% error
    final exito = Random().nextBool() && Random().nextBool(); // ~75% éxito
    
    if (exito) {
      print('✅ [ServicioSimulado] Consulta exitosa - Datos obtenidos');
      return [
        'ABC-123',
        'XYZ-789', 
        'DEF-456',
        'GHI-012',
        'JKL-345'
      ];
    } else {
      print('❌ [ServicioSimulado] Error en la consulta');
      throw Exception('Error de conexión con el servidor');
    }
  }
  
  /// Simula una consulta de espacios disponibles
  static Future<Map<String, int>> consultarEspacios() async {
    print('🚀 [ServicioSimulado] Iniciando consulta de espacios...');
    
    final duracion = 2 + Random().nextInt(2);
    print('⏳ [ServicioSimulado] Consultando espacios... (${duracion}s)');
    
    await Future.delayed(Duration(seconds: duracion));
    
    // Simular diferentes resultados
    final exito = Random().nextDouble() > 0.2; // 80% éxito
    
    if (exito) {
      print('✅ [ServicioSimulado] Espacios consultados exitosamente');
      return {
        'total': 100,
        'ocupados': 45 + Random().nextInt(30),
        'disponibles': 55 - Random().nextInt(30),
        'reservados': Random().nextInt(10)
      };
    } else {
      print('❌ [ServicioSimulado] Error al consultar espacios');
      throw Exception('Timeout: No se pudo conectar con la base de datos');
    }
  }
  
  /// Simula el registro de un nuevo vehículo
  static Future<String> registrarVehiculo(String placa) async {
    print('🚀 [ServicioSimulado] Iniciando registro de vehículo: $placa');
    
    final duracion = 1 + Random().nextInt(3); // 1-3 segundos
    print('⏳ [ServicioSimulado] Registrando vehículo... (${duracion}s)');
    
    await Future.delayed(Duration(seconds: duracion));
    
    // Validar placa simple
    if (placa.length < 6) {
      print('❌ [ServicioSimulado] Placa inválida');
      throw Exception('La placa debe tener al menos 6 caracteres');
    }
    
    final exito = Random().nextDouble() > 0.15; // 85% éxito
    
    if (exito) {
      final ticketId = 'T${DateTime.now().millisecondsSinceEpoch}';
      print('✅ [ServicioSimulado] Vehículo registrado - Ticket: $ticketId');
      return ticketId;
    } else {
      print('❌ [ServicioSimulado] Error en el registro');
      throw Exception('La placa ya está registrada en el sistema');
    }
  }
}