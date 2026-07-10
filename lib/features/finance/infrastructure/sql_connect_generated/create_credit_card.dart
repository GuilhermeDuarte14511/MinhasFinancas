part of 'client.dart';

class CreateCreditCardVariablesBuilder {
  String spaceId;
  String nickname;
  Optional<String> _institutionName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _brand = Optional.optional(nativeFromJson, nativeToJson);
  String lastFourDigits;
  BigInt creditLimitCents;
  int closingDay;
  int dueDay;
  String colorHex;

  final FirebaseDataConnect _dataConnect;  CreateCreditCardVariablesBuilder institutionName(String? t) {
   _institutionName.value = t;
   return this;
  }
  CreateCreditCardVariablesBuilder brand(String? t) {
   _brand.value = t;
   return this;
  }

  CreateCreditCardVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.nickname,required  this.lastFourDigits,required  this.creditLimitCents,required  this.closingDay,required  this.dueDay,required  this.colorHex,});
  Deserializer<CreateCreditCardData> dataDeserializer = (dynamic json)  => CreateCreditCardData.fromJson(jsonDecode(json));
  Serializer<CreateCreditCardVariables> varsSerializer = (CreateCreditCardVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCreditCardData, CreateCreditCardVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateCreditCardData, CreateCreditCardVariables> ref() {
    CreateCreditCardVariables vars= CreateCreditCardVariables(spaceId: spaceId,nickname: nickname,institutionName: _institutionName,brand: _brand,lastFourDigits: lastFourDigits,creditLimitCents: creditLimitCents,closingDay: closingDay,dueDay: dueDay,colorHex: colorHex,);
    return _dataConnect.mutation("CreateCreditCard", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateCreditCardCard {
  final String id;
  CreateCreditCardCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardCard otherTyped = other as CreateCreditCardCard;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCreditCardCard({
    required this.id,
  });
}

@immutable
class CreateCreditCardAudit {
  final String id;
  CreateCreditCardAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardAudit otherTyped = other as CreateCreditCardAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCreditCardAudit({
    required this.id,
  });
}

@immutable
class CreateCreditCardData {
  final CreateCreditCardCard card;
  final CreateCreditCardAudit audit;
  CreateCreditCardData.fromJson(dynamic json):
  
  card = CreateCreditCardCard.fromJson(json['card']),
  audit = CreateCreditCardAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardData otherTyped = other as CreateCreditCardData;
    return card == otherTyped.card && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([card.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['card'] = card.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateCreditCardData({
    required this.card,
    required this.audit,
  });
}

@immutable
class CreateCreditCardVariables {
  final String spaceId;
  final String nickname;
  late final Optional<String>institutionName;
  late final Optional<String>brand;
  final String lastFourDigits;
  final BigInt creditLimitCents;
  final int closingDay;
  final int dueDay;
  final String colorHex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateCreditCardVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  nickname = nativeFromJson<String>(json['nickname']),
  lastFourDigits = nativeFromJson<String>(json['lastFourDigits']),
  creditLimitCents = bigIntFromJson(json['creditLimitCents']),
  closingDay = nativeFromJson<int>(json['closingDay']),
  dueDay = nativeFromJson<int>(json['dueDay']),
  colorHex = nativeFromJson<String>(json['colorHex']) {
  
  
  
  
    institutionName = Optional.optional(nativeFromJson, nativeToJson);
    institutionName.value = json['institutionName'] == null ? null : nativeFromJson<String>(json['institutionName']);
  
  
    brand = Optional.optional(nativeFromJson, nativeToJson);
    brand.value = json['brand'] == null ? null : nativeFromJson<String>(json['brand']);
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardVariables otherTyped = other as CreateCreditCardVariables;
    return spaceId == otherTyped.spaceId && 
    nickname == otherTyped.nickname && 
    institutionName == otherTyped.institutionName && 
    brand == otherTyped.brand && 
    lastFourDigits == otherTyped.lastFourDigits && 
    creditLimitCents == otherTyped.creditLimitCents && 
    closingDay == otherTyped.closingDay && 
    dueDay == otherTyped.dueDay && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, nickname.hashCode, institutionName.hashCode, brand.hashCode, lastFourDigits.hashCode, creditLimitCents.hashCode, closingDay.hashCode, dueDay.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['nickname'] = nativeToJson<String>(nickname);
    if(institutionName.state == OptionalState.set) {
      json['institutionName'] = institutionName.toJson();
    }
    if(brand.state == OptionalState.set) {
      json['brand'] = brand.toJson();
    }
    json['lastFourDigits'] = nativeToJson<String>(lastFourDigits);
    json['creditLimitCents'] = bigIntToJson(creditLimitCents);
    json['closingDay'] = nativeToJson<int>(closingDay);
    json['dueDay'] = nativeToJson<int>(dueDay);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  CreateCreditCardVariables({
    required this.spaceId,
    required this.nickname,
    required this.institutionName,
    required this.brand,
    required this.lastFourDigits,
    required this.creditLimitCents,
    required this.closingDay,
    required this.dueDay,
    required this.colorHex,
  });
}

