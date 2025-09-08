import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro Flutter',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Hola, Flutter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Estudiante: Jesús Adrian Chimbaco Oviedo',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network('https://gamingbolt.com/wp-content/uploads/2018/02/Red-Dead-Redemption-2.jpg', width: 100, height: 100),
                  Image.asset('assets/images/redDead.jpeg', width: 100, height: 100),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    title = (title == 'Hola, Flutter') ? '¡Título cambiado!' : 'Hola, Flutter';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Título actualizado')),
                  );
                },
                child: const Text('Cambiar título'),
              ),
              const SizedBox(height: 24),

              // 🔹 Widget 1: Stack (texto encima de una imagen)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/imafraid.jpg',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Im afraid...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔹 Widget 2: GridView (4 celdas con imágenes)
              SizedBox(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: List.generate(4, (index) {
                    return Container(
                      color: Colors.blue[100 * (index + 2)],
                      child: Center(
                        child: Text(
                          'Celda ${index + 1}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
