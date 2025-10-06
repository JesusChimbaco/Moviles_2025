import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class CronometroScreen extends StatefulWidget {
  const CronometroScreen({super.key});

  @override
  State<CronometroScreen> createState() => _CronometroScreenState();
}

class _CronometroScreenState extends State<CronometroScreen> {
  // Variables del cronómetro
  Timer? _timer;
  Duration _duracion = Duration.zero;
  bool _estaFuncionando = false;
  bool _estaPausado = false;

  // Variables de la cuenta regresiva
  Timer? _timerRegresivo;
  Duration _duracionRegresiva = const Duration(minutes: 5); // 5 minutos por defecto
  Duration _duracionInicialRegresiva = const Duration(minutes: 5);
  bool _estaFuncionandoRegresivo = false;
  bool _estaPausadoRegresivo = false;
  bool _haTerminado = false;

  @override
  void initState() {
    super.initState();
    print('🟢 [Cronómetro] initState() - Vista inicializada');
  }

  @override
  void dispose() {
    print('🔴 [Cronómetro] dispose() - Limpiando recursos...');
    _cancelarTimer();
    _cancelarTimerRegresivo();
    super.dispose();
  }

  // ========== CRONÓMETRO NORMAL ==========

  void _iniciarCronometro() {
    print('▶️ [Cronómetro] Iniciando cronómetro');
    setState(() {
      _estaFuncionando = true;
      _estaPausado = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _duracion = Duration(milliseconds: _duracion.inMilliseconds + 100);
      });
    });
  }

  void _pausarCronometro() {
    print('⏸️ [Cronómetro] Pausando cronómetro');
    setState(() {
      _estaFuncionando = false;
      _estaPausado = true;
    });
    _timer?.cancel();
  }

  void _reanudarCronometro() {
    print('▶️ [Cronómetro] Reanudando cronómetro');
    _iniciarCronometro();
  }

  void _reiniciarCronometro() {
    print('🔄 [Cronómetro] Reiniciando cronómetro');
    _cancelarTimer();
    setState(() {
      _duracion = Duration.zero;
      _estaFuncionando = false;
      _estaPausado = false;
    });
  }

  void _cancelarTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // ========== CUENTA REGRESIVA ==========

  void _iniciarCuentaRegresiva() {
    print('▶️ [Cuenta Regresiva] Iniciando cuenta regresiva: ${_formatearTiempo(_duracionRegresiva)}');
    
    if (_duracionRegresiva.inMilliseconds <= 0) {
      _mostrarDialogoTiempo();
      return;
    }

    setState(() {
      _estaFuncionandoRegresivo = true;
      _estaPausadoRegresivo = false;
      _haTerminado = false;
    });

    _timerRegresivo = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_duracionRegresiva.inMilliseconds > 0) {
          _duracionRegresiva = Duration(milliseconds: _duracionRegresiva.inMilliseconds - 100);
        } else {
          _duracionRegresiva = Duration.zero;
          _haTerminado = true;
          _estaFuncionandoRegresivo = false;
          _estaPausadoRegresivo = false;
          timer.cancel();
          print('⏰ [Cuenta Regresiva] ¡Tiempo terminado!');
          _mostrarDialogoTerminado();
        }
      });
    });
  }

  void _pausarCuentaRegresiva() {
    print('⏸️ [Cuenta Regresiva] Pausando cuenta regresiva');
    setState(() {
      _estaFuncionandoRegresivo = false;
      _estaPausadoRegresivo = true;
    });
    _timerRegresivo?.cancel();
  }

  void _reanudarCuentaRegresiva() {
    print('▶️ [Cuenta Regresiva] Reanudando cuenta regresiva');
    _iniciarCuentaRegresiva();
  }

  void _reiniciarCuentaRegresiva() {
    print('🔄 [Cuenta Regresiva] Reiniciando cuenta regresiva');
    _cancelarTimerRegresivo();
    setState(() {
      _duracionRegresiva = _duracionInicialRegresiva;
      _estaFuncionandoRegresivo = false;
      _estaPausadoRegresivo = false;
      _haTerminado = false;
    });
  }

  void _cancelarTimerRegresivo() {
    _timerRegresivo?.cancel();
    _timerRegresivo = null;
  }

  // ========== DIÁLOGOS ==========

  void _mostrarDialogoTiempo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar Tiempo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecciona el tiempo para la cuenta regresiva:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildBotonTiempo('1 min', const Duration(minutes: 1)),
                _buildBotonTiempo('3 min', const Duration(minutes: 3)),
                _buildBotonTiempo('5 min', const Duration(minutes: 5)),
                _buildBotonTiempo('10 min', const Duration(minutes: 10)),
                _buildBotonTiempo('30 seg', const Duration(seconds: 30)),
                _buildBotonTiempo('10 seg', const Duration(seconds: 10)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonTiempo(String texto, Duration duracion) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _duracionRegresiva = duracion;
          _duracionInicialRegresiva = duracion;
        });
        Navigator.of(context).pop();
      },
      child: Text(texto),
    );
  }

  void _mostrarDialogoTerminado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Colors.orange),
            SizedBox(width: 8),
            Text('¡Tiempo Terminado!'),
          ],
        ),
        content: const Text('La cuenta regresiva ha llegado a cero.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _reiniciarCuentaRegresiva();
            },
            child: const Text('Reiniciar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // ========== UTILIDADES ==========

  String _formatearTiempo(Duration duracion) {
    String dosDigitos(int n) => n.toString().padLeft(2, '0');
    final horas = dosDigitos(duracion.inHours);
    final minutos = dosDigitos(duracion.inMinutes.remainder(60));
    final segundos = dosDigitos(duracion.inSeconds.remainder(60));
    final centesimas = dosDigitos((duracion.inMilliseconds.remainder(1000) / 10).floor());
    
    if (duracion.inHours > 0) {
      return '$horas:$minutos:$segundos.$centesimas';
    }
    return '$minutos:$segundos.$centesimas';
  }

  Color _obtenerColorTiempo(Duration duracion) {
    if (_haTerminado) return Colors.red;
    if (duracion.inSeconds <= 10 && _estaFuncionandoRegresivo) return Colors.red;
    if (duracion.inSeconds <= 30 && _estaFuncionandoRegresivo) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronómetro y Timer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gestión de Tiempo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // ========== CRONÓMETRO ==========
            Expanded(
              child: _buildSeccionCronometro(),
            ),
            
            const Divider(thickness: 2, height: 40),
            
            // ========== CUENTA REGRESIVA ==========
            Expanded(
              child: _buildSeccionCuentaRegresiva(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionCronometro() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'Cronómetro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Display del tiempo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Text(
                _formatearTiempo(_duracion),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.blue,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Botones de control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_estaFuncionando && !_estaPausado)
                  _buildBotonControl(
                    Icons.play_arrow,
                    'Iniciar',
                    Colors.green,
                    _iniciarCronometro,
                  ),
                
                if (_estaFuncionando)
                  _buildBotonControl(
                    Icons.pause,
                    'Pausar',
                    Colors.orange,
                    _pausarCronometro,
                  ),
                
                if (_estaPausado)
                  _buildBotonControl(
                    Icons.play_arrow,
                    'Reanudar',
                    Colors.blue,
                    _reanudarCronometro,
                  ),
                
                if (_duracion.inMilliseconds > 0)
                  _buildBotonControl(
                    Icons.stop,
                    'Reiniciar',
                    Colors.red,
                    _reiniciarCronometro,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionCuentaRegresiva() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_top, size: 32, color: _obtenerColorTiempo(_duracionRegresiva)),
                const SizedBox(width: 12),
                const Text(
                  'Cuenta Regresiva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Display del tiempo regresivo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: _obtenerColorTiempo(_duracionRegresiva).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _obtenerColorTiempo(_duracionRegresiva).withOpacity(0.3), 
                  width: 2
                ),
              ),
              child: Text(
                _formatearTiempo(_duracionRegresiva),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _obtenerColorTiempo(_duracionRegresiva),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Progreso visual
            if (_duracionInicialRegresiva.inMilliseconds > 0)
              LinearProgressIndicator(
                value: _duracionRegresiva.inMilliseconds / _duracionInicialRegresiva.inMilliseconds,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(_obtenerColorTiempo(_duracionRegresiva)),
              ),
            
            const SizedBox(height: 30),
            
            // Botones de control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_estaFuncionandoRegresivo && !_estaPausadoRegresivo && !_haTerminado)
                  _buildBotonControl(
                    Icons.play_arrow,
                    'Iniciar',
                    Colors.green,
                    _iniciarCuentaRegresiva,
                  ),
                
                if (_estaFuncionandoRegresivo)
                  _buildBotonControl(
                    Icons.pause,
                    'Pausar',
                    Colors.orange,
                    _pausarCuentaRegresiva,
                  ),
                
                if (_estaPausadoRegresivo)
                  _buildBotonControl(
                    Icons.play_arrow,
                    'Reanudar',
                    Colors.blue,
                    _reanudarCuentaRegresiva,
                  ),
                
                _buildBotonControl(
                  Icons.settings,
                  'Configurar',
                  Colors.purple,
                  _mostrarDialogoTiempo,
                ),
                
                if (_duracionRegresiva != _duracionInicialRegresiva || _haTerminado)
                  _buildBotonControl(
                    Icons.stop,
                    'Reiniciar',
                    Colors.red,
                    _reiniciarCuentaRegresiva,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonControl(IconData icono, String texto, Color color, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
          child: Icon(icono, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}