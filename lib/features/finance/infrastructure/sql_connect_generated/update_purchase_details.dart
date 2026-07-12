part of 'client.dart';

class UpdatePurchaseDetailsVariablesBuilder {
  String spaceId;
  String purchaseId;
  String description;
  String categoryId;

  final FirebaseDataConnect _dataConnect;
  UpdatePurchaseDetailsVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.purchaseId,required  this.description,required  this.categoryId,});
  Deserializer<UpdatePurchaseDetailsData> dataDeserializer = (dynamic json)  => UpdatePurchaseDetailsData.fromJson(jsonDecode(json));
  Serializer<UpdatePurchaseDetailsVariables> varsSerializer = (UpdatePurchaseDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdatePurchaseDetailsData, UpdatePurchaseDetailsVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdatePurchaseDetailsData, UpdatePurchaseDetailsVariables> ref() {
    UpdatePurchaseDetailsVariables vars= UpdatePurchaseDetailsVariables(spaceId: spaceId,purchaseId: purchaseId,description: description,categoryId: categoryId,);
    return _dataConnect.mutation("UpdatePurchaseDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdatePurchaseDetailsPurchase {
  final String id;
  UpdatePurchaseDetailsPurchase.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePurchaseDetailsPurchase otherTyped = other as UpdatePurchaseDetailsPurchase;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdatePurchaseDetailsPurchase({
    required this.id,
  });
}

@immutable
class UpdatePurchaseDetailsData {
  final UpdatePurchaseDetailsPurchase? purchase;
  UpdatePurchaseDetailsData.fromJson(dynamic json):
  
  purchase = json['purchase'] == null ? null : UpdatePurchaseDetailsPurchase.fromJson(json['purchase']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePurchaseDetailsData otherTyped = other as UpdatePurchaseDetailsData;
    return purchase == otherTyped.purchase;
    
  }
  @override
  int get hashCode => purchase.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (purchase != null) {
      json['purchase'] = purchase!.toJson();
    }
    return json;
  }

  UpdatePurchaseDetailsData({
    this.purchase,
  });
}

@immutable
class UpdatePurchaseDetailsVariables {
  final String spaceId;
  final String purchaseId;
  final String description;
  final String categoryId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdatePurchaseDetailsVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  purchaseId = nativeFromJson<String>(json['purchaseId']),
  description = nativeFromJson<String>(json['description']),
  categoryId = nativeFromJson<String>(json['categoryId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePurchaseDetailsVariables otherTyped = other as UpdatePurchaseDetailsVariables;
    return spaceId == otherTyped.spaceId && 
    purchaseId == otherTyped.purchaseId && 
    description == otherTyped.description && 
    categoryId == otherTyped.categoryId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, purchaseId.hashCode, description.hashCode, categoryId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['purchaseId'] = nativeToJson<String>(purchaseId);
    json['description'] = nativeToJson<String>(description);
    json['categoryId'] = nativeToJson<String>(categoryId);
    return json;
  }

  UpdatePurchaseDetailsVariables({
    required this.spaceId,
    required this.purchaseId,
    required this.description,
    required this.categoryId,
  });
}

