part of 'client.dart';

class CreateFinancialAccountVariablesBuilder {
  String spaceId;
  String name;
  String normalizedName;
  Optional<String> _institutionName = Optional.optional(nativeFromJson, nativeToJson);
  FinancialAccountType type;
  BigInt openingBalanceCents;
  Timestamp openingBalanceAt;
  String colorHex;
  bool includeInTotal;

  final FirebaseDataConnect _dataConnect;  CreateFinancialAccountVariablesBuilder institutionName(String? t) {
   _institutionName.value = t;
   return this;
  }

  CreateFinancialAccountVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.name,required  this.normalizedName,required  this.type,required  this.openingBalanceCents,required  this.openingBalanceAt,required  this.colorHex,required  this.includeInTotal,});
  Deserializer<CreateFinancialAccountData> dataDeserializer = (dynamic json)  => CreateFinancialAccountData.fromJson(jsonDecode(json));
  Serializer<CreateFinancialAccountVariables> varsSerializer = (CreateFinancialAccountVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateFinancialAccountData, CreateFinancialAccountVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateFinancialAccountData, CreateFinancialAccountVariables> ref() {
    CreateFinancialAccountVariables vars= CreateFinancialAccountVariables(spaceId: spaceId,name: name,normalizedName: normalizedName,institutionName: _institutionName,type: type,openingBalanceCents: openingBalanceCents,openingBalanceAt: openingBalanceAt,colorHex: colorHex,includeInTotal: includeInTotal,);
    return _dataConnect.mutation("CreateFinancialAccount", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateFinancialAccountAccount {
  final String id;
  CreateFinancialAccountAccount.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialAccountAccount otherTyped = other as CreateFinancialAccountAccount;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialAccountAccount({
    required this.id,
  });
}

@immutable
class CreateFinancialAccountAudit {
  final String id;
  CreateFinancialAccountAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialAccountAudit otherTyped = other as CreateFinancialAccountAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialAccountAudit({
    required this.id,
  });
}

@immutable
class CreateFinancialAccountData {
  final CreateFinancialAccountAccount account;
  final CreateFinancialAccountAudit audit;
  CreateFinancialAccountData.fromJson(dynamic json):
  
  account = CreateFinancialAccountAccount.fromJson(json['account']),
  audit = CreateFinancialAccountAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialAccountData otherTyped = other as CreateFinancialAccountData;
    return account == otherTyped.account && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([account.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['account'] = account.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateFinancialAccountData({
    required this.account,
    required this.audit,
  });
}

@immutable
class CreateFinancialAccountVariables {
  final String spaceId;
  final String name;
  final String normalizedName;
  late final Optional<String>institutionName;
  final FinancialAccountType type;
  final BigInt openingBalanceCents;
  final Timestamp openingBalanceAt;
  final String colorHex;
  final bool includeInTotal;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateFinancialAccountVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  name = nativeFromJson<String>(json['name']),
  normalizedName = nativeFromJson<String>(json['normalizedName']),
  type = FinancialAccountType.values.byName(json['type']),
  openingBalanceCents = bigIntFromJson(json['openingBalanceCents']),
  openingBalanceAt = Timestamp.fromJson(json['openingBalanceAt']),
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

    final CreateFinancialAccountVariables otherTyped = other as CreateFinancialAccountVariables;
    return spaceId == otherTyped.spaceId && 
    name == otherTyped.name && 
    normalizedName == otherTyped.normalizedName && 
    institutionName == otherTyped.institutionName && 
    type == otherTyped.type && 
    openingBalanceCents == otherTyped.openingBalanceCents && 
    openingBalanceAt == otherTyped.openingBalanceAt && 
    colorHex == otherTyped.colorHex && 
    includeInTotal == otherTyped.includeInTotal;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, name.hashCode, normalizedName.hashCode, institutionName.hashCode, type.hashCode, openingBalanceCents.hashCode, openingBalanceAt.hashCode, colorHex.hashCode, includeInTotal.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['name'] = nativeToJson<String>(name);
    json['normalizedName'] = nativeToJson<String>(normalizedName);
    if(institutionName.state == OptionalState.set) {
      json['institutionName'] = institutionName.toJson();
    }
    json['type'] = 
    type.name
    ;
    json['openingBalanceCents'] = bigIntToJson(openingBalanceCents);
    json['openingBalanceAt'] = openingBalanceAt.toJson();
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['includeInTotal'] = nativeToJson<bool>(includeInTotal);
    return json;
  }

  CreateFinancialAccountVariables({
    required this.spaceId,
    required this.name,
    required this.normalizedName,
    required this.institutionName,
    required this.type,
    required this.openingBalanceCents,
    required this.openingBalanceAt,
    required this.colorHex,
    required this.includeInTotal,
  });
}

