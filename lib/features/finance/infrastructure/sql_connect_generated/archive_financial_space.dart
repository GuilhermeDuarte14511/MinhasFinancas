part of 'client.dart';

class ArchiveFinancialSpaceVariablesBuilder {
  String spaceId;

  final FirebaseDataConnect _dataConnect;
  ArchiveFinancialSpaceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
  });
  Deserializer<ArchiveFinancialSpaceData> dataDeserializer = (dynamic json) =>
      ArchiveFinancialSpaceData.fromJson(jsonDecode(json));
  Serializer<ArchiveFinancialSpaceVariables> varsSerializer =
      (ArchiveFinancialSpaceVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<ArchiveFinancialSpaceData, ArchiveFinancialSpaceVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<ArchiveFinancialSpaceData, ArchiveFinancialSpaceVariables> ref() {
    ArchiveFinancialSpaceVariables vars = ArchiveFinancialSpaceVariables(
      spaceId: spaceId,
    );
    return _dataConnect.mutation(
      "ArchiveFinancialSpace",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ArchiveFinancialSpaceSpace {
  final String id;
  ArchiveFinancialSpaceSpace.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialSpaceSpace otherTyped =
        other as ArchiveFinancialSpaceSpace;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ArchiveFinancialSpaceSpace({required this.id});
}

@immutable
class ArchiveFinancialSpaceData {
  final ArchiveFinancialSpaceSpace? space;
  ArchiveFinancialSpaceData.fromJson(dynamic json)
    : space = json['space'] == null
          ? null
          : ArchiveFinancialSpaceSpace.fromJson(json['space']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialSpaceData otherTyped =
        other as ArchiveFinancialSpaceData;
    return space == otherTyped.space;
  }

  @override
  int get hashCode => space.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (space != null) {
      json['space'] = space!.toJson();
    }
    return json;
  }

  ArchiveFinancialSpaceData({this.space});
}

@immutable
class ArchiveFinancialSpaceVariables {
  final String spaceId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ArchiveFinancialSpaceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialSpaceVariables otherTyped =
        other as ArchiveFinancialSpaceVariables;
    return spaceId == otherTyped.spaceId;
  }

  @override
  int get hashCode => spaceId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    return json;
  }

  ArchiveFinancialSpaceVariables({required this.spaceId});
}
