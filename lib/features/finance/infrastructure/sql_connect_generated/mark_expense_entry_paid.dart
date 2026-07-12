part of 'client.dart';

class MarkExpenseEntryPaidVariablesBuilder {
  String spaceId;
  String entryId;
  Timestamp paidAt;

  final FirebaseDataConnect _dataConnect;
  MarkExpenseEntryPaidVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.entryId,
    required this.paidAt,
  });
  Deserializer<MarkExpenseEntryPaidData> dataDeserializer = (dynamic json) =>
      MarkExpenseEntryPaidData.fromJson(jsonDecode(json));
  Serializer<MarkExpenseEntryPaidVariables> varsSerializer =
      (MarkExpenseEntryPaidVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<MarkExpenseEntryPaidData, MarkExpenseEntryPaidVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<MarkExpenseEntryPaidData, MarkExpenseEntryPaidVariables> ref() {
    MarkExpenseEntryPaidVariables vars = MarkExpenseEntryPaidVariables(
      spaceId: spaceId,
      entryId: entryId,
      paidAt: paidAt,
    );
    return _dataConnect.mutation(
      "MarkExpenseEntryPaid",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class MarkExpenseEntryPaidEntry {
  final String id;
  MarkExpenseEntryPaidEntry.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MarkExpenseEntryPaidEntry otherTyped =
        other as MarkExpenseEntryPaidEntry;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  MarkExpenseEntryPaidEntry({required this.id});
}

@immutable
class MarkExpenseEntryPaidData {
  final MarkExpenseEntryPaidEntry? entry;
  MarkExpenseEntryPaidData.fromJson(dynamic json)
    : entry = json['entry'] == null
          ? null
          : MarkExpenseEntryPaidEntry.fromJson(json['entry']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MarkExpenseEntryPaidData otherTyped =
        other as MarkExpenseEntryPaidData;
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

  MarkExpenseEntryPaidData({this.entry});
}

@immutable
class MarkExpenseEntryPaidVariables {
  final String spaceId;
  final String entryId;
  final Timestamp paidAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  MarkExpenseEntryPaidVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      entryId = nativeFromJson<String>(json['entryId']),
      paidAt = Timestamp.fromJson(json['paidAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MarkExpenseEntryPaidVariables otherTyped =
        other as MarkExpenseEntryPaidVariables;
    return spaceId == otherTyped.spaceId &&
        entryId == otherTyped.entryId &&
        paidAt == otherTyped.paidAt;
  }

  @override
  int get hashCode =>
      Object.hashAll([spaceId.hashCode, entryId.hashCode, paidAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['paidAt'] = paidAt.toJson();
    return json;
  }

  MarkExpenseEntryPaidVariables({
    required this.spaceId,
    required this.entryId,
    required this.paidAt,
  });
}
