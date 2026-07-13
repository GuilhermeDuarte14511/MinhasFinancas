part of 'client.dart';

class UpdateFinancialAccountVariablesBuilder {
  String spaceId;
  String accountId;
  String name;
  String normalizedName;
  Optional<String> _institutionName = Optional.optional(nativeFromJson, nativeToJson);
  FinancialAccountType type;
  String colorHex;
  bool includeInTotal;

  final FirebaseDataConnect _dataConnect;  UpdateFinancialAccountVariablesBuilder institutionName(String? t) {
   _institutionName.value = t;
   return this;
  }

  UpdateFinancialAccountVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.accountId,required  this.name,required  this.normalizedName,required  this.type,required  this.colorHex,required  this.includeInTotal,});
  Deserializer<UpdateFinancialAccountData> dataDeserializer = (dynamic json)  => UpdateFinancialAccountData.fromJson(jsonDecode(json));
  Serializer<UpdateFinancialAccountVariables> varsSerializer = (UpdateFinancialAccountVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateFinancialAccountData, UpdateFinancialAccountVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateFinancialAccountData, UpdateFinancialAccountVariables> ref() {
    UpdateFinancialAccountVariables vars= UpdateFinancialAccountVariables(spaceId: spaceId,accountId: accountId,name: name,normalizedName: normalizedName,institutionName: _institutionName,type: type,colorHex: colorHex,includeInTotal: includeInTotal,);
    return _dataConnect.mutation("UpdateFinancialAccount", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateFinancialAccountAccount {
  final String id;
  UpdateFinancialAccountAccount.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialAccountAccount otherTyped = other as UpdateFinancialAccountAccount;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateFinancialAccountAccount({
    required this.id,
  });
}

@immutable
class UpdateFinancialAccountData {
  final UpdateFinancialAccountAccount? account;
  UpdateFinancialAccountData.fromJson(dynamic json):
  
  account = json['account'] == null ? null : UpdateFinancialAccountAccount.fromJson(json['account']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialAccountData otherTyped = other as UpdateFinancialAccountData;
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

  UpdateFinancialAccountData({
    this.account,
  });
}

@immutable
class UpdateFinancialAccountVariables {
  final String spaceId;
  final String accountId;
  final String name;
  final String normalizedName;
  late final Optional<String>institutionName;
  final FinancialAccountType type;
  final String colorHex;
  final bool includeInTotal;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateFinancialAccountVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  accountId = nativeFromJson<String>(json['accountId']),
  name = nativeFromJson<String>(json['name']),
  normalizedName = nativeFromJson<String>(json['normalizedName']),
  type = FinancialAccountType.values.byName(json['type']),
  colorHex = nativeFromJson<String>(json['colorHex']),
  includeInTotal = nativeFromJson<bool>(json['includeInTotal']) {
  
  
  
  
  
  
    institutionName = Optional.optional(nativeFromJson, nativeToJson);
    institutionName.value = json['institutionName'] == null ? null : nativeFromJson<String>(json['institutionName']);
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateFinancialAccountVariables otherTyped = other as UpdateFinancialAccountVariables;
    return spaceId == otherTyped.spaceId && 
    accountId == otherTyped.accountId && 
    name == otherTyped.name && 
    normalizedName == otherTyped.normalizedName && 
    institutionName == otherTyped.institutionName && 
    type == otherTyped.type && 
    colorHex == otherTyped.colorHex && 
    includeInTotal == otherTyped.includeInTotal;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, accountId.hashCode, name.hashCode, normalizedName.hashCode, institutionName.hashCode, type.hashCode, colorHex.hashCode, includeInTotal.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['accountId'] = nativeToJson<String>(accountId);
    json['name'] = nativeToJson<String>(name);
    json['normalizedName'] = nativeToJson<String>(normalizedName);
    if(institutionName.state == OptionalState.set) {
      json['institutionName'] = institutionName.toJson();
    }
    json['type'] = 
    type.name
    ;
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['includeInTotal'] = nativeToJson<bool>(includeInTotal);
    return json;
  }

  UpdateFinancialAccountVariables({
    required this.spaceId,
    required this.accountId,
    required this.name,
    required this.normalizedName,
    required this.institutionName,
    required this.type,
    required this.colorHex,
    required this.includeInTotal,
  });
}

