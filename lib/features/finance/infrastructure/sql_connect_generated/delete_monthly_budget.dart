part of 'client.dart';

class DeleteMonthlyBudgetVariablesBuilder {
  String spaceId;
  String budgetId;

  final FirebaseDataConnect _dataConnect;
  DeleteMonthlyBudgetVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.budgetId,});
  Deserializer<DeleteMonthlyBudgetData> dataDeserializer = (dynamic json)  => DeleteMonthlyBudgetData.fromJson(jsonDecode(json));
  Serializer<DeleteMonthlyBudgetVariables> varsSerializer = (DeleteMonthlyBudgetVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteMonthlyBudgetData, DeleteMonthlyBudgetVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteMonthlyBudgetData, DeleteMonthlyBudgetVariables> ref() {
    DeleteMonthlyBudgetVariables vars= DeleteMonthlyBudgetVariables(spaceId: spaceId,budgetId: budgetId,);
    return _dataConnect.mutation("DeleteMonthlyBudget", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteMonthlyBudgetBudget {
  final String id;
  DeleteMonthlyBudgetBudget.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMonthlyBudgetBudget otherTyped = other as DeleteMonthlyBudgetBudget;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteMonthlyBudgetBudget({
    required this.id,
  });
}

@immutable
class DeleteMonthlyBudgetData {
  final DeleteMonthlyBudgetBudget? budget;
  DeleteMonthlyBudgetData.fromJson(dynamic json):
  
  budget = json['budget'] == null ? null : DeleteMonthlyBudgetBudget.fromJson(json['budget']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMonthlyBudgetData otherTyped = other as DeleteMonthlyBudgetData;
    return budget == otherTyped.budget;
    
  }
  @override
  int get hashCode => budget.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (budget != null) {
      json['budget'] = budget!.toJson();
    }
    return json;
  }

  DeleteMonthlyBudgetData({
    this.budget,
  });
}

@immutable
class DeleteMonthlyBudgetVariables {
  final String spaceId;
  final String budgetId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteMonthlyBudgetVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  budgetId = nativeFromJson<String>(json['budgetId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMonthlyBudgetVariables otherTyped = other as DeleteMonthlyBudgetVariables;
    return spaceId == otherTyped.spaceId && 
    budgetId == otherTyped.budgetId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, budgetId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['budgetId'] = nativeToJson<String>(budgetId);
    return json;
  }

  DeleteMonthlyBudgetVariables({
    required this.spaceId,
    required this.budgetId,
  });
}

