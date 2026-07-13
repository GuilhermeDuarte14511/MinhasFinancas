part of 'client.dart';

class CancelAccountTransferVariablesBuilder {
  String spaceId;
  String transferId;

  final FirebaseDataConnect _dataConnect;
  CancelAccountTransferVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.transferId,});
  Deserializer<CancelAccountTransferData> dataDeserializer = (dynamic json)  => CancelAccountTransferData.fromJson(jsonDecode(json));
  Serializer<CancelAccountTransferVariables> varsSerializer = (CancelAccountTransferVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CancelAccountTransferData, CancelAccountTransferVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CancelAccountTransferData, CancelAccountTransferVariables> ref() {
    CancelAccountTransferVariables vars= CancelAccountTransferVariables(spaceId: spaceId,transferId: transferId,);
    return _dataConnect.mutation("CancelAccountTransfer", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CancelAccountTransferTransfer {
  final String id;
  CancelAccountTransferTransfer.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelAccountTransferTransfer otherTyped = other as CancelAccountTransferTransfer;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelAccountTransferTransfer({
    required this.id,
  });
}

@immutable
class CancelAccountTransferData {
  final CancelAccountTransferTransfer? transfer;
  CancelAccountTransferData.fromJson(dynamic json):
  
  transfer = json['transfer'] == null ? null : CancelAccountTransferTransfer.fromJson(json['transfer']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelAccountTransferData otherTyped = other as CancelAccountTransferData;
    return transfer == otherTyped.transfer;
    
  }
  @override
  int get hashCode => transfer.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (transfer != null) {
      json['transfer'] = transfer!.toJson();
    }
    return json;
  }

  CancelAccountTransferData({
    this.transfer,
  });
}

@immutable
class CancelAccountTransferVariables {
  final String spaceId;
  final String transferId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CancelAccountTransferVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  transferId = nativeFromJson<String>(json['transferId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelAccountTransferVariables otherTyped = other as CancelAccountTransferVariables;
    return spaceId == otherTyped.spaceId && 
    transferId == otherTyped.transferId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, transferId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['transferId'] = nativeToJson<String>(transferId);
    return json;
  }

  CancelAccountTransferVariables({
    required this.spaceId,
    required this.transferId,
  });
}

