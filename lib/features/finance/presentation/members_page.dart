import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';

class MembersPage extends ConsumerWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    return Scaffold(
      appBar: const BrandAppBar(title: 'Membros', showBack: true),
      body: SafeArea(
        child: AppContent(
          child: StaggeredColumn(
            step: const Duration(milliseconds: 80),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                finance.spaceName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text('Pessoas que organizam as finanças com você.'),
              Expanded(
                child: Card(
                  child: ListView.separated(
                    itemCount: finance.members.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final member = finance.members[index];
                      final pending = member.contains('pendente');
                      return ListTile(
                        minTileHeight: 76,
                        leading: CircleAvatar(
                          backgroundColor: index.isEven
                              ? const Color(0xFFE2DFFF)
                              : AppColors.secondaryContainer,
                          child: Text(member.characters.first.toUpperCase()),
                        ),
                        title: Text(
                          member.replaceAll(' (convite pendente)', ''),
                        ),
                        subtitle: Text(
                          pending
                              ? 'Convite pendente'
                              : index == 0
                              ? 'Proprietário'
                              : 'Editor',
                        ),
                        trailing: pending
                            ? const StatusPill(
                                label: 'Pendente',
                                color: AppColors.primary,
                              )
                            : const Icon(Icons.more_vert_rounded),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => context.push('/invite-member'),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Convidar membro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
