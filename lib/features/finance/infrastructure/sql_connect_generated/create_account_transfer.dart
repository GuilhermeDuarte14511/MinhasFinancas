part of 'client.dart';

class CreateAccountTransferVariablesBuilder {
  String spaceId;
  String fromAccountId;
  String toAccountId;
  BigInt amountCents;
  Timestamp transferredAt;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;  CreateAccountTransferVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  CreateAccountTransferVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.fromAccountId,required  this.toAccountId,required  this.amountCents,required  this.transferredAt,required  this.idempotencyKey,});
  Deserializer<CreateAccountTransferData> dataDeserializer = (dynamic json)  => CreateAccountTransferData.fromJson(jsonDecode(json));
  Serializer<CreateAccountTransferVariables> varsSerializer = (CreateAccountTransferVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAccountTransferData, CreateAccountTransferVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAccountTransferData, CreateAccountTransferVariables> ref() {
    CreateAccountTransferVariables vars= CreateAccountTransferVariables(spaceId: spaceId,fromAccountId: fromAccountId,toAccountId: toAccountId,amountCents: amountCents,transferredAt: transferredAt,notes: _notes,idempotencyKey: idempotencyKey,);
    return _dataConnect.mutation("CreateAccountTransfer", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAccountTransferTransfer {
  final String id;
  CreateAccountTransferTransfer.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAccountTransferTransfer otherTyped = other as CreateAccountTransferTransfer;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAccountTransferTransfer({
    required this.id,
  });
}

@immutable
class CreateAccountTransferAudit {
  final String id;
  CreateAccountTransferAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAccountTransferAudit otherTyped = other as CreateAccountTransferAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAccountTransferAudit({
    required this.id,
  });
}

@immutable
class CreateAccountTransferData {
  final CreateAccountTransferTransfer transfer;
  final CreateAccountTransferAudit audit;
  CreateAccountTransferData.fromJson(dynamic json):
  
  transfer = CreateAccountTransferTransfer.fromJson(json['transfer']),
  audit = CreateAccountTransferAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAccountTransferData otherTyped = other as CreateAccountTransferData;
    return transfer == otherTyped.transfer && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([transfer.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['transfer'] = transfer.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateAccountTransferData({
    required this.transfer,
    required this.audit,
  });
}

@immutable
class CreateAccountTransferVariables {
  final String spaceId;
  final String fromAccountId;
  final String toAccountId;
  final BigInt amountCents;
  final Timestamp transferredAt;
  late final Optional<String>notes;
  final String idempotencyKey;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAccountTransferVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  fromAccountId = nativeFromJson<String>(json['fromAccountId']),
  toAccountId = nativeFromJson<String>(json['toAccountId']),
  amountCents = bigIntFromJson(json['amountCents']),
  transferredAt = Timestamp.fromJson(json['transferredAt']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
  
  
  
  
  
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAccountTransferVariables otherTyped = other as CreateAccountTransferVariables;
    return spaceId == otherTyped.spaceId && 
    fromAccountId == otherTyped.fromAccountId && 
    toAccountId == otherTyped.toAccountId && 
    amountCents == otherTyped.amountCents && 
    transferredAt == otherTyped.transferredAt && 
    notes == otherTyped.notes && 
    idempotencyKey == otherTyped.idempotencyKey;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, fromAccountId.hashCode, toAccountId.hashCode, amountCents.hashCode, transferredAt.hashCode, notes.hashCode, idempotencyKey.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['fromAccountId'] = nativeToJson<String>(fromAccountId);
    json['toAccountId'] = nativeToJson<String>(toAccountId);
    json['amountCents'] = bigIntToJson(amountCents);
    json['transferredAt'] = transferredAt.toJson();
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  CreateAccountTransferVariables({
    required this.spaceId,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amountCents,
    required this.transferredAt,
    required this.notes,
    required this.idempotencyKey,
  });
}

