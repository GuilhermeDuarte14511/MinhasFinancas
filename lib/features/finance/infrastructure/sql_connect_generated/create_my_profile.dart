part of 'client.dart';

class CreateMyProfileVariablesBuilder {
  String displayName;

  final FirebaseDataConnect _dataConnect;
  CreateMyProfileVariablesBuilder(this._dataConnect, {required  this.displayName,});
  Deserializer<CreateMyProfileData> dataDeserializer = (dynamic json)  => CreateMyProfileData.fromJson(jsonDecode(json));
  Serializer<CreateMyProfileVariables> varsSerializer = (CreateMyProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateMyProfileData, CreateMyProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateMyProfileData, CreateMyProfileVariables> ref() {
    CreateMyProfileVariables vars= CreateMyProfileVariables(displayName: displayName,);
    return _dataConnect.mutation("CreateMyProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateMyProfileUserProfileInsert {
  final String id;
  CreateMyProfileUserProfileInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMyProfileUserProfileInsert otherTyped = other as CreateMyProfileUserProfileInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateMyProfileUserProfileInsert({
    required this.id,
  });
}

@immutable
class CreateMyProfileData {
  final CreateMyProfileUserProfileInsert userProfile_insert;
  CreateMyProfileData.fromJson(dynamic json):
  
  userProfile_insert = CreateMyProfileUserProfileInsert.fromJson(json['userProfile_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMyProfileData otherTyped = other as CreateMyProfileData;
    return userProfile_insert == otherTyped.userProfile_insert;
    
  }
  @override
  int get hashCode => userProfile_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userProfile_insert'] = userProfile_insert.toJson();
    return json;
  }

  CreateMyProfileData({
    required this.userProfile_insert,
  });
}

@immutable
class CreateMyProfileVariables {
  final String displayName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateMyProfileVariables.fromJson(Map<String, dynamic> json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMyProfileVariables otherTyped = other as CreateMyProfileVariables;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  CreateMyProfileVariables({
    required this.displayName,
  });
}

