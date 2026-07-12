part of 'client.dart';

class MarkIncomeEntryReceivedVariablesBuilder {
  String spaceId;
  String entryId;
  Timestamp receivedAt;

  final FirebaseDataConnect _dataConnect;
  MarkIncomeEntryReceivedVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.entryId,required  this.receivedAt,});
  Deserializer<MarkIncomeEntryReceivedData> dataDeserializer = (dynamic json)  => MarkIncomeEntryReceivedData.fromJson(jsonDecode(json));
  Serializer<MarkIncomeEntryReceivedVariables> varsSerializer = (MarkIncomeEntryReceivedVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<MarkIncomeEntryReceivedData, MarkIncomeEntryReceivedVariables>> execute() {
    return ref().execute();
  }

  MutationRef<MarkIncomeEntryReceivedData, MarkIncomeEntryReceivedVariables> ref() {
    MarkIncomeEntryReceivedVariables vars= MarkIncomeEntryReceivedVariables(spaceId: spaceId,entryId: entryId,receivedAt: receivedAt,);
    return _dataConnect.mutation("MarkIncomeEntryReceived", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class MarkIncomeEntryReceivedEntry {
  final String id;
  MarkIncomeEntryReceivedEntry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkIncomeEntryReceivedEntry otherTyped = other as MarkIncomeEntryReceivedEntry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  MarkIncomeEntryReceivedEntry({
    required this.id,
  });
}

@immutable
class MarkIncomeEntryReceivedData {
  final MarkIncomeEntryReceivedEntry? entry;
  MarkIncomeEntryReceivedData.fromJson(dynamic json):
  
  entry = json['entry'] == null ? null : MarkIncomeEntryReceivedEntry.fromJson(json['entry']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkIncomeEntryReceivedData otherTyped = other as MarkIncomeEntryReceivedData;
    return entry == otherTyped.entry;
    
  }
  @override
  int get hashCode => entry.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (entry != null) {
      json['entry'] = entry!.toJson();
    }
    return json;
  }

  MarkIncomeEntryReceivedData({
    this.entry,
  });
}

@immutable
class MarkIncomeEntryReceivedVariables {
  final String spaceId;
  final String entryId;
  final Timestamp receivedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  MarkIncomeEntryReceivedVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  entryId = nativeFromJson<String>(json['entryId']),
  receivedAt = Timestamp.fromJson(json['receivedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkIncomeEntryReceivedVariables otherTyped = other as MarkIncomeEntryReceivedVariables;
    return spaceId == otherTyped.spaceId && 
    entryId == otherTyped.entryId && 
    receivedAt == otherTyped.receivedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, entryId.hashCode, receivedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['entryId'] = nativeToJson<String>(entryId);
    json['receivedAt'] = receivedAt.toJson();
    return json;
  }

  MarkIncomeEntryReceivedVariables({
    required this.spaceId,
    required this.entryId,
    required this.receivedAt,
  });
}

