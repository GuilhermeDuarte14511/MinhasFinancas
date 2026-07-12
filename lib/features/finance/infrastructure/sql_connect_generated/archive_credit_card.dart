part of 'client.dart';

class ArchiveCreditCardVariablesBuilder {
  String spaceId;
  String cardId;

  final FirebaseDataConnect _dataConnect;
  ArchiveCreditCardVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.cardId,});
  Deserializer<ArchiveCreditCardData> dataDeserializer = (dynamic json)  => ArchiveCreditCardData.fromJson(jsonDecode(json));
  Serializer<ArchiveCreditCardVariables> varsSerializer = (ArchiveCreditCardVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ArchiveCreditCardData, ArchiveCreditCardVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ArchiveCreditCardData, ArchiveCreditCardVariables> ref() {
    ArchiveCreditCardVariables vars= ArchiveCreditCardVariables(spaceId: spaceId,cardId: cardId,);
    return _dataConnect.mutation("ArchiveCreditCard", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ArchiveCreditCardCard {
  final String id;
  ArchiveCreditCardCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCreditCardCard otherTyped = other as ArchiveCreditCardCard;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ArchiveCreditCardCard({
    required this.id,
  });
}

@immutable
class ArchiveCreditCardData {
  final ArchiveCreditCardCard? card;
  ArchiveCreditCardData.fromJson(dynamic json):
  
  card = json['card'] == null ? null : ArchiveCreditCardCard.fromJson(json['card']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCreditCardData otherTyped = other as ArchiveCreditCardData;
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

  ArchiveCreditCardData({
    this.card,
  });
}

@immutable
class ArchiveCreditCardVariables {
  final String spaceId;
  final String cardId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ArchiveCreditCardVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  cardId = nativeFromJson<String>(json['cardId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCreditCardVariables otherTyped = other as ArchiveCreditCardVariables;
    return spaceId == otherTyped.spaceId && 
    cardId == otherTyped.cardId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, cardId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    return json;
  }

  ArchiveCreditCardVariables({
    required this.spaceId,
    required this.cardId,
  });
}

