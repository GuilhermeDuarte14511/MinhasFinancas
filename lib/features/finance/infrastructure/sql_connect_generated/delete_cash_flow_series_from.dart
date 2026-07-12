part of 'client.dart';

class DeleteCashFlowSeriesFromVariablesBuilder {
  String spaceId;
  String seriesId;
  CashFlowMutationScope scope;
  Timestamp cutoffAt;
  Optional<DateTime> _lastKeptDate = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  String reason;

  final FirebaseDataConnect _dataConnect;
  DeleteCashFlowSeriesFromVariablesBuilder lastKeptDate(DateTime? t) {
    _lastKeptDate.value = t;
    return this;
  }

  DeleteCashFlowSeriesFromVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.cutoffAt,
    required this.reason,
  });
  Deserializer<DeleteCashFlowSeriesFromData> dataDeserializer =
      (dynamic json) => DeleteCashFlowSeriesFromData.fromJson(jsonDecode(json));
  Serializer<DeleteCashFlowSeriesFromVariables> varsSerializer =
      (DeleteCashFlowSeriesFromVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      DeleteCashFlowSeriesFromData,
      DeleteCashFlowSeriesFromVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteCashFlowSeriesFromData, DeleteCashFlowSeriesFromVariables>
  ref() {
    DeleteCashFlowSeriesFromVariables vars = DeleteCashFlowSeriesFromVariables(
      spaceId: spaceId,
      seriesId: seriesId,
      scope: scope,
      cutoffAt: cutoffAt,
      lastKeptDate: _lastKeptDate,
      reason: reason,
    );
    return _dataConnect.mutation(
      "DeleteCashFlowSeriesFrom",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteCashFlowSeriesFromSeries {
  final String id;
  DeleteCashFlowSeriesFromSeries.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowSeriesFromSeries otherTyped =
        other as DeleteCashFlowSeriesFromSeries;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCashFlowSeriesFromSeries({required this.id});
}

@immutable
class DeleteCashFlowSeriesFromAudit {
  final String id;
  DeleteCashFlowSeriesFromAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowSeriesFromAudit otherTyped =
        other as DeleteCashFlowSeriesFromAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCashFlowSeriesFromAudit({required this.id});
}

@immutable
class DeleteCashFlowSeriesFromData {
  final int entries;
  final DeleteCashFlowSeriesFromSeries? series;
  final DeleteCashFlowSeriesFromAudit audit;
  DeleteCashFlowSeriesFromData.fromJson(dynamic json)
    : entries = nativeFromJson<int>(json['entries']),
      series = json['series'] == null
          ? null
          : DeleteCashFlowSeriesFromSeries.fromJson(json['series']),
      audit = DeleteCashFlowSeriesFromAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowSeriesFromData otherTyped =
        other as DeleteCashFlowSeriesFromData;
    return entries == otherTyped.entries &&
        series == otherTyped.series &&
        audit == otherTyped.audit;
  }

  @override
  int get hashCode =>
      Object.hashAll([entries.hashCode, series.hashCode, audit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entries'] = nativeToJson<int>(entries);
    if (series != null) {
      json['series'] = series!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  DeleteCashFlowSeriesFromData({
    required this.entries,
    this.series,
    required this.audit,
  });
}

@immutable
class DeleteCashFlowSeriesFromVariables {
  final String spaceId;
  final String seriesId;
  final CashFlowMutationScope scope;
  final Timestamp cutoffAt;
  late final Optional<DateTime> lastKeptDate;
  final String reason;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteCashFlowSeriesFromVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      seriesId = nativeFromJson<String>(json['seriesId']),
      scope = CashFlowMutationScope.values.byName(json['scope']),
      cutoffAt = Timestamp.fromJson(json['cutoffAt']),
      reason = nativeFromJson<String>(json['reason']) {
    lastKeptDate = Optional.optional(nativeFromJson, nativeToJson);
    lastKeptDate.value = json['lastKeptDate'] == null
        ? null
        : nativeFromJson<DateTime>(json['lastKeptDate']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowSeriesFromVariables otherTyped =
        other as DeleteCashFlowSeriesFromVariables;
    return spaceId == otherTyped.spaceId &&
        seriesId == otherTyped.seriesId &&
        scope == otherTyped.scope &&
        cutoffAt == otherTyped.cutoffAt &&
        lastKeptDate == otherTyped.lastKeptDate &&
        reason == otherTyped.reason;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    seriesId.hashCode,
    scope.hashCode,
    cutoffAt.hashCode,
    lastKeptDate.hashCode,
    reason.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['seriesId'] = nativeToJson<String>(seriesId);
    json['scope'] = scope.name;
    json['cutoffAt'] = cutoffAt.toJson();
    if (lastKeptDate.state == OptionalState.set) {
      json['lastKeptDate'] = lastKeptDate.toJson();
    }
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  DeleteCashFlowSeriesFromVariables({
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.cutoffAt,
    required this.lastKeptDate,
    required this.reason,
  });
}
