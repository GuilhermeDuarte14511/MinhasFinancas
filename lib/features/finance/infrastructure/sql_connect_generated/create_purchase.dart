part of 'client.dart';

class CreatePurchaseVariablesBuilder {
  String spaceId;
  String cardId;
  String categoryId;
  String description;
  Optional<String> _merchantName = Optional.optional(nativeFromJson, nativeToJson);
  BigInt totalAmountCents;
  DateTime purchaseDate;
  int installmentCount;
  DateTime firstInvoiceReference;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreatePurchaseVariablesBuilder merchantName(String? t) {
   _merchantName.value = t;
   return this;
  }
  CreatePurchaseVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  CreatePurchaseVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.cardId,required  this.categoryId,required  this.description,required  this.totalAmountCents,required  this.purchaseDate,required  this.installmentCount,required  this.firstInvoiceReference,});
  Deserializer<CreatePurchaseData> dataDeserializer = (dynamic json)  => CreatePurchaseData.fromJson(jsonDecode(json));
  Serializer<CreatePurchaseVariables> varsSerializer = (CreatePurchaseVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePurchaseData, CreatePurchaseVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePurchaseData, CreatePurchaseVariables> ref() {
    CreatePurchaseVariables vars= CreatePurchaseVariables(spaceId: spaceId,cardId: cardId,categoryId: categoryId,description: description,merchantName: _merchantName,totalAmountCents: totalAmountCents,purchaseDate: purchaseDate,installmentCount: installmentCount,firstInvoiceReference: firstInvoiceReference,notes: _notes,);
    return _dataConnect.mutation("CreatePurchase", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePurchasePurchase {
  final String id;
  CreatePurchasePurchase.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePurchasePurchase otherTyped = other as CreatePurchasePurchase;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePurchasePurchase({
    required this.id,
  });
}

@immutable
class CreatePurchaseAudit {
  final String id;
  CreatePurchaseAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePurchaseAudit otherTyped = other as CreatePurchaseAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePurchaseAudit({
    required this.id,
  });
}

@immutable
class CreatePurchaseData {
  final CreatePurchasePurchase purchase;
  final CreatePurchaseAudit audit;
  CreatePurchaseData.fromJson(dynamic json):
  
  purchase = CreatePurchasePurchase.fromJson(json['purchase']),
  audit = CreatePurchaseAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePurchaseData otherTyped = other as CreatePurchaseData;
    return purchase == otherTyped.purchase && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([purchase.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['purchase'] = purchase.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreatePurchaseData({
    required this.purchase,
    required this.audit,
  });
}

@immutable
class CreatePurchaseVariables {
  final String spaceId;
  final String cardId;
  final String categoryId;
  final String description;
  late final Optional<String>merchantName;
  final BigInt totalAmountCents;
  final DateTime purchaseDate;
  final int installmentCount;
  final DateTime firstInvoiceReference;
  late final Optional<String>notes;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePurchaseVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  cardId = nativeFromJson<String>(json['cardId']),
  categoryId = nativeFromJson<String>(json['categoryId']),
  description = nativeFromJson<String>(json['description']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  purchaseDate = nativeFromJson<DateTime>(json['purchaseDate']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  firstInvoiceReference = nativeFromJson<DateTime>(json['firstInvoiceReference']) {
  
  
  
  
  
  
    merchantName = Optional.optional(nativeFromJson, nativeToJson);
    merchantName.value = json['merchantName'] == null ? null : nativeFromJson<String>(json['merchantName']);
  
  
  
  
  
  
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

    final CreatePurchaseVariables otherTyped = other as CreatePurchaseVariables;
    return spaceId == otherTyped.spaceId && 
    cardId == otherTyped.cardId && 
    categoryId == otherTyped.categoryId && 
    description == otherTyped.description && 
    merchantName == otherTyped.merchantName && 
    totalAmountCents == otherTyped.totalAmountCents && 
    purchaseDate == otherTyped.purchaseDate && 
    installmentCount == otherTyped.installmentCount && 
    firstInvoiceReference == otherTyped.firstInvoiceReference && 
    notes == otherTyped.notes;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, cardId.hashCode, categoryId.hashCode, description.hashCode, merchantName.hashCode, totalAmountCents.hashCode, purchaseDate.hashCode, installmentCount.hashCode, firstInvoiceReference.hashCode, notes.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['description'] = nativeToJson<String>(description);
    if(merchantName.state == OptionalState.set) {
      json['merchantName'] = merchantName.toJson();
    }
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['purchaseDate'] = nativeToJson<DateTime>(purchaseDate);
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    json['firstInvoiceReference'] = nativeToJson<DateTime>(firstInvoiceReference);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    return json;
  }

  CreatePurchaseVariables({
    required this.spaceId,
    required this.cardId,
    required this.categoryId,
    required this.description,
    required this.merchantName,
    required this.totalAmountCents,
    required this.purchaseDate,
    required this.installmentCount,
    required this.firstInvoiceReference,
    required this.notes,
  });
}

