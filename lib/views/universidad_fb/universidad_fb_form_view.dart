import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad_fb.dart';
import '../../services/universidad_service.dart';

class UniversidadFbFormView extends StatefulWidget {
  final String? id;

  const UniversidadFbFormView({super.key, this.id});

  @override
  State<UniversidadFbFormView> createState() => _UniversidadFbFormViewState();
}

class _UniversidadFbFormViewState extends State<UniversidadFbFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _paginaWebController = TextEditingController();
  bool _camposInicializados = false;
  bool _guardando = false;

  Future<void> _guardar({String? id}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _guardando = true);

      try {
        final universidad = UniversidadFb(
          id: id ?? '',
          nit: _nitController.text.trim(),
          nombre: _nombreController.text.trim(),
          direccion: _direccionController.text.trim(),
          telefono: _telefonoController.text.trim(),
          paginaWeb: _paginaWebController.text.trim(),
        );

        if (widget.id == null) {
          await UniversidadService.addUniversidad(universidad);
        } else {
          await UniversidadService.updateUniversidad(universidad);
        }

        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.id == null
                    ? 'Universidad creada exitosamente'
                    : 'Universidad actualizada exitosamente',
              ),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _guardando = false);
        }
      }
    }
  }

  void _inicializarCampos(UniversidadFb universidad) {
    if (_camposInicializados) return;
    _nitController.text = universidad.nit;
    _nombreController.text = universidad.nombre;
    _direccionController.text = universidad.direccion;
    _telefonoController.text = universidad.telefono;
    _paginaWebController.text = universidad.paginaWeb;
    _camposInicializados = true;
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esNuevo = widget.id == null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Crear Universidad' : 'Editar Universidad'),
      ),
      body: esNuevo
          ? _buildFormulario(context, id: null)
          : StreamBuilder<UniversidadFb?>(
              stream: UniversidadService.watchUniversidadById(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar universidad',
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
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 60,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Universidad no encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                final universidad = snapshot.data!;
                _inicializarCampos(universidad);

                return _buildFormulario(context, id: universidad.id);
              },
            ),
    );
  }

  Widget _buildFormulario(BuildContext context, {String? id}) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de información
            Card(
              elevation: 0,
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.id == null
                            ? 'Completa los datos de la nueva universidad'
                            : 'Actualiza la información de la universidad',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Campo NIT
            TextFormField(
              controller: _nitController,
              decoration: InputDecoration(
                labelText: 'NIT *',
                hintText: 'Ej: 900123456-7',
                prefixIcon: const Icon(Icons.business),
                border: const OutlineInputBorder(),
                helperText: 'Número de Identificación Tributaria',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El NIT es obligatorio';
                }
                if (value.trim().length < 9) {
                  return 'El NIT debe tener al menos 9 caracteres';
                }
                return null;
              },
              enabled: !_guardando,
            ),
            const SizedBox(height: 16),

            // Campo Nombre
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                hintText: 'Ej: Universidad del Valle',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
                helperText: 'Nombre oficial de la universidad',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
              enabled: !_guardando,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Campo Dirección
            TextFormField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección *',
                hintText: 'Ej: Calle 13 # 100-00',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                helperText: 'Dirección principal de la sede',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La dirección es obligatoria';
                }
                return null;
              },
              enabled: !_guardando,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Campo Teléfono
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono *',
                hintText: 'Ej: +57 2 1234567',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                helperText: 'Teléfono principal de contacto',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El teléfono es obligatorio';
                }
                if (value.trim().length < 7) {
                  return 'El teléfono debe tener al menos 7 dígitos';
                }
                return null;
              },
              enabled: !_guardando,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Campo Página Web
            TextFormField(
              controller: _paginaWebController,
              decoration: const InputDecoration(
                labelText: 'Página Web *',
                hintText: 'Ej: https://www.universidad.edu.co',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
                helperText: 'URL del sitio web oficial',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La página web es obligatoria';
                }
                final urlPattern = RegExp(
                  r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
                  caseSensitive: false,
                );
                if (!urlPattern.hasMatch(value.trim())) {
                  return 'Ingresa una URL válida';
                }
                return null;
              },
              enabled: !_guardando,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 32),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _guardando ? null : () => context.pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _guardando ? null : () => _guardar(id: id),
                    child: _guardando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(widget.id == null ? 'Crear' : 'Actualizar'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nota de campos obligatorios
            Text(
              '* Campos obligatorios',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
