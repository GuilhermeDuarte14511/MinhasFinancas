import 'dart:convert';

import 'package:firebase_data_connect/firebase_data_connect.dart';

import '../../../core/money/money.dart';
import '../domain/cash_flow.dart';
import 'sql_connect_generated/client.dart'
    hide CashFlowDirection, CashFlowKind, CashFlowPaymentMethod, CashFlowStatus;

final class WorkspaceHistoryPage<T> {
  const WorkspaceHistoryPage({
    required this.items,
    required this.nextOffset,
    required this.hasMore,
  });

  final List<T> items;
  final int nextOffset;
  final bool hasMore;
}

final class WorkspaceActivityRecord {
  const WorkspaceActivityRecord({
    required this.id,
    required this.person,
    required this.description,
    required this.occurredAt,
    required this.entityType,
    required this.entityId,
    required this.action,
  });

  final String id;
  final String person;
  final String description;
  final DateTime occurredAt;
  final String entityType;
  final String entityId;
  final String action;
}

final class WorkspaceHistoryDataSource {
  const WorkspaceHistoryDataSource();

  Future<WorkspaceHistoryPage<CashFlowEntry>> listCashFlowHistory({
    required String spaceId,
    required int limit,
    required int offset,
  }) async {
    final requestedLimit = limit + 1;
    final variables = _WorkspaceHistoryVariables(
      spaceId: spaceId,
      limit: requestedLimit,
      offset: offset,
    );
    _CashFlowHistoryResponse dataDeserializer(dynamic json) =>
        _CashFlowHistoryResponse.fromJson(jsonDecode(json));
    String varsSerializer(_WorkspaceHistoryVariables value) =>
        jsonEncode(value.toJson());

    final result = await ClientConnector.instance.dataConnect
        .query(
          'ListWorkspaceCashFlowHistory',
          dataDeserializer,
          varsSerializer,
          variables,
        )
        .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

    final received = result.data.items;
    final hasMore = received.length > limit;
    final items = hasMore ? received.take(limit).toList() : received;

    return WorkspaceHistoryPage(
      items: items,
      nextOffset: offset + items.length,
      hasMore: hasMore,
    );
  }

  Future<WorkspaceHistoryPage<WorkspaceActivityRecord>> listActivityHistory({
    required String spaceId,
    required int limit,
    required int offset,
  }) async {
    final requestedLimit = limit + 1;
    final variables = _WorkspaceHistoryVariables(
      spaceId: spaceId,
      limit: requestedLimit,
      offset: offset,
    );
    _ActivityHistoryResponse dataDeserializer(dynamic json) =>
        _ActivityHistoryResponse.fromJson(jsonDecode(json));
    String varsSerializer(_WorkspaceHistoryVariables value) =>
        jsonEncode(value.toJson());

    final result = await ClientConnector.instance.dataConnect
        .query(
          'ListWorkspaceActivityHistory',
          dataDeserializer,
          varsSerializer,
          variables,
        )
        .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

    final received = result.data.items;
    final hasMore = received.length > limit;
    final items = hasMore ? received.take(limit).toList() : received;

    return WorkspaceHistoryPage(
      items: items,
      nextOffset: offset + items.length,
      hasMore: hasMore,
    );
  }
}

final class _WorkspaceHistoryVariables {
  const _WorkspaceHistoryVariables({
    required this.spaceId,
    required this.limit,
    required this.offset,
  });

  final String spaceId;
  final int limit;
  final int offset;

  Map<String, dynamic> toJson() => {
    'spaceId': spaceId,
    'limit': limit,
    'offset': offset,
  };
}

final class _CashFlowHistoryResponse {
  const _CashFlowHistoryResponse(this.items);

