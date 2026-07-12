part of 'client.dart';

class UpdateCashFlowSeriesFromVariablesBuilder {
  String spaceId;
  String seriesId;
  CashFlowMutationScope scope;
  Timestamp cutoffAt;
  Optional<String> _categoryId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  CashFlowStatus entryStatus;
  Optional<Timestamp> _receivedAt = Optional.optional(
    (json) => json['receivedAt'] = Timestamp.fromJson(json['receivedAt']),
    defaultSerializer,
  );
  Optional<Timestamp> _paidAt = Optional.optional(
    (json) => json['paidAt'] = Timestamp.fromJson(json['paidAt']),
    defaultSerializer,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateCashFlowSeriesFromVariablesBuilder categoryId(String? t) {
    _categoryId.value = t;
    return this;
  }

  UpdateCashFlowSeriesFromVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  UpdateCashFlowSeriesFromVariablesBuilder receivedAt(Timestamp? t) {
    _receivedAt.value = t;
    return this;
  }

  UpdateCashFlowSeriesFromVariablesBuilder paidAt(Timestamp? t) {
    _paidAt.value = t;
    return this;
  }

  UpdateCashFlowSeriesFromVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.cutoffAt,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.entryStatus,
  });
  Deserializer<UpdateCashFlowSeriesFromData> dataDeserializer =
      (dynamic json) => UpdateCashFlowSeriesFromData.fromJson(jsonDecode(json));
  Serializer<UpdateCashFlowSeriesFromVariables> varsSerializer =
      (UpdateCashFlowSeriesFromVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      UpdateCashFlowSeriesFromData,
      UpdateCashFlowSeriesFromVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateCashFlowSeriesFromData, UpdateCashFlowSeriesFromVariables>
  ref() {
    UpdateCashFlowSeriesFromVariables vars = UpdateCashFlowSeriesFromVariables(
      spaceId: spaceId,
      seriesId: seriesId,
      scope: scope,
      cutoffAt: cutoffAt,
      categoryId: _categoryId,
      description: description,
      kind: kind,
      paymentMethod: paymentMethod,
      amountCents: amountCents,
      notes: _notes,
      entryStatus: entryStatus,
      receivedAt: _receivedAt,
      paidAt: _paidAt,
    );
    return _dataConnect.mutation(
      "UpdateCashFlowSeriesFrom",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateCashFlowSeriesFromSeries {
  final String id;
  UpdateCashFlowSeriesFromSeries.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCashFlowSeriesFromSeries otherTyped =
        other as UpdateCashFlowSeriesFromSeries;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCashFlowSeriesFromSeries({required this.id});
}

@immutable
class UpdateCashFlowSeriesFromData {
  final UpdateCashFlowSeriesFromSeries? series;
  final int entries;
  UpdateCashFlowSeriesFromData.fromJson(dynamic json)
    : series = json['series'] == null
          ? null
          : UpdateCashFlowSeriesFromSeries.fromJson(json['series']),
      entries = nativeFromJson<int>(json['entries']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCashFlowSeriesFromData otherTyped =
        other as UpdateCashFlowSeriesFromData;
    return series == otherTyped.series && entries == otherTyped.entries;
  }

  @override
  int get hashCode => Object.hashAll([series.hashCode, entries.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (series != null) {
      json['series'] = series!.toJson();
    }
    json['entries'] = nativeToJson<int>(entries);
    return json;
  }

  UpdateCashFlowSeriesFromData({this.series, required this.entries});
}

@immutable
class UpdateCashFlowSeriesFromVariables {
  final String spaceId;
  final String seriesId;
  final CashFlowMutationScope scope;
  final Timestamp cutoffAt;
  late final Optional<String> categoryId;
  final String description;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final BigInt amountCents;
  late final Optional<String> notes;
  final CashFlowStatus entryStatus;
  late final Optional<Timestamp> receivedAt;
  late final Optional<Timestamp> paidAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateCashFlowSeriesFromVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      seriesId = nativeFromJson<String>(json['seriesId']),
      scope = CashFlowMutationScope.values.byName(json['scope']),
      cutoffAt = Timestamp.fromJson(json['cutoffAt']),
      description = nativeFromJson<String>(json['description']),
      kind = CashFlowKind.values.byName(json['kind']),
      paymentMethod = CashFlowPaymentMethod.values.byName(
        json['paymentMethod'],
      ),
      amountCents = bigIntFromJson(json['amountCents']),
      entryStatus = CashFlowStatus.values.byName(json['entryStatus']) {
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

    final UpdateCashFlowSeriesFromVariables otherTyped =
        other as UpdateCashFlowSeriesFromVariables;
    return spaceId == otherTyped.spaceId &&
        seriesId == otherTyped.seriesId &&
        scope == otherTyped.scope &&
        cutoffAt == otherTyped.cutoffAt &&
        categoryId == otherTyped.categoryId &&
        description == otherTyped.description &&
        kind == otherTyped.kind &&
        paymentMethod == otherTyped.paymentMethod &&
        amountCents == otherTyped.amountCents &&
        notes == otherTyped.notes &&
        entryStatus == otherTyped.entryStatus &&
        receivedAt == otherTyped.receivedAt &&
        paidAt == otherTyped.paidAt;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    seriesId.hashCode,
    scope.hashCode,
    cutoffAt.hashCode,
    categoryId.hashCode,
    description.hashCode,
    kind.hashCode,
    paymentMethod.hashCode,
    amountCents.hashCode,
    notes.hashCode,
    entryStatus.hashCode,
    receivedAt.hashCode,
    paidAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['seriesId'] = nativeToJson<String>(seriesId);
    json['scope'] = scope.name;
    json['cutoffAt'] = cutoffAt.toJson();
    if (categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    json['kind'] = kind.name;
    json['paymentMethod'] = paymentMethod.name;
    json['amountCents'] = bigIntToJson(amountCents);
    if (notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['entryStatus'] = entryStatus.name;
    if (receivedAt.state == OptionalState.set) {
      json['receivedAt'] = receivedAt.toJson();
    }
    if (paidAt.state == OptionalState.set) {
      json['paidAt'] = paidAt.toJson();
    }
    return json;
  }

  UpdateCashFlowSeriesFromVariables({
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.cutoffAt,
    required this.categoryId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.notes,
    required this.entryStatus,
    required this.receivedAt,
    required this.paidAt,
  });
}
