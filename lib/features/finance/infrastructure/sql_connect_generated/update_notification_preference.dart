part of 'client.dart';

class UpdateNotificationPreferenceVariablesBuilder {
  String spaceId;
  bool enabled;
  bool pushEnabled;
  bool inAppEnabled;
  String preferredTime;

  final FirebaseDataConnect _dataConnect;
  UpdateNotificationPreferenceVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.enabled,required  this.pushEnabled,required  this.inAppEnabled,required  this.preferredTime,});
  Deserializer<UpdateNotificationPreferenceData> dataDeserializer = (dynamic json)  => UpdateNotificationPreferenceData.fromJson(jsonDecode(json));
  Serializer<UpdateNotificationPreferenceVariables> varsSerializer = (UpdateNotificationPreferenceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateNotificationPreferenceData, UpdateNotificationPreferenceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateNotificationPreferenceData, UpdateNotificationPreferenceVariables> ref() {
    UpdateNotificationPreferenceVariables vars= UpdateNotificationPreferenceVariables(spaceId: spaceId,enabled: enabled,pushEnabled: pushEnabled,inAppEnabled: inAppEnabled,preferredTime: preferredTime,);
    return _dataConnect.mutation("UpdateNotificationPreference", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateNotificationPreferencePreference {
  final String id;
  UpdateNotificationPreferencePreference.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationPreferencePreference otherTyped = other as UpdateNotificationPreferencePreference;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateNotificationPreferencePreference({
    required this.id,
  });
}

@immutable
class UpdateNotificationPreferenceData {
  final UpdateNotificationPreferencePreference? preference;
  UpdateNotificationPreferenceData.fromJson(dynamic json):
  
  preference = json['preference'] == null ? null : UpdateNotificationPreferencePreference.fromJson(json['preference']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationPreferenceData otherTyped = other as UpdateNotificationPreferenceData;
    return preference == otherTyped.preference;
    
  }
  @override
  int get hashCode => preference.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (preference != null) {
      json['preference'] = preference!.toJson();
    }
    return json;
  }

  UpdateNotificationPreferenceData({
    this.preference,
  });
}

@immutable
class UpdateNotificationPreferenceVariables {
  final String spaceId;
  final bool enabled;
  final bool pushEnabled;
  final bool inAppEnabled;
  final String preferredTime;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateNotificationPreferenceVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  enabled = nativeFromJson<bool>(json['enabled']),
  pushEnabled = nativeFromJson<bool>(json['pushEnabled']),
  inAppEnabled = nativeFromJson<bool>(json['inAppEnabled']),
  preferredTime = nativeFromJson<String>(json['preferredTime']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationPreferenceVariables otherTyped = other as UpdateNotificationPreferenceVariables;
    return spaceId == otherTyped.spaceId && 
    enabled == otherTyped.enabled && 
    pushEnabled == otherTyped.pushEnabled && 
    inAppEnabled == otherTyped.inAppEnabled && 
    preferredTime == otherTyped.preferredTime;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, enabled.hashCode, pushEnabled.hashCode, inAppEnabled.hashCode, preferredTime.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['enabled'] = nativeToJson<bool>(enabled);
    json['pushEnabled'] = nativeToJson<bool>(pushEnabled);
    json['inAppEnabled'] = nativeToJson<bool>(inAppEnabled);
    json['preferredTime'] = nativeToJson<String>(preferredTime);
    return json;
  }

  UpdateNotificationPreferenceVariables({
    required this.spaceId,
    required this.enabled,
    required this.pushEnabled,
    required this.inAppEnabled,
    required this.preferredTime,
  });
}

