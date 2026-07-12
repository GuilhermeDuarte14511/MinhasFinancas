import 'package:flutter/material.dart';

enum WorkspaceHistoryDestination { movements, activities }

typedef WorkspaceHistoryPageBuilder =
    Widget Function(WorkspaceHistoryDestination destination);

WorkspaceHistoryPageBuilder? _workspaceHistoryPageBuilder;

void registerWorkspaceHistoryPageBuilder(
  WorkspaceHistoryPageBuilder builder,
) {
  _workspaceHistoryPageBuilder = builder;
}

Future<void> openWorkspaceHistory(
  BuildContext context,
  WorkspaceHistoryDestination destination,
) async {
  final builder = _workspaceHistoryPageBuilder;
  if (builder == null) {
    throw StateError('A tela de histórico não foi registrada.');
  }

  await Navigator.of(context).push<void>(
    MaterialPageRoute(builder: (_) => builder(destination)),
  );
}
