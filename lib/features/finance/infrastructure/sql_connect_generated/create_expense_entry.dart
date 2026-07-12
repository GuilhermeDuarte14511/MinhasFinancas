part of 'client.dart';

class CreateExpenseEntryVariablesBuilder {
  String spaceId;
  String categoryId;
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Timestamp occurredAt;
  DateTime competenceMonth;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;
  CreateExpenseEntryVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  CreateExpenseEntryVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.categoryId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.idempotencyKey,
  });
  Deserializer<CreateExpenseEntryData> dataDeserializer = (dynamic json) =>
      CreateExpenseEntryData.fromJson(jsonDecode(json));
  Serializer<CreateExpenseEntryVariables> varsSerializer =
      (CreateExpenseEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateExpenseEntryData, CreateExpenseEntryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CreateExpenseEntryData, CreateExpenseEntryVariables> ref() {
    CreateExpenseEntryVariables vars = CreateExpenseEntryVariables(
      spaceId: spaceId,
      categoryId: categoryId,
      description: description,
      kind: kind,
      paymentMethod: paymentMethod,
      amountCents: amountCents,
      occurredAt: occurredAt,
      competenceMonth: competenceMonth,
      notes: _notes,
      idempotencyKey: idempotencyKey,
    );
    return _dataConnect.mutation(
      "CreateExpenseEntry",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateExpenseEntryEntry {
  final String id;
  CreateExpenseEntryEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateExpenseEntryEntry otherTyped = other as CreateExpenseEntryEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateExpenseEntryEntry({required this.id});
}

@immutable
class CreateExpenseEntryAudit {
  final String id;
  CreateExpenseEntryAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateExpenseEntryAudit otherTyped = other as CreateExpenseEntryAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateExpenseEntryAudit({required this.id});
}

@immutable
class CreateExpenseEntryData {
  final CreateExpenseEntryEntry entry;
  final CreateExpenseEntryAudit audit;
  CreateExpenseEntryData.fromJson(dynamic json)
    : entry = CreateExpenseEntryEntry.fromJson(json['entry']),
      audit = CreateExpenseEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateExpenseEntryData otherTyped = other as CreateExpenseEntryData;
    return entry == otherTyped.entry && audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([entry.hashCode, audit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entry'] = entry.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateExpenseEntryData({required this.entry, required this.audit});
}

@immutable
class CreateExpenseEntryVariables {
  final String spaceId;
  final String categoryId;
  final String description;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  late final Optional<String> notes;
  final String idempotencyKey;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateExpenseEntryVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      categoryId = nativeFromJson<String>(json['categoryId']),
      description = nativeFromJson<String>(json['description']),
      kind = CashFlowKind.values.byName(json['kind']),
      paymentMethod = CashFlowPaymentMethod.values.byName(
        json['paymentMethod'],
      ),
      amountCents = bigIntFromJson(json['amountCents']),
      occurredAt = Timestamp.fromJson(json['occurredAt']),
      competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
      idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null
        ? null
        : nativeFromJson<String>(json['notes']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateExpenseEntryVariables otherTyped =
        other as CreateExpenseEntryVariables;
    return spaceId == otherTyped.spaceId &&
        categoryId == otherTyped.categoryId &&
        description == otherTyped.description &&
        kind == otherTyped.kind &&
        paymentMethod == otherTyped.paymentMethod &&
        amountCents == otherTyped.amountCents &&
        occurredAt == otherTyped.occurredAt &&
        competenceMonth == otherTyped.competenceMonth &&
        notes == otherTyped.notes &&
        idempotencyKey == otherTyped.idempotencyKey;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    categoryId.hashCode,
    description.hashCode,
    kind.hashCode,
    paymentMethod.hashCode,
    amountCents.hashCode,
    occurredAt.hashCode,
    competenceMonth.hashCode,
    notes.hashCode,
    idempotencyKey.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['description'] = nativeToJson<String>(description);
    json['kind'] = kind.name;
    json['paymentMethod'] = paymentMethod.name;
    json['amountCents'] = bigIntToJson(amountCents);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    if (notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  CreateExpenseEntryVariables({
    required this.spaceId,
    required this.categoryId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.notes,
    required this.idempotencyKey,
  });
}
