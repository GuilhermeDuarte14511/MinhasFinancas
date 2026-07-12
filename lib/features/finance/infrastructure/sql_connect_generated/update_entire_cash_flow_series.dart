part of 'client.dart';

class UpdateEntireCashFlowSeriesVariablesBuilder {
  String spaceId;
  String seriesId;
  CashFlowMutationScope scope;
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
  UpdateEntireCashFlowSeriesVariablesBuilder categoryId(String? t) {
    _categoryId.value = t;
    return this;
  }

  UpdateEntireCashFlowSeriesVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  UpdateEntireCashFlowSeriesVariablesBuilder receivedAt(Timestamp? t) {
    _receivedAt.value = t;
    return this;
  }

  UpdateEntireCashFlowSeriesVariablesBuilder paidAt(Timestamp? t) {
    _paidAt.value = t;
    return this;
  }

  UpdateEntireCashFlowSeriesVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.entryStatus,
  });
  Deserializer<UpdateEntireCashFlowSeriesData> dataDeserializer =
      (dynamic json) =>
          UpdateEntireCashFlowSeriesData.fromJson(jsonDecode(json));
  Serializer<UpdateEntireCashFlowSeriesVariables> varsSerializer =
      (UpdateEntireCashFlowSeriesVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      UpdateEntireCashFlowSeriesData,
      UpdateEntireCashFlowSeriesVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    UpdateEntireCashFlowSeriesData,
    UpdateEntireCashFlowSeriesVariables
  >
  ref() {
    UpdateEntireCashFlowSeriesVariables vars =
        UpdateEntireCashFlowSeriesVariables(
          spaceId: spaceId,
          seriesId: seriesId,
          scope: scope,
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
      "UpdateEntireCashFlowSeries",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateEntireCashFlowSeriesSeries {
  final String id;
  UpdateEntireCashFlowSeriesSeries.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateEntireCashFlowSeriesSeries otherTyped =
        other as UpdateEntireCashFlowSeriesSeries;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateEntireCashFlowSeriesSeries({required this.id});
}

@immutable
class UpdateEntireCashFlowSeriesData {
  final UpdateEntireCashFlowSeriesSeries? series;
  final int entries;
  UpdateEntireCashFlowSeriesData.fromJson(dynamic json)
    : series = json['series'] == null
          ? null
          : UpdateEntireCashFlowSeriesSeries.fromJson(json['series']),
      entries = nativeFromJson<int>(json['entries']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateEntireCashFlowSeriesData otherTyped =
        other as UpdateEntireCashFlowSeriesData;
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

  UpdateEntireCashFlowSeriesData({this.series, required this.entries});
}

@immutable
class UpdateEntireCashFlowSeriesVariables {
  final String spaceId;
  final String seriesId;
  final CashFlowMutationScope scope;
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
  UpdateEntireCashFlowSeriesVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      seriesId = nativeFromJson<String>(json['seriesId']),
      scope = CashFlowMutationScope.values.byName(json['scope']),
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

    final UpdateEntireCashFlowSeriesVariables otherTyped =
        other as UpdateEntireCashFlowSeriesVariables;
    return spaceId == otherTyped.spaceId &&
        seriesId == otherTyped.seriesId &&
        scope == otherTyped.scope &&
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

  UpdateEntireCashFlowSeriesVariables({
    required this.spaceId,
    required this.seriesId,
    required this.scope,
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
