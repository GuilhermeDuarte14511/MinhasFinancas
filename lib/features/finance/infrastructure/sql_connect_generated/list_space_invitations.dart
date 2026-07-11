part of 'client.dart';

class ListSpaceInvitationsVariablesBuilder {
  String spaceId;

  final FirebaseDataConnect _dataConnect;
  ListSpaceInvitationsVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
  });
  Deserializer<ListSpaceInvitationsData> dataDeserializer = (dynamic json) =>
      ListSpaceInvitationsData.fromJson(jsonDecode(json));
  Serializer<ListSpaceInvitationsVariables> varsSerializer =
      (ListSpaceInvitationsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListSpaceInvitationsData, ListSpaceInvitationsVariables>>
  execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListSpaceInvitationsData, ListSpaceInvitationsVariables> ref() {
    ListSpaceInvitationsVariables vars = ListSpaceInvitationsVariables(
      spaceId: spaceId,
    );
    return _dataConnect.query(
      "ListSpaceInvitations",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListSpaceInvitationsSpaceInvitations {
  final String id;
  final String email;
  final EnumValue<MembershipRole> role;
  final Timestamp expiresAt;
  ListSpaceInvitationsSpaceInvitations.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      email = nativeFromJson<String>(json['email']),
      role = membershipRoleDeserializer(json['role']),
      expiresAt = Timestamp.fromJson(json['expiresAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListSpaceInvitationsSpaceInvitations otherTyped =
        other as ListSpaceInvitationsSpaceInvitations;
    return id == otherTyped.id &&
        email == otherTyped.email &&
        role == otherTyped.role &&
        expiresAt == otherTyped.expiresAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    email.hashCode,
    role.hashCode,
    expiresAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    json['role'] = membershipRoleSerializer(role);
    json['expiresAt'] = expiresAt.toJson();
    return json;
  }

  ListSpaceInvitationsSpaceInvitations({
    required this.id,
    required this.email,
    required this.role,
    required this.expiresAt,
  });
}

@immutable
class ListSpaceInvitationsData {
  final List<ListSpaceInvitationsSpaceInvitations> spaceInvitations;
  ListSpaceInvitationsData.fromJson(dynamic json)
    : spaceInvitations = (json['spaceInvitations'] as List<dynamic>)
          .map((e) => ListSpaceInvitationsSpaceInvitations.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListSpaceInvitationsData otherTyped =
        other as ListSpaceInvitationsData;
    return spaceInvitations == otherTyped.spaceInvitations;
  }

  @override
  int get hashCode => spaceInvitations.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceInvitations'] = spaceInvitations.map((e) => e.toJson()).toList();
    return json;
  }

  ListSpaceInvitationsData({required this.spaceInvitations});
}

@immutable
class ListSpaceInvitationsVariables {
  final String spaceId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListSpaceInvitationsVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListSpaceInvitationsVariables otherTyped =
        other as ListSpaceInvitationsVariables;
    return spaceId == otherTyped.spaceId;
  }

  @override
  int get hashCode => spaceId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    return json;
  }

  ListSpaceInvitationsVariables({required this.spaceId});
}
