part of 'client.dart';

class UpdateFinancialSpaceVariablesBuilder {
  String spaceId;
  String name;
  String colorHex;

  final FirebaseDataConnect _dataConnect;
  UpdateFinancialSpaceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.name,
    required this.colorHex,
  });
  Deserializer<UpdateFinancialSpaceData> dataDeserializer = (dynamic json) =>
      UpdateFinancialSpaceData.fromJson(jsonDecode(json));
  Serializer<UpdateFinancialSpaceVariables> varsSerializer =
      (UpdateFinancialSpaceVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<UpdateFinancialSpaceData, UpdateFinancialSpaceVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateFinancialSpaceData, UpdateFinancialSpaceVariables> ref() {
    UpdateFinancialSpaceVariables vars = UpdateFinancialSpaceVariables(
      spaceId: spaceId,
      name: name,
      colorHex: colorHex,
    );
    return _dataConnect.mutation(
      "UpdateFinancialSpace",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateFinancialSpaceSpace {
  final String id;
  UpdateFinancialSpaceSpace.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialSpaceSpace otherTyped =
        other as UpdateFinancialSpaceSpace;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateFinancialSpaceSpace({required this.id});
}

@immutable
class UpdateFinancialSpaceData {
  final UpdateFinancialSpaceSpace? space;
  UpdateFinancialSpaceData.fromJson(dynamic json)
    : space = json['space'] == null
          ? null
          : UpdateFinancialSpaceSpace.fromJson(json['space']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialSpaceData otherTyped =
        other as UpdateFinancialSpaceData;
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

  UpdateFinancialSpaceData({this.space});
}

@immutable
class UpdateFinancialSpaceVariables {
  final String spaceId;
  final String name;
  final String colorHex;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateFinancialSpaceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      name = nativeFromJson<String>(json['name']),
      colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialSpaceVariables otherTyped =
        other as UpdateFinancialSpaceVariables;
    return spaceId == otherTyped.spaceId &&
        name == otherTyped.name &&
        colorHex == otherTyped.colorHex;
  }

  @override
  int get hashCode =>
      Object.hashAll([spaceId.hashCode, name.hashCode, colorHex.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['name'] = nativeToJson<String>(name);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  UpdateFinancialSpaceVariables({
    required this.spaceId,
    required this.name,
    required this.colorHex,
  });
}
