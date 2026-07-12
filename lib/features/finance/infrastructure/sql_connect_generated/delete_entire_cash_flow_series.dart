part of 'client.dart';

class DeleteEntireCashFlowSeriesVariablesBuilder {
  String spaceId;
  String seriesId;
  CashFlowMutationScope scope;
  String reason;

  final FirebaseDataConnect _dataConnect;
  DeleteEntireCashFlowSeriesVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.seriesId,required  this.scope,required  this.reason,});
  Deserializer<DeleteEntireCashFlowSeriesData> dataDeserializer = (dynamic json)  => DeleteEntireCashFlowSeriesData.fromJson(jsonDecode(json));
  Serializer<DeleteEntireCashFlowSeriesVariables> varsSerializer = (DeleteEntireCashFlowSeriesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteEntireCashFlowSeriesData, DeleteEntireCashFlowSeriesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteEntireCashFlowSeriesData, DeleteEntireCashFlowSeriesVariables> ref() {
    DeleteEntireCashFlowSeriesVariables vars= DeleteEntireCashFlowSeriesVariables(spaceId: spaceId,seriesId: seriesId,scope: scope,reason: reason,);
    return _dataConnect.mutation("DeleteEntireCashFlowSeries", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteEntireCashFlowSeriesSeries {
  final String id;
  DeleteEntireCashFlowSeriesSeries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEntireCashFlowSeriesSeries otherTyped = other as DeleteEntireCashFlowSeriesSeries;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteEntireCashFlowSeriesSeries({
    required this.id,
  });
}

@immutable
class DeleteEntireCashFlowSeriesAudit {
  final String id;
  DeleteEntireCashFlowSeriesAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEntireCashFlowSeriesAudit otherTyped = other as DeleteEntireCashFlowSeriesAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteEntireCashFlowSeriesAudit({
    required this.id,
  });
}

@immutable
class DeleteEntireCashFlowSeriesData {
  final int entries;
  final DeleteEntireCashFlowSeriesSeries? series;
  final DeleteEntireCashFlowSeriesAudit audit;
  DeleteEntireCashFlowSeriesData.fromJson(dynamic json):
  
  entries = nativeFromJson<int>(json['entries']),
  series = json['series'] == null ? null : DeleteEntireCashFlowSeriesSeries.fromJson(json['series']),
  audit = DeleteEntireCashFlowSeriesAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEntireCashFlowSeriesData otherTyped = other as DeleteEntireCashFlowSeriesData;
    return entries == otherTyped.entries && 
    series == otherTyped.series && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([entries.hashCode, series.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entries'] = nativeToJson<int>(entries);
    if (series != null) {
      json['series'] = series!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  DeleteEntireCashFlowSeriesData({
    required this.entries,
    this.series,
    required this.audit,
  });
}

@immutable
class DeleteEntireCashFlowSeriesVariables {
  final String spaceId;
  final String seriesId;
  final CashFlowMutationScope scope;
  final String reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteEntireCashFlowSeriesVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  seriesId = nativeFromJson<String>(json['seriesId']),
  scope = CashFlowMutationScope.values.byName(json['scope']),
  reason = nativeFromJson<String>(json['reason']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEntireCashFlowSeriesVariables otherTyped = other as DeleteEntireCashFlowSeriesVariables;
    return spaceId == otherTyped.spaceId && 
    seriesId == otherTyped.seriesId && 
    scope == otherTyped.scope && 
    reason == otherTyped.reason;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, seriesId.hashCode, scope.hashCode, reason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['seriesId'] = nativeToJson<String>(seriesId);
    json['scope'] = 
    scope.name
    ;
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  DeleteEntireCashFlowSeriesVariables({
    required this.spaceId,
    required this.seriesId,
    required this.scope,
    required this.reason,
  });
}

