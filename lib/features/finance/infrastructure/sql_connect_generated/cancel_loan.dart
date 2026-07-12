part of 'client.dart';

class CancelLoanVariablesBuilder {
  String spaceId;
  String loanId;

  final FirebaseDataConnect _dataConnect;
  CancelLoanVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.loanId,});
  Deserializer<CancelLoanData> dataDeserializer = (dynamic json)  => CancelLoanData.fromJson(jsonDecode(json));
  Serializer<CancelLoanVariables> varsSerializer = (CancelLoanVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CancelLoanData, CancelLoanVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CancelLoanData, CancelLoanVariables> ref() {
    CancelLoanVariables vars= CancelLoanVariables(spaceId: spaceId,loanId: loanId,);
    return _dataConnect.mutation("CancelLoan", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CancelLoanLoan {
  final String id;
  CancelLoanLoan.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelLoanLoan otherTyped = other as CancelLoanLoan;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelLoanLoan({
    required this.id,
  });
}

@immutable
class CancelLoanData {
  final CancelLoanLoan? loan;
  final int installments;
  CancelLoanData.fromJson(dynamic json):
  
  loan = json['loan'] == null ? null : CancelLoanLoan.fromJson(json['loan']),
  installments = nativeFromJson<int>(json['installments']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelLoanData otherTyped = other as CancelLoanData;
    return loan == otherTyped.loan && 
    installments == otherTyped.installments;
    
  }
  @override
  int get hashCode => Object.hashAll([loan.hashCode, installments.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (loan != null) {
      json['loan'] = loan!.toJson();
    }
    json['installments'] = nativeToJson<int>(installments);
    return json;
  }

  CancelLoanData({
    this.loan,
    required this.installments,
  });
}

@immutable
class CancelLoanVariables {
  final String spaceId;
  final String loanId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CancelLoanVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  loanId = nativeFromJson<String>(json['loanId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelLoanVariables otherTyped = other as CancelLoanVariables;
    return spaceId == otherTyped.spaceId && 
    loanId == otherTyped.loanId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, loanId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['loanId'] = nativeToJson<String>(loanId);
    return json;
  }

  CancelLoanVariables({
    required this.spaceId,
    required this.loanId,
  });
}

