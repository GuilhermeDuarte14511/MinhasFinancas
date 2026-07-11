import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';

class WorkspaceSettingsPage extends ConsumerStatefulWidget {
  const WorkspaceSettingsPage({super.key});

  @override
  ConsumerState<WorkspaceSettingsPage> createState() =>
      _WorkspaceSettingsPageState();
}

class _WorkspaceSettingsPageState extends ConsumerState<WorkspaceSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late int _colorValue;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final finance = ref.read(financeControllerProvider);
    _nameController = TextEditingController(text: finance.spaceName);
    _colorValue = finance.spaceColorValue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateSpace(
            name: _nameController.text.trim(),
            colorValue: _colorValue,
          );
      if (mounted) {
        showSuccessMessage(context, 'Espaço atualizado.');
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível atualizar o espaço.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _archive() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivar espaço?'),
        content: const Text(
          'O espaço deixará de aparecer para todos os membros. O histórico não será apagado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Arquivar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      final hasAnother = await ref
          .read(financeControllerProvider.notifier)
          .archiveCurrentSpace();
      if (mounted) context.go(hasAnother ? '/app/home' : '/welcome');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível arquivar o espaço.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    return Scaffold(
      appBar: const BrandAppBar(title: 'Configurar espaço', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Identidade do espaço',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    enabled: finance.isOwner,
                    decoration: const InputDecoration(
                      labelText: 'Nome do espaço',
                      prefixIcon: Icon(Icons.home_work_outlined),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) >= 3
                        ? null
                        : 'Informe um nome válido.',
                  ),
                  const SizedBox(height: 20),
                  const Text('Cor'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final color in const [
                        0xFF3525CD,
                        0xFF006A63,
                        0xFF3D37A9,
                        0xFF8C1D40,
                        0xFF4B6267,
                      ])
                        ChoiceChip(
                          label: const SizedBox(width: 22, height: 22),
                          avatar: CircleAvatar(backgroundColor: Color(color)),
                          selected: _colorValue == color,
                          onSelected: finance.isOwner
                              ? (_) => setState(() => _colorValue = color)
                              : null,
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: finance.isOwner && !_saving ? _save : null,
                    child: Text(_saving ? 'Salvando...' : 'Salvar alterações'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: finance.isOwner && !_saving ? _archive : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    icon: const Icon(Icons.archive_outlined),
                    label: const Text('Arquivar espaço'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
