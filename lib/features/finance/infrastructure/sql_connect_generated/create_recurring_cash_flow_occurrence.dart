part of 'client.dart';

class CreateRecurringCashFlowOccurrenceVariablesBuilder {
  String spaceId;
  String seriesId;
  int occurrenceIndex;
  Timestamp occurredAt;
  DateTime competenceMonth;
  CashFlowStatus status;
  Optional<Timestamp> _receivedAt = Optional.optional(
    (json) => json['receivedAt'] = Timestamp.fromJson(json['receivedAt']),
    defaultSerializer,
  );
  Optional<Timestamp> _paidAt = Optional.optional(
    (json) => json['paidAt'] = Timestamp.fromJson(json['paidAt']),
    defaultSerializer,
  );
  Optional<DateTime> _nextOccurrenceDate = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;
  CreateRecurringCashFlowOccurrenceVariablesBuilder receivedAt(Timestamp? t) {
    _receivedAt.value = t;
    return this;
  }

  CreateRecurringCashFlowOccurrenceVariablesBuilder paidAt(Timestamp? t) {
    _paidAt.value = t;
    return this;
  }

  CreateRecurringCashFlowOccurrenceVariablesBuilder nextOccurrenceDate(
    DateTime? t,
  ) {
    _nextOccurrenceDate.value = t;
    return this;
  }

  CreateRecurringCashFlowOccurrenceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.seriesId,
    required this.occurrenceIndex,
    required this.occurredAt,
    required this.competenceMonth,
    required this.status,
    required this.idempotencyKey,
  });
  Deserializer<CreateRecurringCashFlowOccurrenceData> dataDeserializer =
      (dynamic json) =>
          CreateRecurringCashFlowOccurrenceData.fromJson(jsonDecode(json));
  Serializer<CreateRecurringCashFlowOccurrenceVariables> varsSerializer =
      (CreateRecurringCashFlowOccurrenceVariables vars) =>
          jsonEncode(vars.toJson());
  Future<
    OperationResult<
      CreateRecurringCashFlowOccurrenceData,
      CreateRecurringCashFlowOccurrenceVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    CreateRecurringCashFlowOccurrenceData,
    CreateRecurringCashFlowOccurrenceVariables
  >
  ref() {
    CreateRecurringCashFlowOccurrenceVariables vars =
        CreateRecurringCashFlowOccurrenceVariables(
          spaceId: spaceId,
          seriesId: seriesId,
          occurrenceIndex: occurrenceIndex,
          occurredAt: occurredAt,
          competenceMonth: competenceMonth,
          status: status,
          receivedAt: _receivedAt,
          paidAt: _paidAt,
          nextOccurrenceDate: _nextOccurrenceDate,
          idempotencyKey: idempotencyKey,
        );
    return _dataConnect.mutation(
      "CreateRecurringCashFlowOccurrence",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateRecurringCashFlowOccurrenceEntry {
  final String id;
  CreateRecurringCashFlowOccurrenceEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRecurringCashFlowOccurrenceEntry otherTyped =
        other as CreateRecurringCashFlowOccurrenceEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateRecurringCashFlowOccurrenceEntry({required this.id});
}

@immutable
class CreateRecurringCashFlowOccurrenceSeriesProgress {
  final String id;
  CreateRecurringCashFlowOccurrenceSeriesProgress.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRecurringCashFlowOccurrenceSeriesProgress otherTyped =
        other as CreateRecurringCashFlowOccurrenceSeriesProgress;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateRecurringCashFlowOccurrenceSeriesProgress({required this.id});
}

@immutable
class CreateRecurringCashFlowOccurrenceData {
  final CreateRecurringCashFlowOccurrenceEntry entry;
  final CreateRecurringCashFlowOccurrenceSeriesProgress? seriesProgress;
  CreateRecurringCashFlowOccurrenceData.fromJson(dynamic json)
    : entry = CreateRecurringCashFlowOccurrenceEntry.fromJson(json['entry']),
      seriesProgress = json['seriesProgress'] == null
          ? null
          : CreateRecurringCashFlowOccurrenceSeriesProgress.fromJson(
              json['seriesProgress'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRecurringCashFlowOccurrenceData otherTyped =
        other as CreateRecurringCashFlowOccurrenceData;
    return entry == otherTyped.entry &&
        seriesProgress == otherTyped.seriesProgress;
  }

  @override
  int get hashCode => Object.hashAll([entry.hashCode, seriesProgress.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entry'] = entry.toJson();
    if (seriesProgress != null) {
      json['seriesProgress'] = seriesProgress!.toJson();
    }
    return json;
  }

  CreateRecurringCashFlowOccurrenceData({
    required this.entry,
    this.seriesProgress,
  });
}

@immutable
class CreateRecurringCashFlowOccurrenceVariables {
  final String spaceId;
  final String seriesId;
  final int occurrenceIndex;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  final CashFlowStatus status;
  late final Optional<Timestamp> receivedAt;
  late final Optional<Timestamp> paidAt;
  late final Optional<DateTime> nextOccurrenceDate;
  final String idempotencyKey;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateRecurringCashFlowOccurrenceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      seriesId = nativeFromJson<String>(json['seriesId']),
      occurrenceIndex = nativeFromJson<int>(json['occurrenceIndex']),
      occurredAt = Timestamp.fromJson(json['occurredAt']),
      competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
      status = CashFlowStatus.values.byName(json['status']),
      idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
    receivedAt = Optional.optional(
      (json) => json['receivedAt'] = Timestamp.fromJson(json['receivedAt']),
      defaultSerializer,
    );
    receivedAt.value = json['receivedAt'] == null
        ? null
        : Timestamp.fromJson(json['receivedAt']);

    paidAt = Optional.optional(
      (json) => json['paidAt'] = Timestamp.fromJson(json['paidAt']),
      defaultSerializer,
    );
    paidAt.value = json['paidAt'] == null
        ? null
        : Timestamp.fromJson(json['paidAt']);

    nextOccurrenceDate = Optional.optional(nativeFromJson, nativeToJson);
    nextOccurrenceDate.value = json['nextOccurrenceDate'] == null
        ? null
        : nativeFromJson<DateTime>(json['nextOccurrenceDate']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRecurringCashFlowOccurrenceVariables otherTyped =
        other as CreateRecurringCashFlowOccurrenceVariables;
    return spaceId == otherTyped.spaceId &&
        seriesId == otherTyped.seriesId &&
        occurrenceIndex == otherTyped.occurrenceIndex &&
        occurredAt == otherTyped.occurredAt &&
        competenceMonth == otherTyped.competenceMonth &&
        status == otherTyped.status &&
        receivedAt == otherTyped.receivedAt &&
        paidAt == otherTyped.paidAt &&
        nextOccurrenceDate == otherTyped.nextOccurrenceDate &&
        idempotencyKey == otherTyped.idempotencyKey;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    seriesId.hashCode,
    occurrenceIndex.hashCode,
    occurredAt.hashCode,
    competenceMonth.hashCode,
    status.hashCode,
    receivedAt.hashCode,
    paidAt.hashCode,
    nextOccurrenceDate.hashCode,
    idempotencyKey.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['seriesId'] = nativeToJson<String>(seriesId);
    json['occurrenceIndex'] = nativeToJson<int>(occurrenceIndex);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    json['status'] = status.name;
    if (receivedAt.state == OptionalState.set) {
      json['receivedAt'] = receivedAt.toJson();
    }
    if (paidAt.state == OptionalState.set) {
      json['paidAt'] = paidAt.toJson();
    }
    if (nextOccurrenceDate.state == OptionalState.set) {
      json['nextOccurrenceDate'] = nextOccurrenceDate.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  CreateRecurringCashFlowOccurrenceVariables({
    required this.spaceId,
    required this.seriesId,
    required this.occurrenceIndex,
    required this.occurredAt,
    required this.competenceMonth,
    required this.status,
    required this.receivedAt,
    required this.paidAt,
    required this.nextOccurrenceDate,
    required this.idempotencyKey,
  });
}
