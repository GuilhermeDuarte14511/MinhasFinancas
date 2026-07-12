import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/navigation/workspace_history_navigation.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';
import '../infrastructure/workspace_history_data_source.dart';
import 'cash_flow_entry_detail_page.dart';
import 'cash_flow_labels.dart';

class WorkspaceHistoryPage extends ConsumerStatefulWidget {
  const WorkspaceHistoryPage({
    required this.initialSection,
    super.key,
  });

  final WorkspaceHistoryDestination initialSection;

  @override
  ConsumerState<WorkspaceHistoryPage> createState() =>
      _WorkspaceHistoryPageState();
}

class _WorkspaceHistoryPageState extends ConsumerState<WorkspaceHistoryPage> {
  static const _pageSize = 25;
  static const _dataSource = WorkspaceHistoryDataSource();

  late WorkspaceHistoryDestination _section;
  final List<CashFlowEntry> _movements = [];
  final List<WorkspaceActivityRecord> _activities = [];
  var _movementOffset = 0;
  var _activityOffset = 0;
  var _movementHasMore = true;
  var _activityHasMore = true;
  var _loadingMovements = false;
  var _loadingActivities = false;
  String? _movementError;
  String? _activityError;

  @override
  void initState() {
    super.initState();
    _section = widget.initialSection;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSelected());
  }

  String get _spaceId {
    final value = ref.read(financeControllerProvider).spaceId;
    if (value == null) throw StateError('Nenhum espaço financeiro selecionado.');
    return value;
  }

  Future<void> _loadSelected({bool reset = false}) =>
      _section == WorkspaceHistoryDestination.movements
      ? _loadMovements(reset: reset)
      : _loadActivities(reset: reset);

  Future<void> _loadMovements({bool reset = false}) async {
    if (_loadingMovements || (!reset && !_movementHasMore)) return;
    setState(() {
      _loadingMovements = true;
      _movementError = null;
      if (reset) {
        _movements.clear();
        _movementOffset = 0;
        _movementHasMore = true;
      }
    });
    try {
      final page = await _dataSource.listCashFlowHistory(
        spaceId: _spaceId,
        limit: _pageSize,
        offset: _movementOffset,
      );
      if (!mounted) return;
      setState(() {
        _movements.addAll(page.items);
        _movementOffset = page.nextOffset;
        _movementHasMore = page.hasMore;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _movementError =
            'Não foi possível carregar as movimentações. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _loadingMovements = false);
    }
  }

  Future<void> _loadActivities({bool reset = false}) async {
    if (_loadingActivities || (!reset && !_activityHasMore)) return;
    setState(() {
      _loadingActivities = true;
      _activityError = null;
      if (reset) {
        _activities.clear();
        _activityOffset = 0;
        _activityHasMore = true;
      }
    });
    try {
      final page = await _dataSource.listActivityHistory(
        spaceId: _spaceId,
        limit: _pageSize,
        offset: _activityOffset,
      );
      if (!mounted) return;
      setState(() {
        _activities.addAll(page.items);
        _activityOffset = page.nextOffset;
        _activityHasMore = page.hasMore;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _activityError =
            'Não foi possível carregar as atividades. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _loadingActivities = false);
    }
  }

  void _changeSection(WorkspaceHistoryDestination section) {
    if (_section == section) return;
    setState(() => _section = section);
    if (section == WorkspaceHistoryDestination.movements &&
        _movements.isEmpty) {
      _loadMovements();
    }
    if (section == WorkspaceHistoryDestination.activities &&
        _activities.isEmpty) {
      _loadActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Histórico do espaço', showBack: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: SegmentedButton<WorkspaceHistoryDestination>(
                segments: const [
                  ButtonSegment(
                    value: WorkspaceHistoryDestination.movements,
                    icon: Icon(Icons.swap_vert_rounded),
                    label: Text('Movimentações'),
                  ),
                  ButtonSegment(
                    value: WorkspaceHistoryDestination.activities,
                    icon: Icon(Icons.history_rounded),
                    label: Text('Atividades'),
                  ),
                ],
                selected: {_section},
                onSelectionChanged: (value) => _changeSection(value.first),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _section == WorkspaceHistoryDestination.movements
                    ? _MovementsView(
                        key: const ValueKey('movements'),
                        items: _movements,
                        loading: _loadingMovements,
                        hasMore: _movementHasMore,
                        error: _movementError,
                        onRefresh: () => _loadMovements(reset: true),
                        onLoadMore: _loadMovements,
                      )
                    : _ActivitiesView(
                        key: const ValueKey('activities'),
                        items: _activities,
                        loading: _loadingActivities,
                        hasMore: _activityHasMore,
                        error: _activityError,
                        onRefresh: () => _loadActivities(reset: true),
                        onLoadMore: _loadActivities,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementsView extends StatelessWidget {
  const _MovementsView({
    required this.items,
    required this.loading,
    required this.hasMore,
    required this.error,
    required this.onRefresh,
    required this.onLoadMore,
    super.key,
  });

  final List<CashFlowEntry> items;
  final bool loading;
  final bool hasMore;
  final String? error;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      children: [
        const Text(
          'Todas as entradas e saídas registradas neste espaço, das mais recentes para as mais antigas.',
        ),
        const SizedBox(height: 16),
        if (items.isEmpty && loading)
          const Padding(
            padding: EdgeInsets.all(36),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (items.isEmpty && error == null)
          const _EmptyHistory(
            icon: Icons.swap_vert_rounded,
            message: 'Nenhuma movimentação encontrada.',
          )
        else
          for (var index = 0; index < items.length; index++) ...[
            _MovementTile(entry: items[index]),
            if (index < items.length - 1) const Divider(height: 1),
          ],
        _HistoryFooter(
          loading: loading,
          hasMore: hasMore,
          error: error,
          onLoadMore: onLoadMore,
        ),
      ],
    ),
  );
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.entry});

  final CashFlowEntry entry;

  @override
  Widget build(BuildContext context) {
    final income = entry.direction == CashFlowDirection.income;
    final color = income ? AppColors.secondary : AppColors.error;
    final status = switch (entry.status) {
      CashFlowStatus.scheduled => income ? 'Prevista' : 'Pendente',
      CashFlowStatus.confirmed => income ? 'Recebida' : 'Paga',
      CashFlowStatus.cancelled => 'Cancelada',
    };
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CashFlowEntryDetailPage(
            entryId: entry.id,
            initialEntry: entry,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: .12),
        child: Icon(cashFlowKindIcon(entry.kind), color: color),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              entry.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${income ? '+' : '−'} ${entry.amount.format()}',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          '$status • ${cashFlowKindLabel(entry.kind)} • ${DateFormat("dd/MM/yyyy").format(entry.occurredAt)}\nCriado por ${entry.createdBy}',
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _ActivitiesView extends StatelessWidget {
  const _ActivitiesView({
    required this.items,
    required this.loading,
    required this.hasMore,
    required this.error,
    required this.onRefresh,
    required this.onLoadMore,
    super.key,
  });

  final List<WorkspaceActivityRecord> items;
  final bool loading;
  final bool hasMore;
  final String? error;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      children: [
        const Text(
          'Ações realizadas pelos participantes do espaço financeiro.',
        ),
        const SizedBox(height: 16),
        if (items.isEmpty && loading)
          const Padding(
            padding: EdgeInsets.all(36),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (items.isEmpty && error == null)
          const _EmptyHistory(
            icon: Icons.history_rounded,
            message: 'Nenhuma atividade encontrada.',
          )
        else
          for (final item in items) ...[
            Card(
              color: AppColors.surfaceLow,
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainer,
                  child: Text(
                    item.person.trim().isEmpty
                        ? '?'
                        : item.person.characters.first.toUpperCase(),
                  ),
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${item.person} ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: item.description),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat("dd/MM/yyyy 'às' HH:mm").format(item.occurredAt),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        _HistoryFooter(
          loading: loading,
          hasMore: hasMore,
          error: error,
          onLoadMore: onLoadMore,
        ),
      ],
    ),
  );
}

class _HistoryFooter extends StatelessWidget {
  const _HistoryFooter({
    required this.loading,
    required this.hasMore,
    required this.error,
    required this.onLoadMore,
  });

  final bool loading;
  final bool hasMore;
  final String? error;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          children: [
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: loading ? null : onLoadMore,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!hasMore) {
      return const Padding(
        padding: EdgeInsets.only(top: 18),
        child: Text('Fim do histórico.', textAlign: TextAlign.center),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: OutlinedButton.icon(
        onPressed: onLoadMore,
        icon: const Icon(Icons.expand_more_rounded),
        label: const Text('Carregar mais'),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 44),
    child: Column(
      children: [
        Icon(icon, size: 48, color: AppColors.textMuted),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
      ],
    ),
  );
}
