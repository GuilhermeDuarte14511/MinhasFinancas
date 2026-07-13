part of 'client.dart';

class RegisterLoanPaymentVariablesBuilder {
  String spaceId;
  String loanId;
  String loanInstallmentId;
  Optional<String> _accountId = Optional.optional(nativeFromJson, nativeToJson);
  BigInt amountCents;
  Timestamp paidAt;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;
  LoanInstallmentStatus resultingStatus;

  final FirebaseDataConnect _dataConnect;  RegisterLoanPaymentVariablesBuilder accountId(String? t) {
   _accountId.value = t;
   return this;
  }
  RegisterLoanPaymentVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  RegisterLoanPaymentVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.loanId,required  this.loanInstallmentId,required  this.amountCents,required  this.paidAt,required  this.idempotencyKey,required  this.resultingStatus,});
  Deserializer<RegisterLoanPaymentData> dataDeserializer = (dynamic json)  => RegisterLoanPaymentData.fromJson(jsonDecode(json));
  Serializer<RegisterLoanPaymentVariables> varsSerializer = (RegisterLoanPaymentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RegisterLoanPaymentData, RegisterLoanPaymentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RegisterLoanPaymentData, RegisterLoanPaymentVariables> ref() {
    RegisterLoanPaymentVariables vars= RegisterLoanPaymentVariables(spaceId: spaceId,loanId: loanId,loanInstallmentId: loanInstallmentId,accountId: _accountId,amountCents: amountCents,paidAt: paidAt,notes: _notes,idempotencyKey: idempotencyKey,resultingStatus: resultingStatus,);
    return _dataConnect.mutation("RegisterLoanPayment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RegisterLoanPaymentPayment {
  final String id;
  RegisterLoanPaymentPayment.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterLoanPaymentPayment otherTyped = other as RegisterLoanPaymentPayment;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterLoanPaymentPayment({
    required this.id,
  });
}

@immutable
class RegisterLoanPaymentInstallment {
  final String id;
  RegisterLoanPaymentInstallment.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterLoanPaymentInstallment otherTyped = other as RegisterLoanPaymentInstallment;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterLoanPaymentInstallment({
    required this.id,
  });
}

@immutable
class RegisterLoanPaymentData {
  final RegisterLoanPaymentPayment payment;
  final RegisterLoanPaymentInstallment? installment;
  RegisterLoanPaymentData.fromJson(dynamic json):
  
  payment = RegisterLoanPaymentPayment.fromJson(json['payment']),
  installment = json['installment'] == null ? null : RegisterLoanPaymentInstallment.fromJson(json['installment']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterLoanPaymentData otherTyped = other as RegisterLoanPaymentData;
    return payment == otherTyped.payment && 
    installment == otherTyped.installment;
    
  }
  @override
  int get hashCode => Object.hashAll([payment.hashCode, installment.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['payment'] = payment.toJson();
    if (installment != null) {
      json['installment'] = installment!.toJson();
    }
    return json;
  }

  RegisterLoanPaymentData({
    required this.payment,
    this.installment,
  });
}

@immutable
class RegisterLoanPaymentVariables {
  final String spaceId;
  final String loanId;
  final String loanInstallmentId;
  late final Optional<String>accountId;
  final BigInt amountCents;
  final Timestamp paidAt;
  late final Optional<String>notes;
  final String idempotencyKey;
  final LoanInstallmentStatus resultingStatus;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RegisterLoanPaymentVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  loanId = nativeFromJson<String>(json['loanId']),
  loanInstallmentId = nativeFromJson<String>(json['loanInstallmentId']),
  amountCents = bigIntFromJson(json['amountCents']),
  paidAt = Timestamp.fromJson(json['paidAt']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']),
  resultingStatus = LoanInstallmentStatus.values.byName(json['resultingStatus']) {
  
  
  
  
  
    accountId = Optional.optional(nativeFromJson, nativeToJson);
    accountId.value = json['accountId'] == null ? null : nativeFromJson<String>(json['accountId']);
  
  
  
  
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

    final RegisterLoanPaymentVariables otherTyped = other as RegisterLoanPaymentVariables;
    return spaceId == otherTyped.spaceId && 
    loanId == otherTyped.loanId && 
    loanInstallmentId == otherTyped.loanInstallmentId && 
    accountId == otherTyped.accountId && 
    amountCents == otherTyped.amountCents && 
    paidAt == otherTyped.paidAt && 
    notes == otherTyped.notes && 
    idempotencyKey == otherTyped.idempotencyKey && 
    resultingStatus == otherTyped.resultingStatus;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, loanId.hashCode, loanInstallmentId.hashCode, accountId.hashCode, amountCents.hashCode, paidAt.hashCode, notes.hashCode, idempotencyKey.hashCode, resultingStatus.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['loanId'] = nativeToJson<String>(loanId);
    json['loanInstallmentId'] = nativeToJson<String>(loanInstallmentId);
    if(accountId.state == OptionalState.set) {
      json['accountId'] = accountId.toJson();
    }
    json['amountCents'] = bigIntToJson(amountCents);
    json['paidAt'] = paidAt.toJson();
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    json['resultingStatus'] = 
    resultingStatus.name
    ;
    return json;
  }

  RegisterLoanPaymentVariables({
    required this.spaceId,
    required this.loanId,
    required this.loanInstallmentId,
    required this.accountId,
    required this.amountCents,
    required this.paidAt,
    required this.notes,
    required this.idempotencyKey,
    required this.resultingStatus,
  });
}

