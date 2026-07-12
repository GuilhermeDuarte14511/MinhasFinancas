part of 'client.dart';

class CreateIncomeEntryVariablesBuilder {
  String spaceId;
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Timestamp occurredAt;
  DateTime competenceMonth;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;
  CreateIncomeEntryVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  CreateIncomeEntryVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.idempotencyKey,
  });
  Deserializer<CreateIncomeEntryData> dataDeserializer = (dynamic json) =>
      CreateIncomeEntryData.fromJson(jsonDecode(json));
  Serializer<CreateIncomeEntryVariables> varsSerializer =
      (CreateIncomeEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateIncomeEntryData, CreateIncomeEntryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CreateIncomeEntryData, CreateIncomeEntryVariables> ref() {
    CreateIncomeEntryVariables vars = CreateIncomeEntryVariables(
      spaceId: spaceId,
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
      "CreateIncomeEntry",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateIncomeEntryEntry {
  final String id;
  CreateIncomeEntryEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIncomeEntryEntry otherTyped = other as CreateIncomeEntryEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateIncomeEntryEntry({required this.id});
}

@immutable
class CreateIncomeEntryAudit {
  final String id;
  CreateIncomeEntryAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIncomeEntryAudit otherTyped = other as CreateIncomeEntryAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateIncomeEntryAudit({required this.id});
}

@immutable
class CreateIncomeEntryData {
  final CreateIncomeEntryEntry entry;
  final CreateIncomeEntryAudit audit;
  CreateIncomeEntryData.fromJson(dynamic json)
    : entry = CreateIncomeEntryEntry.fromJson(json['entry']),
      audit = CreateIncomeEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateIncomeEntryData otherTyped = other as CreateIncomeEntryData;
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

  CreateIncomeEntryData({required this.entry, required this.audit});
}

@immutable
class CreateIncomeEntryVariables {
  final String spaceId;
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
  CreateIncomeEntryVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
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

    final CreateIncomeEntryVariables otherTyped =
        other as CreateIncomeEntryVariables;
    return spaceId == otherTyped.spaceId &&
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

  CreateIncomeEntryVariables({
    required this.spaceId,
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
