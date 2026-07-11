part of 'client.dart';

class RevokeSpaceInvitationVariablesBuilder {
  String spaceId;
  String invitationId;

  final FirebaseDataConnect _dataConnect;
  RevokeSpaceInvitationVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.invitationId,
  });
  Deserializer<RevokeSpaceInvitationData> dataDeserializer = (dynamic json) =>
      RevokeSpaceInvitationData.fromJson(jsonDecode(json));
  Serializer<RevokeSpaceInvitationVariables> varsSerializer =
      (RevokeSpaceInvitationVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<RevokeSpaceInvitationData, RevokeSpaceInvitationVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<RevokeSpaceInvitationData, RevokeSpaceInvitationVariables> ref() {
    RevokeSpaceInvitationVariables vars = RevokeSpaceInvitationVariables(
      spaceId: spaceId,
      invitationId: invitationId,
    );
    return _dataConnect.mutation(
      "RevokeSpaceInvitation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class RevokeSpaceInvitationInvitation {
  final String id;
  RevokeSpaceInvitationInvitation.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RevokeSpaceInvitationInvitation otherTyped =
        other as RevokeSpaceInvitationInvitation;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RevokeSpaceInvitationInvitation({required this.id});
}

@immutable
class RevokeSpaceInvitationData {
  final RevokeSpaceInvitationInvitation? invitation;
  RevokeSpaceInvitationData.fromJson(dynamic json)
    : invitation = json['invitation'] == null
          ? null
          : RevokeSpaceInvitationInvitation.fromJson(json['invitation']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RevokeSpaceInvitationData otherTyped =
        other as RevokeSpaceInvitationData;
    return invitation == otherTyped.invitation;
  }

  @override
  int get hashCode => invitation.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (invitation != null) {
      json['invitation'] = invitation!.toJson();
    }
    return json;
  }

  RevokeSpaceInvitationData({this.invitation});
}

@immutable
class RevokeSpaceInvitationVariables {
  final String spaceId;
  final String invitationId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  RevokeSpaceInvitationVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      invitationId = nativeFromJson<String>(json['invitationId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RevokeSpaceInvitationVariables otherTyped =
        other as RevokeSpaceInvitationVariables;
    return spaceId == otherTyped.spaceId &&
        invitationId == otherTyped.invitationId;
  }

  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, invitationId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['invitationId'] = nativeToJson<String>(invitationId);
    return json;
  }

  RevokeSpaceInvitationVariables({
    required this.spaceId,
    required this.invitationId,
  });
}
