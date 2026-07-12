part of 'client.dart';

class UpdateNotificationRulesVariablesBuilder {
  String spaceId;
  bool invoiceClosing;
  bool invoiceDue;
  bool loanDue;
  int daysBefore;

  final FirebaseDataConnect _dataConnect;
  UpdateNotificationRulesVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.invoiceClosing,required  this.invoiceDue,required  this.loanDue,required  this.daysBefore,});
  Deserializer<UpdateNotificationRulesData> dataDeserializer = (dynamic json)  => UpdateNotificationRulesData.fromJson(jsonDecode(json));
  Serializer<UpdateNotificationRulesVariables> varsSerializer = (UpdateNotificationRulesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateNotificationRulesData, UpdateNotificationRulesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateNotificationRulesData, UpdateNotificationRulesVariables> ref() {
    UpdateNotificationRulesVariables vars= UpdateNotificationRulesVariables(spaceId: spaceId,invoiceClosing: invoiceClosing,invoiceDue: invoiceDue,loanDue: loanDue,daysBefore: daysBefore,);
    return _dataConnect.mutation("UpdateNotificationRules", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateNotificationRulesClosing {
  final String id;
  UpdateNotificationRulesClosing.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationRulesClosing otherTyped = other as UpdateNotificationRulesClosing;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateNotificationRulesClosing({
    required this.id,
  });
}

@immutable
class UpdateNotificationRulesDue {
  final String id;
  UpdateNotificationRulesDue.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationRulesDue otherTyped = other as UpdateNotificationRulesDue;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateNotificationRulesDue({
    required this.id,
  });
}

@immutable
class UpdateNotificationRulesLoan {
  final String id;
  UpdateNotificationRulesLoan.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationRulesLoan otherTyped = other as UpdateNotificationRulesLoan;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateNotificationRulesLoan({
    required this.id,
  });
}

@immutable
class UpdateNotificationRulesData {
  final UpdateNotificationRulesClosing? closing;
  final UpdateNotificationRulesDue? due;
  final UpdateNotificationRulesLoan? loan;
  UpdateNotificationRulesData.fromJson(dynamic json):
  
  closing = json['closing'] == null ? null : UpdateNotificationRulesClosing.fromJson(json['closing']),
  due = json['due'] == null ? null : UpdateNotificationRulesDue.fromJson(json['due']),
  loan = json['loan'] == null ? null : UpdateNotificationRulesLoan.fromJson(json['loan']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationRulesData otherTyped = other as UpdateNotificationRulesData;
    return closing == otherTyped.closing && 
    due == otherTyped.due && 
    loan == otherTyped.loan;
    
  }
  @override
  int get hashCode => Object.hashAll([closing.hashCode, due.hashCode, loan.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (closing != null) {
      json['closing'] = closing!.toJson();
    }
    if (due != null) {
      json['due'] = due!.toJson();
    }
    if (loan != null) {
      json['loan'] = loan!.toJson();
    }
    return json;
  }

  UpdateNotificationRulesData({
    this.closing,
    this.due,
    this.loan,
  });
}

@immutable
class UpdateNotificationRulesVariables {
  final String spaceId;
  final bool invoiceClosing;
  final bool invoiceDue;
  final bool loanDue;
  final int daysBefore;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateNotificationRulesVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  invoiceClosing = nativeFromJson<bool>(json['invoiceClosing']),
  invoiceDue = nativeFromJson<bool>(json['invoiceDue']),
  loanDue = nativeFromJson<bool>(json['loanDue']),
  daysBefore = nativeFromJson<int>(json['daysBefore']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateNotificationRulesVariables otherTyped = other as UpdateNotificationRulesVariables;
    return spaceId == otherTyped.spaceId && 
    invoiceClosing == otherTyped.invoiceClosing && 
    invoiceDue == otherTyped.invoiceDue && 
    loanDue == otherTyped.loanDue && 
    daysBefore == otherTyped.daysBefore;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, invoiceClosing.hashCode, invoiceDue.hashCode, loanDue.hashCode, daysBefore.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['invoiceClosing'] = nativeToJson<bool>(invoiceClosing);
    json['invoiceDue'] = nativeToJson<bool>(invoiceDue);
    json['loanDue'] = nativeToJson<bool>(loanDue);
    json['daysBefore'] = nativeToJson<int>(daysBefore);
    return json;
  }

  UpdateNotificationRulesVariables({
    required this.spaceId,
    required this.invoiceClosing,
    required this.invoiceDue,
    required this.loanDue,
    required this.daysBefore,
  });
}

