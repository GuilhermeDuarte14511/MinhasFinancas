import 'package:flutter/material.dart';

import '../navigation/workspace_history_navigation.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final historyDestination = switch (title) {
      'Movimentações recentes' => WorkspaceHistoryDestination.movements,
      'Atividades do espaço' => WorkspaceHistoryDestination.activities,
      'Próximos compromissos' => WorkspaceHistoryDestination.commitments,
      _ => null,
    };
    final resolvedActionLabel =
        actionLabel ?? (historyDestination == null ? null : 'Ver mais');
    final resolvedOnAction =
        onAction ??
        (historyDestination == null
            ? null
            : () {
                openWorkspaceHistory(context, historyDestination);
              });

    final titleWidget = Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
    if (resolvedActionLabel == null) return titleWidget;

    final action = TextButton(
      onPressed: resolvedOnAction,
      child: Text(resolvedActionLabel),
    );
    final enlargedText = MediaQuery.textScalerOf(context).scale(14) >= 21;
    if (enlargedText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleWidget,
          Align(alignment: Alignment.centerRight, child: action),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: titleWidget),
        action,
      ],
    );
  }
}
