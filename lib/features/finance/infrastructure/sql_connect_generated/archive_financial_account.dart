part of 'client.dart';

class ArchiveFinancialAccountVariablesBuilder {
  String spaceId;
  String accountId;

  final FirebaseDataConnect _dataConnect;
  ArchiveFinancialAccountVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.accountId,});
  Deserializer<ArchiveFinancialAccountData> dataDeserializer = (dynamic json)  => ArchiveFinancialAccountData.fromJson(jsonDecode(json));
  Serializer<ArchiveFinancialAccountVariables> varsSerializer = (ArchiveFinancialAccountVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ArchiveFinancialAccountData, ArchiveFinancialAccountVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ArchiveFinancialAccountData, ArchiveFinancialAccountVariables> ref() {
    ArchiveFinancialAccountVariables vars= ArchiveFinancialAccountVariables(spaceId: spaceId,accountId: accountId,);
    return _dataConnect.mutation("ArchiveFinancialAccount", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ArchiveFinancialAccountAccount {
  final String id;
  ArchiveFinancialAccountAccount.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialAccountAccount otherTyped = other as ArchiveFinancialAccountAccount;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ArchiveFinancialAccountAccount({
    required this.id,
  });
}

@immutable
class ArchiveFinancialAccountData {
  final ArchiveFinancialAccountAccount? account;
  ArchiveFinancialAccountData.fromJson(dynamic json):
  
  account = json['account'] == null ? null : ArchiveFinancialAccountAccount.fromJson(json['account']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialAccountData otherTyped = other as ArchiveFinancialAccountData;
    return account == otherTyped.account;
    
  }
  @override
  int get hashCode => account.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (account != null) {
      json['account'] = account!.toJson();
    }
    return json;
  }

  ArchiveFinancialAccountData({
    this.account,
  });
}

@immutable
class ArchiveFinancialAccountVariables {
  final String spaceId;
  final String accountId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ArchiveFinancialAccountVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  accountId = nativeFromJson<String>(json['accountId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveFinancialAccountVariables otherTyped = other as ArchiveFinancialAccountVariables;
    return spaceId == otherTyped.spaceId && 
    accountId == otherTyped.accountId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, accountId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['accountId'] = nativeToJson<String>(accountId);
    return json;
  }

  ArchiveFinancialAccountVariables({
    required this.spaceId,
    required this.accountId,
  });
}

