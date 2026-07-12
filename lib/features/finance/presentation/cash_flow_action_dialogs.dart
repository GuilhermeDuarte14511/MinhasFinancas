import 'package:flutter/material.dart';

import '../domain/cash_flow.dart';
import 'cash_flow_labels.dart';

enum CashFlowSeriesAction { edit, delete }

Future<RecurrenceScope?> showCashFlowScopePicker(
  BuildContext context, {
  required CashFlowSeriesAction action,
}) => showModalBottomSheet<RecurrenceScope>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) => SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              action == CashFlowSeriesAction.delete
                  ? 'Qual parte da recorrência deseja excluir?'
                  : 'Onde aplicar esta alteração?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              action == CashFlowSeriesAction.delete
                  ? 'Escolher esta ocorrência e as próximas preserva todos os lançamentos anteriores.'
                  : 'Cada ocorrência pode manter seu próprio status e suas alterações específicas.',
            ),
            const SizedBox(height: 12),
            for (final scope in RecurrenceScope.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_scopeIcon(scope)),
                title: Text(recurrenceScopeLabel(scope)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(context, scope),
              ),
          ],
        ),
      ),
    ),
  ),
);

IconData _scopeIcon(RecurrenceScope scope) => switch (scope) {
  RecurrenceScope.single => Icons.looks_one_outlined,
  RecurrenceScope.thisAndFuture => Icons.fast_forward_rounded,
  RecurrenceScope.entireSeries => Icons.all_inclusive_rounded,
};
