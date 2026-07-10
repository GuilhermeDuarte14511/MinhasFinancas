part of 'client.dart';

class CreateFinancialSpaceVariablesBuilder {
  String name;
  String colorHex;

  final FirebaseDataConnect _dataConnect;
  CreateFinancialSpaceVariablesBuilder(this._dataConnect, {required  this.name,required  this.colorHex,});
  Deserializer<CreateFinancialSpaceData> dataDeserializer = (dynamic json)  => CreateFinancialSpaceData.fromJson(jsonDecode(json));
  Serializer<CreateFinancialSpaceVariables> varsSerializer = (CreateFinancialSpaceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateFinancialSpaceData, CreateFinancialSpaceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateFinancialSpaceData, CreateFinancialSpaceVariables> ref() {
    CreateFinancialSpaceVariables vars= CreateFinancialSpaceVariables(name: name,colorHex: colorHex,);
    return _dataConnect.mutation("CreateFinancialSpace", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateFinancialSpaceSpace {
  final String id;
  CreateFinancialSpaceSpace.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceSpace otherTyped = other as CreateFinancialSpaceSpace;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceSpace({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceOwner {
  final String id;
  CreateFinancialSpaceOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceOwner otherTyped = other as CreateFinancialSpaceOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceOwner({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceMarket {
  final String id;
  CreateFinancialSpaceMarket.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceMarket otherTyped = other as CreateFinancialSpaceMarket;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceMarket({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceHome {
  final String id;
  CreateFinancialSpaceHome.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceHome otherTyped = other as CreateFinancialSpaceHome;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceHome({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceFood {
  final String id;
  CreateFinancialSpaceFood.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceFood otherTyped = other as CreateFinancialSpaceFood;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceFood({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceTransport {
  final String id;
  CreateFinancialSpaceTransport.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceTransport otherTyped = other as CreateFinancialSpaceTransport;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceTransport({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceHealth {
  final String id;
  CreateFinancialSpaceHealth.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceHealth otherTyped = other as CreateFinancialSpaceHealth;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceHealth({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceLeisure {
  final String id;
  CreateFinancialSpaceLeisure.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceLeisure otherTyped = other as CreateFinancialSpaceLeisure;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceLeisure({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceSubscriptions {
  final String id;
  CreateFinancialSpaceSubscriptions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceSubscriptions otherTyped = other as CreateFinancialSpaceSubscriptions;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceSubscriptions({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceEducation {
  final String id;
  CreateFinancialSpaceEducation.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceEducation otherTyped = other as CreateFinancialSpaceEducation;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceEducation({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceOther {
  final String id;
  CreateFinancialSpaceOther.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceOther otherTyped = other as CreateFinancialSpaceOther;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceOther({
    required this.id,
  });
}

@immutable
class CreateFinancialSpacePreference {
  final String id;
  CreateFinancialSpacePreference.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpacePreference otherTyped = other as CreateFinancialSpacePreference;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpacePreference({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceClosingRule {
  final String id;
  CreateFinancialSpaceClosingRule.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceClosingRule otherTyped = other as CreateFinancialSpaceClosingRule;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceClosingRule({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceDueRule {
  final String id;
  CreateFinancialSpaceDueRule.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceDueRule otherTyped = other as CreateFinancialSpaceDueRule;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceDueRule({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceLoanRule {
  final String id;
  CreateFinancialSpaceLoanRule.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceLoanRule otherTyped = other as CreateFinancialSpaceLoanRule;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceLoanRule({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceAudit {
  final String id;
  CreateFinancialSpaceAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceAudit otherTyped = other as CreateFinancialSpaceAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFinancialSpaceAudit({
    required this.id,
  });
}

@immutable
class CreateFinancialSpaceData {
  final CreateFinancialSpaceSpace space;
  final CreateFinancialSpaceOwner owner;
  final CreateFinancialSpaceMarket market;
  final CreateFinancialSpaceHome home;
  final CreateFinancialSpaceFood food;
  final CreateFinancialSpaceTransport transport;
  final CreateFinancialSpaceHealth health;
  final CreateFinancialSpaceLeisure leisure;
  final CreateFinancialSpaceSubscriptions subscriptions;
  final CreateFinancialSpaceEducation education;
  final CreateFinancialSpaceOther other;
  final CreateFinancialSpacePreference preference;
  final CreateFinancialSpaceClosingRule closingRule;
  final CreateFinancialSpaceDueRule dueRule;
  final CreateFinancialSpaceLoanRule loanRule;
  final CreateFinancialSpaceAudit audit;
  CreateFinancialSpaceData.fromJson(dynamic json):
  
  space = CreateFinancialSpaceSpace.fromJson(json['space']),
  owner = CreateFinancialSpaceOwner.fromJson(json['owner']),
  market = CreateFinancialSpaceMarket.fromJson(json['market']),
  home = CreateFinancialSpaceHome.fromJson(json['home']),
  food = CreateFinancialSpaceFood.fromJson(json['food']),
  transport = CreateFinancialSpaceTransport.fromJson(json['transport']),
  health = CreateFinancialSpaceHealth.fromJson(json['health']),
  leisure = CreateFinancialSpaceLeisure.fromJson(json['leisure']),
  subscriptions = CreateFinancialSpaceSubscriptions.fromJson(json['subscriptions']),
  education = CreateFinancialSpaceEducation.fromJson(json['education']),
  other = CreateFinancialSpaceOther.fromJson(json['other']),
  preference = CreateFinancialSpacePreference.fromJson(json['preference']),
  closingRule = CreateFinancialSpaceClosingRule.fromJson(json['closingRule']),
  dueRule = CreateFinancialSpaceDueRule.fromJson(json['dueRule']),
  loanRule = CreateFinancialSpaceLoanRule.fromJson(json['loanRule']),
  audit = CreateFinancialSpaceAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceData otherTyped = other as CreateFinancialSpaceData;
    return space == otherTyped.space && 
    owner == otherTyped.owner && 
    market == otherTyped.market && 
    home == otherTyped.home && 
    food == otherTyped.food && 
    transport == otherTyped.transport && 
    health == otherTyped.health && 
    leisure == otherTyped.leisure && 
    subscriptions == otherTyped.subscriptions && 
    education == otherTyped.education && 
    other == otherTyped.other && 
    preference == otherTyped.preference && 
    closingRule == otherTyped.closingRule && 
    dueRule == otherTyped.dueRule && 
    loanRule == otherTyped.loanRule && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([space.hashCode, owner.hashCode, market.hashCode, home.hashCode, food.hashCode, transport.hashCode, health.hashCode, leisure.hashCode, subscriptions.hashCode, education.hashCode, other.hashCode, preference.hashCode, closingRule.hashCode, dueRule.hashCode, loanRule.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['space'] = space.toJson();
    json['owner'] = owner.toJson();
    json['market'] = market.toJson();
    json['home'] = home.toJson();
    json['food'] = food.toJson();
    json['transport'] = transport.toJson();
    json['health'] = health.toJson();
    json['leisure'] = leisure.toJson();
    json['subscriptions'] = subscriptions.toJson();
    json['education'] = education.toJson();
    json['other'] = other.toJson();
    json['preference'] = preference.toJson();
    json['closingRule'] = closingRule.toJson();
    json['dueRule'] = dueRule.toJson();
    json['loanRule'] = loanRule.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateFinancialSpaceData({
    required this.space,
    required this.owner,
    required this.market,
    required this.home,
    required this.food,
    required this.transport,
    required this.health,
    required this.leisure,
    required this.subscriptions,
    required this.education,
    required this.other,
    required this.preference,
    required this.closingRule,
    required this.dueRule,
    required this.loanRule,
    required this.audit,
  });
}

@immutable
class CreateFinancialSpaceVariables {
  final String name;
  final String colorHex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateFinancialSpaceVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFinancialSpaceVariables otherTyped = other as CreateFinancialSpaceVariables;
    return name == otherTyped.name && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  CreateFinancialSpaceVariables({
    required this.name,
    required this.colorHex,
  });
}

