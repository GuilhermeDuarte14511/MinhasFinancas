part of 'client.dart';

class ListWorkspaceActivityHistoryVariablesBuilder {
  String spaceId;
  int limit;
  int offset;

  final FirebaseDataConnect _dataConnect;
  ListWorkspaceActivityHistoryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.limit,required  this.offset,});
  Deserializer<ListWorkspaceActivityHistoryData> dataDeserializer = (dynamic json)  => ListWorkspaceActivityHistoryData.fromJson(jsonDecode(json));
  Serializer<ListWorkspaceActivityHistoryVariables> varsSerializer = (ListWorkspaceActivityHistoryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListWorkspaceActivityHistoryData, ListWorkspaceActivityHistoryVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListWorkspaceActivityHistoryData, ListWorkspaceActivityHistoryVariables> ref() {
    ListWorkspaceActivityHistoryVariables vars= ListWorkspaceActivityHistoryVariables(spaceId: spaceId,limit: limit,offset: offset,);
    return _dataConnect.query("ListWorkspaceActivityHistory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListWorkspaceActivityHistoryAuditEvents {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String summary;
  final Timestamp occurredAt;
  final ListWorkspaceActivityHistoryAuditEventsActorUser actorUser;
  ListWorkspaceActivityHistoryAuditEvents.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  entityType = nativeFromJson<String>(json['entityType']),
  entityId = nativeFromJson<String>(json['entityId']),
  action = nativeFromJson<String>(json['action']),
  summary = nativeFromJson<String>(json['summary']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  actorUser = ListWorkspaceActivityHistoryAuditEventsActorUser.fromJson(json['actorUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceActivityHistoryAuditEvents otherTyped = other as ListWorkspaceActivityHistoryAuditEvents;
    return id == otherTyped.id && 
    entityType == otherTyped.entityType && 
    entityId == otherTyped.entityId && 
    action == otherTyped.action && 
    summary == otherTyped.summary && 
    occurredAt == otherTyped.occurredAt && 
    actorUser == otherTyped.actorUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, entityType.hashCode, entityId.hashCode, action.hashCode, summary.hashCode, occurredAt.hashCode, actorUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['entityType'] = nativeToJson<String>(entityType);
    json['entityId'] = nativeToJson<String>(entityId);
    json['action'] = nativeToJson<String>(action);
    json['summary'] = nativeToJson<String>(summary);
    json['occurredAt'] = occurredAt.toJson();
    json['actorUser'] = actorUser.toJson();
    return json;
  }

  ListWorkspaceActivityHistoryAuditEvents({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.summary,
    required this.occurredAt,
    required this.actorUser,
  });
}

@immutable
class ListWorkspaceActivityHistoryAuditEventsActorUser {
  final String displayName;
  ListWorkspaceActivityHistoryAuditEventsActorUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceActivityHistoryAuditEventsActorUser otherTyped = other as ListWorkspaceActivityHistoryAuditEventsActorUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  ListWorkspaceActivityHistoryAuditEventsActorUser({
    required this.displayName,
  });
}

@immutable
class ListWorkspaceActivityHistoryData {
  final List<ListWorkspaceActivityHistoryAuditEvents> auditEvents;
  ListWorkspaceActivityHistoryData.fromJson(dynamic json):
  
  auditEvents = (json['auditEvents'] as List<dynamic>)
        .map((e) => ListWorkspaceActivityHistoryAuditEvents.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceActivityHistoryData otherTyped = other as ListWorkspaceActivityHistoryData;
    return auditEvents == otherTyped.auditEvents;
    
  }
  @override
  int get hashCode => auditEvents.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['auditEvents'] = auditEvents.map((e) => e.toJson()).toList();
    return json;
  }

  ListWorkspaceActivityHistoryData({
    required this.auditEvents,
  });
}

@immutable
class ListWorkspaceActivityHistoryVariables {
  final String spaceId;
  final int limit;
  final int offset;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListWorkspaceActivityHistoryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  limit = nativeFromJson<int>(json['limit']),
  offset = nativeFromJson<int>(json['offset']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceActivityHistoryVariables otherTyped = other as ListWorkspaceActivityHistoryVariables;
    return spaceId == otherTyped.spaceId && 
    limit == otherTyped.limit && 
    offset == otherTyped.offset;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, limit.hashCode, offset.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['limit'] = nativeToJson<int>(limit);
    json['offset'] = nativeToJson<int>(offset);
    return json;
  }

  ListWorkspaceActivityHistoryVariables({
    required this.spaceId,
    required this.limit,
    required this.offset,
  });
}

