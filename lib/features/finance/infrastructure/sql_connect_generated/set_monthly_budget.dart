part of 'client.dart';

class SetMonthlyBudgetVariablesBuilder {
  String id;
  String spaceId;
  String categoryId;
  DateTime referenceMonth;
  BigInt limitAmountCents;

  final FirebaseDataConnect _dataConnect;
  SetMonthlyBudgetVariablesBuilder(this._dataConnect, {required  this.id,required  this.spaceId,required  this.categoryId,required  this.referenceMonth,required  this.limitAmountCents,});
  Deserializer<SetMonthlyBudgetData> dataDeserializer = (dynamic json)  => SetMonthlyBudgetData.fromJson(jsonDecode(json));
  Serializer<SetMonthlyBudgetVariables> varsSerializer = (SetMonthlyBudgetVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SetMonthlyBudgetData, SetMonthlyBudgetVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SetMonthlyBudgetData, SetMonthlyBudgetVariables> ref() {
    SetMonthlyBudgetVariables vars= SetMonthlyBudgetVariables(id: id,spaceId: spaceId,categoryId: categoryId,referenceMonth: referenceMonth,limitAmountCents: limitAmountCents,);
    return _dataConnect.mutation("SetMonthlyBudget", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SetMonthlyBudgetBudget {
  final String id;
  SetMonthlyBudgetBudget.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMonthlyBudgetBudget otherTyped = other as SetMonthlyBudgetBudget;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SetMonthlyBudgetBudget({
    required this.id,
  });
}

@immutable
class SetMonthlyBudgetData {
  final SetMonthlyBudgetBudget budget;
  SetMonthlyBudgetData.fromJson(dynamic json):
  
  budget = SetMonthlyBudgetBudget.fromJson(json['budget']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMonthlyBudgetData otherTyped = other as SetMonthlyBudgetData;
    return budget == otherTyped.budget;
    
  }
  @override
  int get hashCode => budget.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['budget'] = budget.toJson();
    return json;
  }

  SetMonthlyBudgetData({
    required this.budget,
  });
}

@immutable
class SetMonthlyBudgetVariables {
  final String id;
  final String spaceId;
  final String categoryId;
  final DateTime referenceMonth;
  final BigInt limitAmountCents;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SetMonthlyBudgetVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  spaceId = nativeFromJson<String>(json['spaceId']),
  categoryId = nativeFromJson<String>(json['categoryId']),
  referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
  limitAmountCents = bigIntFromJson(json['limitAmountCents']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMonthlyBudgetVariables otherTyped = other as SetMonthlyBudgetVariables;
    return id == otherTyped.id && 
    spaceId == otherTyped.spaceId && 
    categoryId == otherTyped.categoryId && 
    referenceMonth == otherTyped.referenceMonth && 
    limitAmountCents == otherTyped.limitAmountCents;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, spaceId.hashCode, categoryId.hashCode, referenceMonth.hashCode, limitAmountCents.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    json['limitAmountCents'] = bigIntToJson(limitAmountCents);
    return json;
  }

  SetMonthlyBudgetVariables({
    required this.id,
    required this.spaceId,
    required this.categoryId,
    required this.referenceMonth,
    required this.limitAmountCents,
  });
}

