part of 'client.dart';

class UpdateCreditCardVariablesBuilder {
  String spaceId;
  String cardId;
  String nickname;
  BigInt creditLimitCents;
  int closingDay;
  int dueDay;
  String colorHex;

  final FirebaseDataConnect _dataConnect;
  UpdateCreditCardVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.cardId,required  this.nickname,required  this.creditLimitCents,required  this.closingDay,required  this.dueDay,required  this.colorHex,});
  Deserializer<UpdateCreditCardData> dataDeserializer = (dynamic json)  => UpdateCreditCardData.fromJson(jsonDecode(json));
  Serializer<UpdateCreditCardVariables> varsSerializer = (UpdateCreditCardVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCreditCardData, UpdateCreditCardVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateCreditCardData, UpdateCreditCardVariables> ref() {
    UpdateCreditCardVariables vars= UpdateCreditCardVariables(spaceId: spaceId,cardId: cardId,nickname: nickname,creditLimitCents: creditLimitCents,closingDay: closingDay,dueDay: dueDay,colorHex: colorHex,);
    return _dataConnect.mutation("UpdateCreditCard", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateCreditCardCard {
  final String id;
  UpdateCreditCardCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCreditCardCard otherTyped = other as UpdateCreditCardCard;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCreditCardCard({
    required this.id,
  });
}

@immutable
class UpdateCreditCardData {
  final UpdateCreditCardCard? card;
  UpdateCreditCardData.fromJson(dynamic json):
  
  card = json['card'] == null ? null : UpdateCreditCardCard.fromJson(json['card']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCreditCardData otherTyped = other as UpdateCreditCardData;
    return card == otherTyped.card;
    
  }
  @override
  int get hashCode => card.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (card != null) {
      json['card'] = card!.toJson();
    }
    return json;
  }

  UpdateCreditCardData({
    this.card,
  });
}

@immutable
class UpdateCreditCardVariables {
  final String spaceId;
  final String cardId;
  final String nickname;
  final BigInt creditLimitCents;
  final int closingDay;
  final int dueDay;
  final String colorHex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateCreditCardVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  cardId = nativeFromJson<String>(json['cardId']),
  nickname = nativeFromJson<String>(json['nickname']),
  creditLimitCents = bigIntFromJson(json['creditLimitCents']),
  closingDay = nativeFromJson<int>(json['closingDay']),
  dueDay = nativeFromJson<int>(json['dueDay']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCreditCardVariables otherTyped = other as UpdateCreditCardVariables;
    return spaceId == otherTyped.spaceId && 
    cardId == otherTyped.cardId && 
    nickname == otherTyped.nickname && 
    creditLimitCents == otherTyped.creditLimitCents && 
    closingDay == otherTyped.closingDay && 
    dueDay == otherTyped.dueDay && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, cardId.hashCode, nickname.hashCode, creditLimitCents.hashCode, closingDay.hashCode, dueDay.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    json['nickname'] = nativeToJson<String>(nickname);
    json['creditLimitCents'] = bigIntToJson(creditLimitCents);
    json['closingDay'] = nativeToJson<int>(closingDay);
    json['dueDay'] = nativeToJson<int>(dueDay);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  UpdateCreditCardVariables({
    required this.spaceId,
    required this.cardId,
    required this.nickname,
    required this.creditLimitCents,
    required this.closingDay,
    required this.dueDay,
    required this.colorHex,
  });
}

