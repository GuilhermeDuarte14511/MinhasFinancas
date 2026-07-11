part of 'client.dart';

class ListMySpacesVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListMySpacesVariablesBuilder(this._dataConnect);
  Deserializer<ListMySpacesData> dataDeserializer = (dynamic json) =>
      ListMySpacesData.fromJson(jsonDecode(json));

  Future<QueryResult<ListMySpacesData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMySpacesData, void> ref() {
    return _dataConnect.query(
      "ListMySpaces",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class ListMySpacesSpaceMembers {
  final String id;
  final EnumValue<MembershipRole> role;
  final Timestamp? joinedAt;
  final ListMySpacesSpaceMembersFinancialSpace financialSpace;
  ListMySpacesSpaceMembers.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      role = membershipRoleDeserializer(json['role']),
      joinedAt = json['joinedAt'] == null
          ? null
          : Timestamp.fromJson(json['joinedAt']),
      financialSpace = ListMySpacesSpaceMembersFinancialSpace.fromJson(
        json['financialSpace'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMySpacesSpaceMembers otherTyped =
        other as ListMySpacesSpaceMembers;
    return id == otherTyped.id &&
        role == otherTyped.role &&
        joinedAt == otherTyped.joinedAt &&
        financialSpace == otherTyped.financialSpace;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    role.hashCode,
    joinedAt.hashCode,
    financialSpace.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['role'] = membershipRoleSerializer(role);
    if (joinedAt != null) {
      json['joinedAt'] = joinedAt!.toJson();
    }
    json['financialSpace'] = financialSpace.toJson();
    return json;
  }

  ListMySpacesSpaceMembers({
    required this.id,
    required this.role,
    this.joinedAt,
    required this.financialSpace,
  });
}

@immutable
class ListMySpacesSpaceMembersFinancialSpace {
  final String id;
  final String name;
  final String colorHex;
  final String currencyCode;
  final String timezone;
  final Timestamp updatedAt;
  ListMySpacesSpaceMembersFinancialSpace.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      name = nativeFromJson<String>(json['name']),
      colorHex = nativeFromJson<String>(json['colorHex']),
      currencyCode = nativeFromJson<String>(json['currencyCode']),
      timezone = nativeFromJson<String>(json['timezone']),
      updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMySpacesSpaceMembersFinancialSpace otherTyped =
        other as ListMySpacesSpaceMembersFinancialSpace;
    return id == otherTyped.id &&
        name == otherTyped.name &&
        colorHex == otherTyped.colorHex &&
        currencyCode == otherTyped.currencyCode &&
        timezone == otherTyped.timezone &&
        updatedAt == otherTyped.updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    name.hashCode,
    colorHex.hashCode,
    currencyCode.hashCode,
    timezone.hashCode,
    updatedAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['currencyCode'] = nativeToJson<String>(currencyCode);
    json['timezone'] = nativeToJson<String>(timezone);
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  ListMySpacesSpaceMembersFinancialSpace({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.currencyCode,
    required this.timezone,
    required this.updatedAt,
  });
}

@immutable
class ListMySpacesData {
  final List<ListMySpacesSpaceMembers> spaceMembers;
  ListMySpacesData.fromJson(dynamic json)
    : spaceMembers = (json['spaceMembers'] as List<dynamic>)
          .map((e) => ListMySpacesSpaceMembers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMySpacesData otherTyped = other as ListMySpacesData;
    return spaceMembers == otherTyped.spaceMembers;
  }

  @override
  int get hashCode => spaceMembers.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceMembers'] = spaceMembers.map((e) => e.toJson()).toList();
    return json;
  }

  ListMySpacesData({required this.spaceMembers});
}
