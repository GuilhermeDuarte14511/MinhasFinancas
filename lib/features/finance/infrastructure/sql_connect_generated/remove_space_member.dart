part of 'client.dart';

class RemoveSpaceMemberVariablesBuilder {
  String spaceId;
  String memberId;

  final FirebaseDataConnect _dataConnect;
  RemoveSpaceMemberVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.memberId,});
  Deserializer<RemoveSpaceMemberData> dataDeserializer = (dynamic json)  => RemoveSpaceMemberData.fromJson(jsonDecode(json));
  Serializer<RemoveSpaceMemberVariables> varsSerializer = (RemoveSpaceMemberVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RemoveSpaceMemberData, RemoveSpaceMemberVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RemoveSpaceMemberData, RemoveSpaceMemberVariables> ref() {
    RemoveSpaceMemberVariables vars= RemoveSpaceMemberVariables(spaceId: spaceId,memberId: memberId,);
    return _dataConnect.mutation("RemoveSpaceMember", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RemoveSpaceMemberMember {
  final String id;
  RemoveSpaceMemberMember.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSpaceMemberMember otherTyped = other as RemoveSpaceMemberMember;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RemoveSpaceMemberMember({
    required this.id,
  });
}

@immutable
class RemoveSpaceMemberData {
  final RemoveSpaceMemberMember? member;
  RemoveSpaceMemberData.fromJson(dynamic json):
  
  member = json['member'] == null ? null : RemoveSpaceMemberMember.fromJson(json['member']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSpaceMemberData otherTyped = other as RemoveSpaceMemberData;
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

  RemoveSpaceMemberData({
    this.member,
  });
}

@immutable
class RemoveSpaceMemberVariables {
  final String spaceId;
  final String memberId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RemoveSpaceMemberVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  memberId = nativeFromJson<String>(json['memberId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSpaceMemberVariables otherTyped = other as RemoveSpaceMemberVariables;
    return spaceId == otherTyped.spaceId && 
    memberId == otherTyped.memberId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, memberId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['memberId'] = nativeToJson<String>(memberId);
    return json;
  }

  RemoveSpaceMemberVariables({
    required this.spaceId,
    required this.memberId,
  });
}

