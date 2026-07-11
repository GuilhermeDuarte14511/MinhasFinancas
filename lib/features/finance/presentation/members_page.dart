import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  String? _busyMemberId;

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final activeMembers = finance.members
        .where((member) => member.status == MembershipStatus.active)
        .toList();
    final canInvite = finance.currentRole != MembershipRole.viewer;
    final canManage = finance.currentRole == MembershipRole.owner;
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Membros',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Configurar espaço',
            onPressed: () => context.push('/workspace-settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
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
                      finance.spaceName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text('Pessoas que organizam as finanças com você.'),
                    const SizedBox(height: 22),
                    if (activeMembers.isEmpty)
                      const _MembersEmptyState()
                    else
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            for (
                              var index = 0;
                              index < activeMembers.length;
                              index++
                            ) ...[
                              _MemberTile(
                                member: activeMembers[index],
                                busy: _busyMemberId == activeMembers[index].id,
                                canManage:
                                    canManage &&
                                    !activeMembers[index].isCurrentUser &&
                                    activeMembers[index].role !=
                                        MembershipRole.owner,
                                onChangeRole: (role) =>
                                    _changeRole(activeMembers[index], role),
                                onRemove: () =>
                                    _confirmRemove(activeMembers[index]),
                              ),
                              if (index < activeMembers.length - 1)
                                const Divider(height: 1),
                            ],
                          ],
                        ),
                      ),
                    if (finance.invitations.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/pending-invitations'),
                        icon: const Icon(Icons.mark_email_unread_outlined),
                        label: Text(
                          finance.invitations.length == 1
                              ? 'Ver 1 convite pendente'
                              : 'Ver ${finance.invitations.length} convites pendentes',
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: canInvite
                          ? () => context.push('/invite-member')
                          : null,
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Convidar membro'),
                    ),
                    if (!canInvite) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Seu papel permite visualizar, mas não convidar pessoas.',
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

  Future<void> _changeRole(MemberRecord member, MembershipRole role) async {
    setState(() => _busyMemberId = member.id);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateMemberRole(member.id, role);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Papel de ${member.name} atualizado.')),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busyMemberId = null);
    }
  }

  Future<void> _confirmRemove(MemberRecord member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover membro?'),
        content: Text(
          '${member.name} perderá o acesso a este espaço financeiro.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busyMemberId = member.id);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .removeMember(member.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${member.name} foi removido.')));
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busyMemberId = null);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Não foi possível concluir: $error')),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.busy,
    required this.canManage,
    required this.onChangeRole,
    required this.onRemove,
  });

  final MemberRecord member;
  final bool busy;
  final bool canManage;
  final ValueChanged<MembershipRole> onChangeRole;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final visibleName = member.name.trim().isEmpty ? member.email : member.name;
    return ListTile(
      minTileHeight: 82,
      leading: CircleAvatar(
        backgroundColor: member.isCurrentUser
            ? AppColors.secondaryContainer
            : const Color(0xFFE2DFFF),
        child: Text(visibleName.characters.first.toUpperCase()),
      ),
      title: Row(
        children: [
          Flexible(child: Text(visibleName)),
          if (member.isCurrentUser) ...[
            const SizedBox(width: 6),
            const Text(
              '(você)',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
      subtitle: Text(member.email),
      trailing: busy
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RolePill(role: member.role),
                if (canManage)
                  PopupMenuButton<String>(
                    tooltip: 'Gerenciar membro',
                    onSelected: (value) {
                      if (value == 'editor') {
                        onChangeRole(MembershipRole.editor);
                      } else if (value == 'viewer') {
                        onChangeRole(MembershipRole.viewer);
                      } else if (value == 'remove') {
                        onRemove();
                      }
                    },
                    itemBuilder: (context) => [
                      CheckedPopupMenuItem(
                        value: 'editor',
                        checked: member.role == MembershipRole.editor,
                        child: const Text('Editor'),
                      ),
                      CheckedPopupMenuItem(
                        value: 'viewer',
                        checked: member.role == MembershipRole.viewer,
                        child: const Text('Visualizador'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text(
                          'Remover do espaço',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role});

  final MembershipRole role;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (role) {
      MembershipRole.owner => ('Proprietário', AppColors.secondary),
      MembershipRole.editor => ('Editor', AppColors.primary),
      MembershipRole.viewer => ('Visualizador', AppColors.textMuted),
    };
    return StatusPill(label: label, color: color);
  }
}

class _MembersEmptyState extends StatelessWidget {
  const _MembersEmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(
              Icons.group_outlined,
              size: 46,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Nenhum membro encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Convide alguém para organizar este espaço com você.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
