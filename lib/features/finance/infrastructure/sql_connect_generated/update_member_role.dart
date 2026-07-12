part of 'client.dart';

class UpdateMemberRoleVariablesBuilder {
  String spaceId;
  String memberId;
  MembershipRole role;

  final FirebaseDataConnect _dataConnect;
  UpdateMemberRoleVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.memberId,required  this.role,});
  Deserializer<UpdateMemberRoleData> dataDeserializer = (dynamic json)  => UpdateMemberRoleData.fromJson(jsonDecode(json));
  Serializer<UpdateMemberRoleVariables> varsSerializer = (UpdateMemberRoleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMemberRoleData, UpdateMemberRoleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMemberRoleData, UpdateMemberRoleVariables> ref() {
    UpdateMemberRoleVariables vars= UpdateMemberRoleVariables(spaceId: spaceId,memberId: memberId,role: role,);
    return _dataConnect.mutation("UpdateMemberRole", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMemberRoleMember {
  final String id;
  UpdateMemberRoleMember.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMemberRoleMember otherTyped = other as UpdateMemberRoleMember;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateMemberRoleMember({
    required this.id,
  });
}

@immutable
class UpdateMemberRoleData {
  final UpdateMemberRoleMember? member;
  UpdateMemberRoleData.fromJson(dynamic json):
  
  member = json['member'] == null ? null : UpdateMemberRoleMember.fromJson(json['member']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMemberRoleData otherTyped = other as UpdateMemberRoleData;
    return member == otherTyped.member;
    
  }
  @override
  int get hashCode => member.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (member != null) {
      json['member'] = member!.toJson();
    }
    return json;
  }

  UpdateMemberRoleData({
    this.member,
  });
}

@immutable
class UpdateMemberRoleVariables {
  final String spaceId;
  final String memberId;
  final MembershipRole role;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMemberRoleVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  memberId = nativeFromJson<String>(json['memberId']),
  role = MembershipRole.values.byName(json['role']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMemberRoleVariables otherTyped = other as UpdateMemberRoleVariables;
    return spaceId == otherTyped.spaceId && 
    memberId == otherTyped.memberId && 
    role == otherTyped.role;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, memberId.hashCode, role.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['memberId'] = nativeToJson<String>(memberId);
    json['role'] = 
    role.name
    ;
    return json;
  }

  UpdateMemberRoleVariables({
    required this.spaceId,
    required this.memberId,
    required this.role,
  });
}

