part of 'client.dart';

class DeleteStandaloneCashFlowEntryVariablesBuilder {
  String spaceId;
  String entryId;
  CashFlowMutationScope scope;

  final FirebaseDataConnect _dataConnect;
  DeleteStandaloneCashFlowEntryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.entryId,required  this.scope,});
  Deserializer<DeleteStandaloneCashFlowEntryData> dataDeserializer = (dynamic json)  => DeleteStandaloneCashFlowEntryData.fromJson(jsonDecode(json));
  Serializer<DeleteStandaloneCashFlowEntryVariables> varsSerializer = (DeleteStandaloneCashFlowEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteStandaloneCashFlowEntryData, DeleteStandaloneCashFlowEntryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteStandaloneCashFlowEntryData, DeleteStandaloneCashFlowEntryVariables> ref() {
    DeleteStandaloneCashFlowEntryVariables vars= DeleteStandaloneCashFlowEntryVariables(spaceId: spaceId,entryId: entryId,scope: scope,);
    return _dataConnect.mutation("DeleteStandaloneCashFlowEntry", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteStandaloneCashFlowEntryEntry {
  final String id;
  DeleteStandaloneCashFlowEntryEntry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStandaloneCashFlowEntryEntry otherTyped = other as DeleteStandaloneCashFlowEntryEntry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStandaloneCashFlowEntryEntry({
    required this.id,
  });
}

@immutable
class DeleteStandaloneCashFlowEntryAudit {
  final String id;
  DeleteStandaloneCashFlowEntryAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStandaloneCashFlowEntryAudit otherTyped = other as DeleteStandaloneCashFlowEntryAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStandaloneCashFlowEntryAudit({
    required this.id,
  });
}

@immutable
class DeleteStandaloneCashFlowEntryData {
  final DeleteStandaloneCashFlowEntryEntry? entry;
  final DeleteStandaloneCashFlowEntryAudit audit;
  DeleteStandaloneCashFlowEntryData.fromJson(dynamic json):
  
  entry = json['entry'] == null ? null : DeleteStandaloneCashFlowEntryEntry.fromJson(json['entry']),
  audit = DeleteStandaloneCashFlowEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStandaloneCashFlowEntryData otherTyped = other as DeleteStandaloneCashFlowEntryData;
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

  DeleteStandaloneCashFlowEntryData({
    this.entry,
    required this.audit,
  });
}

@immutable
class DeleteStandaloneCashFlowEntryVariables {
  final String spaceId;
  final String entryId;
  final CashFlowMutationScope scope;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteStandaloneCashFlowEntryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  entryId = nativeFromJson<String>(json['entryId']),
  scope = CashFlowMutationScope.values.byName(json['scope']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStandaloneCashFlowEntryVariables otherTyped = other as DeleteStandaloneCashFlowEntryVariables;
    return spaceId == otherTyped.spaceId && 
    entryId == otherTyped.entryId && 
    scope == otherTyped.scope;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, entryId.hashCode, scope.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['scope'] = 
    scope.name
    ;
    return json;
  }

  DeleteStandaloneCashFlowEntryVariables({
    required this.spaceId,
    required this.entryId,
    required this.scope,
  });
}

