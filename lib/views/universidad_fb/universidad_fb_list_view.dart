import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad_fb.dart';
import '../../services/universidad_service.dart';
import '../../widgets/custom_drawer.dart';

class UniversidadFbListView extends StatelessWidget {
  const UniversidadFbListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades Firebase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gestiona universidades en tiempo real con Firebase'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: StreamBuilder<List<UniversidadFb>>(
        stream: UniversidadService.watchUniversidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar universidades',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final universidades = snapshot.data ?? [];

          if (universidades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay universidades',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear una',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final bool useGrid = screenWidth > 600;
                final int crossAxisCount = screenWidth > 1200
                    ? 2 // Desktop: 2 columnas
                    : screenWidth > 800
                        ? 2 // Tablet: 2 columnas
                        : 1; // Móvil: 1 columna

                final double padding = screenWidth > 600 ? 24 : 16;
                final double spacing = screenWidth > 600 ? 16 : 12;
                final double maxWidth = screenWidth > 1400 ? 1400 : double.infinity;

                Widget listContent;

                if (useGrid && crossAxisCount > 1) {
                  listContent = GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: screenWidth > 1200 ? 1.8 : 1.5,
                    ),
                    itemCount: universidades.length,
                    itemBuilder: (context, index) {
                      final universidad = universidades[index];
                      return _UniversidadCard(
                        universidad: universidad,
                        index: index,
                        isGridView: true,
                      );
                    },
                  );
                } else {
                  listContent = ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    itemCount: universidades.length,
                    itemBuilder: (context, index) {
                      final universidad = universidades[index];
                      return _UniversidadCard(
                        universidad: universidad,
                        index: index,
                        isGridView: false,
                      );
                    },
                  );
                }

                if (maxWidth < double.infinity) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: listContent,
                    ),
                  );
                }

                return listContent;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/universidadesfb/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _UniversidadCard extends StatelessWidget {
  final UniversidadFb universidad;
  final int index;
  final bool isGridView;

  const _UniversidadCard({
    required this.universidad,
    required this.index,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
    ];
    final cardColor = colors[index % colors.length];

    return Card(
      elevation: 2,
      margin: isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/universidadesfb/edit/${universidad.id}'),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: cardColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera con nombre e icono
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.school,
                        color: cardColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            universidad.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIT: ${universidad.nit}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Información de contacto
                _buildInfoRow(
                  Icons.location_on_outlined,
                  universidad.direccion,
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.phone_outlined,
                  universidad.telefono,
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.language_outlined,
                  universidad.paginaWeb,
                  colorScheme,
                  isLink: true,
                ),

                const SizedBox(height: 12),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.push('/universidadesfb/edit/${universidad.id}'),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: cardColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _confirmarEliminar(context, universidad),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Eliminar'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, ColorScheme colorScheme, {bool isLink = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.isEmpty ? 'No especificado' : text,
            style: TextStyle(
              fontSize: 13,
              color: isLink ? Colors.blue : colorScheme.onSurfaceVariant,
              decoration: isLink && text.isNotEmpty ? TextDecoration.underline : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, UniversidadFb universidad) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar la universidad "${universidad.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await UniversidadService.deleteUniversidad(universidad.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Universidad "${universidad.nombre}" eliminada'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
