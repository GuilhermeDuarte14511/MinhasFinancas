import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';

class JoinSpacePage extends ConsumerStatefulWidget {
  const JoinSpacePage({this.initialInvite, super.key});

  final String? initialInvite;

  @override
  ConsumerState<JoinSpacePage> createState() => _JoinSpacePageState();
}

class _JoinSpacePageState extends ConsumerState<JoinSpacePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialInvite);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .joinSpace(_codeController.text.trim());
      if (!mounted) return;
      showSuccessMessage(context, 'Convite aceito. Bem-vindo ao espaço!');
      context.go('/app/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível aceitar este convite.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Entrar por convite', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: Form(
              key: _formKey,
              child: StaggeredColumn(
                step: const Duration(milliseconds: 80),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.secondaryContainer,
                      child: Icon(
                        Icons.mark_email_unread_outlined,
                        size: 44,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recebeu um convite?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cole o link ou digite o código enviado por quem administra o espaço.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _codeController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Link ou código do convite',
                      hintText: 'Ex: NOSSA-GRANA-2026',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) >= 4
                        ? null
                        : 'Informe um convite válido.',
                  ),
                  const SizedBox(height: 16),
                  const Card(
                    color: AppColors.surfaceLow,
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'O convite é validado com segurança e só pode ser usado pelo e-mail indicado.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _loading ? null : _join,
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      _loading ? 'Validando convite...' : 'Entrar no espaço',
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