  factory _CashFlowHistoryResponse.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    final values = map['cashFlowEntries'] as List<dynamic>? ?? const [];
    return _CashFlowHistoryResponse(
      values
          .map((item) => _cashFlowEntryFromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<CashFlowEntry> items;
}

final class _ActivityHistoryResponse {
  const _ActivityHistoryResponse(this.items);

  factory _ActivityHistoryResponse.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    final values = map['auditEvents'] as List<dynamic>? ?? const [];
    return _ActivityHistoryResponse(
      values
          .map((item) => _activityFromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<WorkspaceActivityRecord> items;
}

CashFlowEntry _cashFlowEntryFromJson(Map<String, dynamic> json) {
  final category = json['category'] as Map<String, dynamic>?;
  final recurrenceSeries = json['recurrenceSeries'] as Map<String, dynamic>?;
  final createdByUser = json['createdByUser'] as Map<String, dynamic>?;

  return CashFlowEntry(
    id: json['id'] as String,
    direction: _cashFlowDirection(json['direction'] as String),
    kind: _cashFlowKind(json['kind'] as String),
    paymentMethod: _cashFlowPaymentMethod(json['paymentMethod'] as String),
    description: json['description'] as String,
    amount: Money.fromCents(_intFromJson(json['amountCents'])),
    occurredAt: _timestampFromJson(json['occurredAt']),
    competenceMonth: DateTime.parse(json['competenceMonth'].toString()),
    status: _cashFlowStatus(json['status'] as String),
    createdBy:
        (createdByUser?['displayName'] as String?)?.trim().isNotEmpty == true
        ? (createdByUser!['displayName'] as String).trim()
        : 'Usuário do espaço',
    categoryId: category?['id'] as String?,
    categoryName: category?['name'] as String?,
    notes: json['notes'] as String?,
    sourceType: json['sourceType'] as String?,
    sourceEntityId: json['sourceEntityId'] as String?,
    recurrenceSeriesId: recurrenceSeries?['id'] as String?,
    occurrenceIndex: json['occurrenceIndex'] as int?,
    isRecurrenceException: json['isRecurrenceException'] as bool? ?? false,
    receivedAt: json['receivedAt'] == null
        ? null
        : _timestampFromJson(json['receivedAt']),
    paidAt: json['paidAt'] == null ? null : _timestampFromJson(json['paidAt']),
  );
}

WorkspaceActivityRecord _activityFromJson(Map<String, dynamic> json) {
  final actorUser = json['actorUser'] as Map<String, dynamic>?;
  final person = (actorUser?['displayName'] as String?)?.trim();

  return WorkspaceActivityRecord(
    id: json['id'] as String,
    person: person?.isNotEmpty == true ? person! : 'Usuário do espaço',
    description: json['summary'] as String,
    occurredAt: _timestampFromJson(json['occurredAt']),
    entityType: json['entityType'] as String,
    entityId: json['entityId'] as String,
    action: json['action'] as String,
  );
}

int _intFromJson(dynamic value) => int.parse(value.toString());

DateTime _timestampFromJson(dynamic value) =>
    Timestamp.fromJson(value).toDateTime().toLocal();

CashFlowDirection _cashFlowDirection(String value) =>
    value == 'INCOME' ? CashFlowDirection.income : CashFlowDirection.expense;

CashFlowKind _cashFlowKind(String value) => switch (value) {
  'SALARY' => CashFlowKind.salary,
  'THIRTEENTH_SALARY' => CashFlowKind.thirteenthSalary,
  'VACATION_PAY' => CashFlowKind.vacationPay,
  'BONUS' => CashFlowKind.bonus,
  'REFUND' => CashFlowKind.refund,
  'BILL' => CashFlowKind.bill,
  'CASH_PURCHASE' => CashFlowKind.cashPurchase,
  'CARD_PURCHASE' => CashFlowKind.cardPurchase,
  'SUBSCRIPTION' => CashFlowKind.subscription,
  'TAX' => CashFlowKind.tax,
  'LOAN_PAYMENT' => CashFlowKind.loanPayment,
  'OTHER_INCOME' => CashFlowKind.otherIncome,
  _ => CashFlowKind.otherExpense,
};

CashFlowPaymentMethod _cashFlowPaymentMethod(String value) => switch (value) {
  'PIX' => CashFlowPaymentMethod.pix,
  'CASH' => CashFlowPaymentMethod.cash,
  'BANK_TRANSFER' => CashFlowPaymentMethod.bankTransfer,
  'DEBIT_CARD' => CashFlowPaymentMethod.debitCard,
  'CREDIT_CARD' => CashFlowPaymentMethod.creditCard,
  _ => CashFlowPaymentMethod.other,
};

CashFlowStatus _cashFlowStatus(String value) => switch (value) {
  'PLANNED' => CashFlowStatus.scheduled,
  'CANCELLED' => CashFlowStatus.cancelled,
  _ => CashFlowStatus.confirmed,
};
