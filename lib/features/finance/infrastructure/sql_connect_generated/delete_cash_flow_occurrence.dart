part of 'client.dart';

class DeleteCashFlowOccurrenceVariablesBuilder {
  String spaceId;
  String entryId;
  CashFlowMutationScope scope;
  String reason;

  final FirebaseDataConnect _dataConnect;
  DeleteCashFlowOccurrenceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.entryId,
    required this.scope,
    required this.reason,
  });
  Deserializer<DeleteCashFlowOccurrenceData> dataDeserializer =
      (dynamic json) => DeleteCashFlowOccurrenceData.fromJson(jsonDecode(json));
  Serializer<DeleteCashFlowOccurrenceVariables> varsSerializer =
      (DeleteCashFlowOccurrenceVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      DeleteCashFlowOccurrenceData,
      DeleteCashFlowOccurrenceVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteCashFlowOccurrenceData, DeleteCashFlowOccurrenceVariables>
  ref() {
    DeleteCashFlowOccurrenceVariables vars = DeleteCashFlowOccurrenceVariables(
      spaceId: spaceId,
      entryId: entryId,
      scope: scope,
      reason: reason,
    );
    return _dataConnect.mutation(
      "DeleteCashFlowOccurrence",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteCashFlowOccurrenceEntry {
  final String id;
  DeleteCashFlowOccurrenceEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowOccurrenceEntry otherTyped =
        other as DeleteCashFlowOccurrenceEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCashFlowOccurrenceEntry({required this.id});
}

@immutable
class DeleteCashFlowOccurrenceAudit {
  final String id;
  DeleteCashFlowOccurrenceAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowOccurrenceAudit otherTyped =
        other as DeleteCashFlowOccurrenceAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCashFlowOccurrenceAudit({required this.id});
}

@immutable
class DeleteCashFlowOccurrenceData {
  final DeleteCashFlowOccurrenceEntry? entry;
  final DeleteCashFlowOccurrenceAudit audit;
  DeleteCashFlowOccurrenceData.fromJson(dynamic json)
    : entry = json['entry'] == null
          ? null
          : DeleteCashFlowOccurrenceEntry.fromJson(json['entry']),
      audit = DeleteCashFlowOccurrenceAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowOccurrenceData otherTyped =
        other as DeleteCashFlowOccurrenceData;
    return entry == otherTyped.entry && audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([entry.hashCode, audit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (entry != null) {
      json['entry'] = entry!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  DeleteCashFlowOccurrenceData({this.entry, required this.audit});
}

@immutable
class DeleteCashFlowOccurrenceVariables {
  final String spaceId;
  final String entryId;
  final CashFlowMutationScope scope;
  final String reason;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteCashFlowOccurrenceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      entryId = nativeFromJson<String>(json['entryId']),
      scope = CashFlowMutationScope.values.byName(json['scope']),
      reason = nativeFromJson<String>(json['reason']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCashFlowOccurrenceVariables otherTyped =
        other as DeleteCashFlowOccurrenceVariables;
    return spaceId == otherTyped.spaceId &&
        entryId == otherTyped.entryId &&
        scope == otherTyped.scope &&
        reason == otherTyped.reason;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    entryId.hashCode,
    scope.hashCode,
    reason.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['scope'] = scope.name;
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  DeleteCashFlowOccurrenceVariables({
    required this.spaceId,
    required this.entryId,
    required this.scope,
    required this.reason,
  });
}
