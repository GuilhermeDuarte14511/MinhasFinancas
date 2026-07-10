import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/domain/finance_models.dart';

class InviteMemberPage extends ConsumerStatefulWidget {
  const InviteMemberPage({required this.onboarding, super.key});

  final bool onboarding;

  @override
  ConsumerState<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends ConsumerState<InviteMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  MembershipRole _role = MembershipRole.editor;
  bool _sending = false;
  int _errorTrigger = 0;
  String? _inviteLink;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _finish() {
    if (widget.onboarding) {
      context.go('/app/home');
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/members');
    }
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorTrigger++);
      return;
    }
    setState(() => _sending = true);
    try {
      final email = _emailController.text.trim();
      _inviteLink = await ref
          .read(financeControllerProvider.notifier)
          .inviteMember(email, role: _role);
      if (!mounted) return;
      showSuccessMessage(context, 'Convite criado para $email.');
      _finish();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível criar o convite.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _copyLink() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorTrigger++);
      return;
    }
    setState(() => _sending = true);
    try {
      final link =
          _inviteLink ??
          await ref
              .read(financeControllerProvider.notifier)
              .inviteMember(_emailController.text.trim(), role: _role);
      _inviteLink = link;
      await Clipboard.setData(ClipboardData(text: link));
      if (mounted) showSuccessMessage(context, 'Link de convite copiado.');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível criar o convite.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Convidar membro',
        showBack: true,
        actions: widget.onboarding
            ? [
                TextButton(onPressed: _finish, child: const Text('Pular')),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: ShakeOnError(
              trigger: _errorTrigger,
              child: Form(
                key: _formKey,
                child: StaggeredColumn(
                  step: const Duration(milliseconds: 70),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 158,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryContainer,
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 95,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Color(0xFFDAD7FF),
                              child: Icon(Icons.person_rounded, size: 40),
                            ),
                          ),
                          Positioned(
                            right: 95,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: AppColors.secondaryContainer,
                              child: Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 38,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.link_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Organizem juntos',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Convide alguém para gerenciar e acompanhar as finanças com você.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail do convidado',
                        hintText: 'exemplo@email.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : 'Informe um e-mail válido.',
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Permissão',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            selected: _role == MembershipRole.editor,
                            icon: Icons.edit_square,
                            title: 'Editor',
                            subtitle: 'Adiciona e edita transações.',
                            onTap: () =>
                                setState(() => _role = MembershipRole.editor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleCard(
                            selected: _role == MembershipRole.viewer,
                            icon: Icons.visibility_outlined,
                            title: 'Leitura',
                            subtitle: 'Apenas visualiza os dados.',
                            onTap: () =>
                                setState(() => _role = MembershipRole.viewer),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Card(
                      color: AppColors.surfaceLow,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'O acesso respeitará a permissão escolhida para este convite.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    FilledButton.icon(
                      onPressed: _sending ? null : _send,
                      icon: const Icon(Icons.send_rounded),
                      label: Text(_sending ? 'Enviando...' : 'Enviar convite'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _sending ? null : _copyLink,
                      icon: const Icon(Icons.link_rounded),
                      label: const Text('Copiar link de convite'),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: _finish,
                      child: const Text('Convidar depois'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceLow : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outline,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const Spacer(),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: selected ? 1 : 0,
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
