import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';

class CreateSpacePage extends ConsumerStatefulWidget {
  const CreateSpacePage({super.key});

  @override
  ConsumerState<CreateSpacePage> createState() => _CreateSpacePageState();
}

class _CreateSpacePageState extends ConsumerState<CreateSpacePage> {
  static const _spaceColors = [
    0xFF3525CD,
    0xFF006A63,
    0xFF3D37A9,
    0xFF4F6F52,
    0xFF777587,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Finanças da Família');
  int _selectedColor = _spaceColors.first;
  bool _isCreating = false;

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isCreating = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .createSpace(_nameController.text.trim(), colorValue: _selectedColor);
      if (!mounted) return;
      showSuccessMessage(context, 'Espaço criado com sucesso.');
      context.go('/invite-member?onboarding=true');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível criar o espaço.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Criar espaço', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: Form(
              key: _formKey,
              child: StaggeredColumn(
                step: const Duration(milliseconds: 70),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFFE2DFFF),
                    child: Icon(
                      Icons.home_work_rounded,
                      size: 42,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Como vocês vão chamar este espaço?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'O nome aparecerá para todos os membros convidados.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome do espaço financeiro',
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) >= 3
                        ? null
                        : 'Informe um nome com pelo menos 3 caracteres.',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Personalize com uma cor',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    children: [
                      for (final colorValue in _spaceColors)
                        Semantics(
                          label: 'Selecionar cor do espaço',
                          selected: _selectedColor == colorValue,
                          button: true,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                setState(() => _selectedColor = colorValue),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(colorValue),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == colorValue
                                      ? AppColors.text
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                scale: _selectedColor == colorValue ? 1 : 0,
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Card(
                    color: AppColors.surfaceLow,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Somente pessoas convidadas poderão visualizar as informações.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _isCreating ? null : _create,
                    child: Text(
                      _isCreating
                          ? 'Criando espaço...'
                          : 'Criar espaço e continuar',
                    ),
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
