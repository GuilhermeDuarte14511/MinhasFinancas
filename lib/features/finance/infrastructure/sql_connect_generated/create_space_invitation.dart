part of 'client.dart';

class CreateSpaceInvitationVariablesBuilder {
  String spaceId;
  String email;
  String normalizedEmail;
  MembershipRole role;
  String tokenHash;
  Timestamp expiresAt;

  final FirebaseDataConnect _dataConnect;
  CreateSpaceInvitationVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.email,required  this.normalizedEmail,required  this.role,required  this.tokenHash,required  this.expiresAt,});
  Deserializer<CreateSpaceInvitationData> dataDeserializer = (dynamic json)  => CreateSpaceInvitationData.fromJson(jsonDecode(json));
  Serializer<CreateSpaceInvitationVariables> varsSerializer = (CreateSpaceInvitationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateSpaceInvitationData, CreateSpaceInvitationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateSpaceInvitationData, CreateSpaceInvitationVariables> ref() {
    CreateSpaceInvitationVariables vars= CreateSpaceInvitationVariables(spaceId: spaceId,email: email,normalizedEmail: normalizedEmail,role: role,tokenHash: tokenHash,expiresAt: expiresAt,);
    return _dataConnect.mutation("CreateSpaceInvitation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateSpaceInvitationInvitation {
  final String id;
  CreateSpaceInvitationInvitation.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSpaceInvitationInvitation otherTyped = other as CreateSpaceInvitationInvitation;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateSpaceInvitationInvitation({
    required this.id,
  });
}

@immutable
class CreateSpaceInvitationAudit {
  final String id;
  CreateSpaceInvitationAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSpaceInvitationAudit otherTyped = other as CreateSpaceInvitationAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateSpaceInvitationAudit({
    required this.id,
  });
}

@immutable
class CreateSpaceInvitationData {
  final CreateSpaceInvitationInvitation invitation;
  final CreateSpaceInvitationAudit audit;
  CreateSpaceInvitationData.fromJson(dynamic json):
  
  invitation = CreateSpaceInvitationInvitation.fromJson(json['invitation']),
  audit = CreateSpaceInvitationAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSpaceInvitationData otherTyped = other as CreateSpaceInvitationData;
    return invitation == otherTyped.invitation && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([invitation.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invitation'] = invitation.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateSpaceInvitationData({
    required this.invitation,
    required this.audit,
  });
}

@immutable
class CreateSpaceInvitationVariables {
  final String spaceId;
  final String email;
  final String normalizedEmail;
  final MembershipRole role;
  final String tokenHash;
  final Timestamp expiresAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateSpaceInvitationVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  email = nativeFromJson<String>(json['email']),
  normalizedEmail = nativeFromJson<String>(json['normalizedEmail']),
  role = MembershipRole.values.byName(json['role']),
  tokenHash = nativeFromJson<String>(json['tokenHash']),
  expiresAt = Timestamp.fromJson(json['expiresAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSpaceInvitationVariables otherTyped = other as CreateSpaceInvitationVariables;
    return spaceId == otherTyped.spaceId && 
    email == otherTyped.email && 
    normalizedEmail == otherTyped.normalizedEmail && 
    role == otherTyped.role && 
    tokenHash == otherTyped.tokenHash && 
    expiresAt == otherTyped.expiresAt;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, email.hashCode, normalizedEmail.hashCode, role.hashCode, tokenHash.hashCode, expiresAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['email'] = nativeToJson<String>(email);
    json['normalizedEmail'] = nativeToJson<String>(normalizedEmail);
    json['role'] = 
    role.name
    ;
    json['tokenHash'] = nativeToJson<String>(tokenHash);
    json['expiresAt'] = expiresAt.toJson();
    return json;
  }

  CreateSpaceInvitationVariables({
    required this.spaceId,
    required this.email,
    required this.normalizedEmail,
    required this.role,
    required this.tokenHash,
    required this.expiresAt,
  });
}

