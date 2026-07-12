part of 'client.dart';

class UpdateMyProfileVariablesBuilder {
  String displayName;
  Optional<String> _photoUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateMyProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  UpdateMyProfileVariablesBuilder(this._dataConnect, {required  this.displayName,});
  Deserializer<UpdateMyProfileData> dataDeserializer = (dynamic json)  => UpdateMyProfileData.fromJson(jsonDecode(json));
  Serializer<UpdateMyProfileVariables> varsSerializer = (UpdateMyProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMyProfileData, UpdateMyProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMyProfileData, UpdateMyProfileVariables> ref() {
    UpdateMyProfileVariables vars= UpdateMyProfileVariables(displayName: displayName,photoUrl: _photoUrl,);
    return _dataConnect.mutation("UpdateMyProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMyProfileUserProfileUpdate {
  final String id;
  UpdateMyProfileUserProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMyProfileUserProfileUpdate otherTyped = other as UpdateMyProfileUserProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateMyProfileUserProfileUpdate({
    required this.id,
  });
}

@immutable
class UpdateMyProfileData {
  final UpdateMyProfileUserProfileUpdate? userProfile_update;
  UpdateMyProfileData.fromJson(dynamic json):
  
  userProfile_update = json['userProfile_update'] == null ? null : UpdateMyProfileUserProfileUpdate.fromJson(json['userProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMyProfileData otherTyped = other as UpdateMyProfileData;
    return userProfile_update == otherTyped.userProfile_update;
    
  }
  @override
  int get hashCode => userProfile_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (userProfile_update != null) {
      json['userProfile_update'] = userProfile_update!.toJson();
    }
    return json;
  }

  UpdateMyProfileData({
    this.userProfile_update,
  });
}

@immutable
class UpdateMyProfileVariables {
  final String displayName;
  late final Optional<String>photoUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMyProfileVariables.fromJson(Map<String, dynamic> json):
  
  displayName = nativeFromJson<String>(json['displayName']) {
  
  
  
    photoUrl = Optional.optional(nativeFromJson, nativeToJson);
    photoUrl.value = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMyProfileVariables otherTyped = other as UpdateMyProfileVariables;
    return displayName == otherTyped.displayName && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([displayName.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    if(photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  UpdateMyProfileVariables({
    required this.displayName,
    required this.photoUrl,
  });
}

