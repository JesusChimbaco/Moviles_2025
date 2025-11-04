import 'package:go_router/go_router.dart';
import 'package:parqueadero_2025_g2/views/categoria_fb/categoria_fb_form_view.dart';
import 'package:parqueadero_2025_g2/views/categoria_fb/categoria_fb_list_view.dart';
import 'package:parqueadero_2025_g2/views/universidad_fb/universidad_fb_form_view.dart';
import 'package:parqueadero_2025_g2/views/universidad_fb/universidad_fb_list_view.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';
import '../views/paso_parametros/detalle_screen.dart';
import '../views/paso_parametros/paso_parametros_screen.dart';
import '../views/settings/settings_screen.dart';
import '../views/profile/profile_screen.dart';
import '../views/servicio_asincrono/servicio_asincrono_screen.dart';
import '../views/cronometro/cronometro_screen.dart';

import '../views/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      name: 'paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // !Ruta para el detalle con parámetros
    GoRoute(
      path:
          '/detalle/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
      builder: (context, state) {
        //*se capturan los parametros recibidos
        // declarando las variables parametro y metodo
        // es final porque no se van a modificar
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    //!Ruta para el ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    //!Ruta para Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    //!Ruta para Profile
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    //!Ruta para Servicio Asíncrono
    GoRoute(
      path: '/servicio_asincrono',
      builder: (context, state) => const ServicioAsincronoScreen(),
    ),
    //!Ruta para Cronómetro
    GoRoute(
      path: '/cronometro',
      builder: (context, state) => const CronometroScreen(),
    ),
    GoRoute( 
      path: '/categoriasFirebase', 
      name: 'categoriasFirebase', 
      builder: (_, __) => const CategoriaFbListView(), 
    ), 
    GoRoute( 
      path: '/categoriasfb/create', 
      name: 'categoriasfb.create', 
      builder: (context, state) => const CategoriaFbFormView(), 
    ), 
    GoRoute( 
      path: '/categoriasfb/edit/:id', 
      name: 'categorias.edit', 
      builder: (context, state) { 
        final id = state.pathParameters['id']!; 
        return CategoriaFbFormView(id: id); 
      }, 
    ),
    //! Rutas para Universidades Firebase
    GoRoute(
      path: '/universidadesFirebase',
      name: 'universidadesFirebase',
      builder: (_, __) => const UniversidadFbListView(),
    ),
    GoRoute(
      path: '/universidadesfb/create',
      name: 'universidadesfb.create',
      builder: (context, state) => const UniversidadFbFormView(),
    ),
    GoRoute(
      path: '/universidadesfb/edit/:id',
      name: 'universidades.edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UniversidadFbFormView(id: id);
      },
    ),
  ],
);
