part of 'client.dart';

class CancelCashFlowEntryVariablesBuilder {
  String spaceId;
  String entryId;
  String reason;

  final FirebaseDataConnect _dataConnect;
  CancelCashFlowEntryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.entryId,required  this.reason,});
  Deserializer<CancelCashFlowEntryData> dataDeserializer = (dynamic json)  => CancelCashFlowEntryData.fromJson(jsonDecode(json));
  Serializer<CancelCashFlowEntryVariables> varsSerializer = (CancelCashFlowEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CancelCashFlowEntryData, CancelCashFlowEntryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CancelCashFlowEntryData, CancelCashFlowEntryVariables> ref() {
    CancelCashFlowEntryVariables vars= CancelCashFlowEntryVariables(spaceId: spaceId,entryId: entryId,reason: reason,);
    return _dataConnect.mutation("CancelCashFlowEntry", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CancelCashFlowEntryEntry {
  final String id;
  CancelCashFlowEntryEntry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelCashFlowEntryEntry otherTyped = other as CancelCashFlowEntryEntry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelCashFlowEntryEntry({
    required this.id,
  });
}

@immutable
class CancelCashFlowEntryAudit {
  final String id;
  CancelCashFlowEntryAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelCashFlowEntryAudit otherTyped = other as CancelCashFlowEntryAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelCashFlowEntryAudit({
    required this.id,
  });
}

@immutable
class CancelCashFlowEntryData {
  final CancelCashFlowEntryEntry? entry;
  final CancelCashFlowEntryAudit audit;
  CancelCashFlowEntryData.fromJson(dynamic json):
  
  entry = json['entry'] == null ? null : CancelCashFlowEntryEntry.fromJson(json['entry']),
  audit = CancelCashFlowEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelCashFlowEntryData otherTyped = other as CancelCashFlowEntryData;
    return entry == otherTyped.entry && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([entry.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (entry != null) {
      json['entry'] = entry!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  CancelCashFlowEntryData({
    this.entry,
    required this.audit,
  });
}

@immutable
class CancelCashFlowEntryVariables {
  final String spaceId;
  final String entryId;
  final String reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CancelCashFlowEntryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  entryId = nativeFromJson<String>(json['entryId']),
  reason = nativeFromJson<String>(json['reason']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelCashFlowEntryVariables otherTyped = other as CancelCashFlowEntryVariables;
    return spaceId == otherTyped.spaceId && 
    entryId == otherTyped.entryId && 
    reason == otherTyped.reason;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, entryId.hashCode, reason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  CancelCashFlowEntryVariables({
    required this.spaceId,
    required this.entryId,
    required this.reason,
  });
}

