part of 'client.dart';

class UpdateCashFlowOccurrenceVariablesBuilder {
  String spaceId;
  String entryId;
  CashFlowMutationScope scope;
  Optional<String> _categoryId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Timestamp occurredAt;
  DateTime competenceMonth;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  CashFlowStatus status;
  Optional<Timestamp> _receivedAt = Optional.optional(
    (json) => json['receivedAt'] = Timestamp.fromJson(json['receivedAt']),
    defaultSerializer,
  );
  Optional<Timestamp> _paidAt = Optional.optional(
    (json) => json['paidAt'] = Timestamp.fromJson(json['paidAt']),
    defaultSerializer,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateCashFlowOccurrenceVariablesBuilder categoryId(String? t) {
    _categoryId.value = t;
    return this;
  }

  UpdateCashFlowOccurrenceVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  UpdateCashFlowOccurrenceVariablesBuilder receivedAt(Timestamp? t) {
    _receivedAt.value = t;
    return this;
  }

  UpdateCashFlowOccurrenceVariablesBuilder paidAt(Timestamp? t) {
    _paidAt.value = t;
    return this;
  }

  UpdateCashFlowOccurrenceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.entryId,
    required this.scope,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.status,
  });
  Deserializer<UpdateCashFlowOccurrenceData> dataDeserializer =
      (dynamic json) => UpdateCashFlowOccurrenceData.fromJson(jsonDecode(json));
  Serializer<UpdateCashFlowOccurrenceVariables> varsSerializer =
      (UpdateCashFlowOccurrenceVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      UpdateCashFlowOccurrenceData,
      UpdateCashFlowOccurrenceVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateCashFlowOccurrenceData, UpdateCashFlowOccurrenceVariables>
  ref() {
    UpdateCashFlowOccurrenceVariables vars = UpdateCashFlowOccurrenceVariables(
      spaceId: spaceId,
      entryId: entryId,
      scope: scope,
      categoryId: _categoryId,
      description: description,
      kind: kind,
      paymentMethod: paymentMethod,
      amountCents: amountCents,
      occurredAt: occurredAt,
      competenceMonth: competenceMonth,
      notes: _notes,
      status: status,
      receivedAt: _receivedAt,
      paidAt: _paidAt,
    );
    return _dataConnect.mutation(
      "UpdateCashFlowOccurrence",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateCashFlowOccurrenceEntry {
  final String id;
  UpdateCashFlowOccurrenceEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCashFlowOccurrenceEntry otherTyped =
        other as UpdateCashFlowOccurrenceEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCashFlowOccurrenceEntry({required this.id});
}

@immutable
class UpdateCashFlowOccurrenceData {
  final UpdateCashFlowOccurrenceEntry? entry;
  UpdateCashFlowOccurrenceData.fromJson(dynamic json)
    : entry = json['entry'] == null
          ? null
          : UpdateCashFlowOccurrenceEntry.fromJson(json['entry']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCashFlowOccurrenceData otherTyped =
        other as UpdateCashFlowOccurrenceData;
    return entry == otherTyped.entry;
  }

  @override
  int get hashCode => entry.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (entry != null) {
      json['entry'] = entry!.toJson();
    }
    return json;
  }

  UpdateCashFlowOccurrenceData({this.entry});
}

@immutable
class UpdateCashFlowOccurrenceVariables {
  final String spaceId;
  final String entryId;
  final CashFlowMutationScope scope;
  late final Optional<String> categoryId;
  final String description;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  late final Optional<String> notes;
  final CashFlowStatus status;
  late final Optional<Timestamp> receivedAt;
  late final Optional<Timestamp> paidAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateCashFlowOccurrenceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      entryId = nativeFromJson<String>(json['entryId']),
      scope = CashFlowMutationScope.values.byName(json['scope']),
      description = nativeFromJson<String>(json['description']),
      kind = CashFlowKind.values.byName(json['kind']),
      paymentMethod = CashFlowPaymentMethod.values.byName(
        json['paymentMethod'],
      ),
      amountCents = bigIntFromJson(json['amountCents']),
      occurredAt = Timestamp.fromJson(json['occurredAt']),
      competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
      status = CashFlowStatus.values.byName(json['status']) {
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null
        ? null
        : nativeFromJson<String>(json['categoryId']);

    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null
        ? null
        : nativeFromJson<String>(json['notes']);

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
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCashFlowOccurrenceVariables otherTyped =
        other as UpdateCashFlowOccurrenceVariables;
    return spaceId == otherTyped.spaceId &&
        entryId == otherTyped.entryId &&
        scope == otherTyped.scope &&
        categoryId == otherTyped.categoryId &&
        description == otherTyped.description &&
        kind == otherTyped.kind &&
        paymentMethod == otherTyped.paymentMethod &&
        amountCents == otherTyped.amountCents &&
        occurredAt == otherTyped.occurredAt &&
        competenceMonth == otherTyped.competenceMonth &&
        notes == otherTyped.notes &&
        status == otherTyped.status &&
        receivedAt == otherTyped.receivedAt &&
        paidAt == otherTyped.paidAt;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    entryId.hashCode,
    scope.hashCode,
    categoryId.hashCode,
    description.hashCode,
    kind.hashCode,
    paymentMethod.hashCode,
    amountCents.hashCode,
    occurredAt.hashCode,
    competenceMonth.hashCode,
    notes.hashCode,
    status.hashCode,
    receivedAt.hashCode,
    paidAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['scope'] = scope.name;
    if (categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    json['kind'] = kind.name;
    json['paymentMethod'] = paymentMethod.name;
    json['amountCents'] = bigIntToJson(amountCents);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    if (notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['status'] = status.name;
    if (receivedAt.state == OptionalState.set) {
      json['receivedAt'] = receivedAt.toJson();
    }
    if (paidAt.state == OptionalState.set) {
      json['paidAt'] = paidAt.toJson();
    }
    return json;
  }

  UpdateCashFlowOccurrenceVariables({
    required this.spaceId,
    required this.entryId,
    required this.scope,
    required this.categoryId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.notes,
    required this.status,
    required this.receivedAt,
    required this.paidAt,
  });
}
