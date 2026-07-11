import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class PendingInvitationsPage extends ConsumerStatefulWidget {
  const PendingInvitationsPage({super.key});

  @override
  ConsumerState<PendingInvitationsPage> createState() =>
      _PendingInvitationsPageState();
}

class _PendingInvitationsPageState
    extends ConsumerState<PendingInvitationsPage> {
  String? _busyInvitationId;

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final invitations = finance.invitations;
    final canManage = finance.currentRole == MembershipRole.owner;
    return Scaffold(
      appBar: const BrandAppBar(title: 'Convites pendentes', showBack: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(financeControllerProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              AppContent(
                child: StaggeredColumn(
                  step: const Duration(milliseconds: 70),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Aguardando resposta',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Acompanhe os convites enviados para este espaço.',
                    ),
                    const SizedBox(height: 24),
                    if (invitations.isEmpty)
                      const _NoPendingInvitations()
                    else
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            for (
                              var index = 0;
                              index < invitations.length;
                              index++
                            ) ...[
                              _InvitationTile(
                                invitation: invitations[index],
                                busy:
                                    _busyInvitationId == invitations[index].id,
                                canRevoke: canManage,
                                onRevoke: () =>
                                    _confirmRevoke(invitations[index]),
                              ),
                              if (index < invitations.length - 1)
                                const Divider(height: 1),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: finance.currentRole == MembershipRole.viewer
                          ? null
                          : () => context.push('/invite-member'),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Enviar outro convite'),
                    ),
                    if (!canManage && invitations.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Somente o proprietário pode revogar convites.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRevoke(InvitationRecord invitation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar convite?'),
        content: Text(
          '${invitation.email} não poderá mais usar o link enviado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busyInvitationId = invitation.id);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .revokeInvitation(invitation.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Convite revogado.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível revogar: $error')),
      );
    } finally {
      if (mounted) setState(() => _busyInvitationId = null);
    }
  }
}

class _InvitationTile extends StatelessWidget {
  const _InvitationTile({
    required this.invitation,
    required this.busy,
    required this.canRevoke,
    required this.onRevoke,
  });

  final InvitationRecord invitation;
  final bool busy;
  final bool canRevoke;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 86,
      leading: const CircleAvatar(
        backgroundColor: AppColors.surfaceContainer,
        child: Icon(Icons.mail_outline_rounded, color: AppColors.primary),
      ),
      title: Text(invitation.email),
      subtitle: Text(
        '${_roleLabel(invitation.role)} • expira em ${_dateLabel(invitation.expiresAt)}',
      ),
      trailing: busy
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : canRevoke
          ? PopupMenuButton<String>(
              tooltip: 'Ações do convite',
              onSelected: (value) {
                if (value == 'revoke') onRevoke();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'revoke',
                  child: Text(
                    'Revogar convite',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            )
          : const StatusPill(label: 'Pendente', color: AppColors.primary),
    );
  }
}

class _NoPendingInvitations extends StatelessWidget {
  const _NoPendingInvitations();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 14),
            Text('Tudo em dia', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text('Não há convites aguardando resposta.'),
          ],
        ),
      ),
    );
  }
}

String _roleLabel(MembershipRole role) => switch (role) {
  MembershipRole.owner => 'Proprietário',
  MembershipRole.editor => 'Editor',
  MembershipRole.viewer => 'Visualizador',
};

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
