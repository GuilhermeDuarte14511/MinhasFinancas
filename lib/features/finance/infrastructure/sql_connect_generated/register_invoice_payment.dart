part of 'client.dart';

class RegisterInvoicePaymentVariablesBuilder {
  String spaceId;
  String invoiceId;
  BigInt amountCents;
  Timestamp paidAt;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;
  InvoiceStatus resultingStatus;

  final FirebaseDataConnect _dataConnect;  RegisterInvoicePaymentVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  RegisterInvoicePaymentVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.invoiceId,required  this.amountCents,required  this.paidAt,required  this.idempotencyKey,required  this.resultingStatus,});
  Deserializer<RegisterInvoicePaymentData> dataDeserializer = (dynamic json)  => RegisterInvoicePaymentData.fromJson(jsonDecode(json));
  Serializer<RegisterInvoicePaymentVariables> varsSerializer = (RegisterInvoicePaymentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RegisterInvoicePaymentData, RegisterInvoicePaymentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RegisterInvoicePaymentData, RegisterInvoicePaymentVariables> ref() {
    RegisterInvoicePaymentVariables vars= RegisterInvoicePaymentVariables(spaceId: spaceId,invoiceId: invoiceId,amountCents: amountCents,paidAt: paidAt,notes: _notes,idempotencyKey: idempotencyKey,resultingStatus: resultingStatus,);
    return _dataConnect.mutation("RegisterInvoicePayment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RegisterInvoicePaymentPayment {
  final String id;
  RegisterInvoicePaymentPayment.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterInvoicePaymentPayment otherTyped = other as RegisterInvoicePaymentPayment;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterInvoicePaymentPayment({
    required this.id,
  });
}

@immutable
class RegisterInvoicePaymentInvoice {
  final String id;
  RegisterInvoicePaymentInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterInvoicePaymentInvoice otherTyped = other as RegisterInvoicePaymentInvoice;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterInvoicePaymentInvoice({
    required this.id,
  });
}

@immutable
class RegisterInvoicePaymentAudit {
  final String id;
  RegisterInvoicePaymentAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterInvoicePaymentAudit otherTyped = other as RegisterInvoicePaymentAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterInvoicePaymentAudit({
    required this.id,
  });
}

@immutable
class RegisterInvoicePaymentData {
  final RegisterInvoicePaymentPayment payment;
  final RegisterInvoicePaymentInvoice? invoice;
  final RegisterInvoicePaymentAudit audit;
  RegisterInvoicePaymentData.fromJson(dynamic json):
  
  payment = RegisterInvoicePaymentPayment.fromJson(json['payment']),
  invoice = json['invoice'] == null ? null : RegisterInvoicePaymentInvoice.fromJson(json['invoice']),
  audit = RegisterInvoicePaymentAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterInvoicePaymentData otherTyped = other as RegisterInvoicePaymentData;
    return payment == otherTyped.payment && 
    invoice == otherTyped.invoice && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([payment.hashCode, invoice.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['payment'] = payment.toJson();
    if (invoice != null) {
      json['invoice'] = invoice!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  RegisterInvoicePaymentData({
    required this.payment,
    this.invoice,
    required this.audit,
  });
}

@immutable
class RegisterInvoicePaymentVariables {
  final String spaceId;
  final String invoiceId;
  final BigInt amountCents;
  final Timestamp paidAt;
  late final Optional<String>notes;
  final String idempotencyKey;
  final InvoiceStatus resultingStatus;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RegisterInvoicePaymentVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  invoiceId = nativeFromJson<String>(json['invoiceId']),
  amountCents = bigIntFromJson(json['amountCents']),
  paidAt = Timestamp.fromJson(json['paidAt']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']),
  resultingStatus = InvoiceStatus.values.byName(json['resultingStatus']) {
  
  
  
  
  
  
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

    final RegisterInvoicePaymentVariables otherTyped = other as RegisterInvoicePaymentVariables;
    return spaceId == otherTyped.spaceId && 
    invoiceId == otherTyped.invoiceId && 
    amountCents == otherTyped.amountCents && 
    paidAt == otherTyped.paidAt && 
    notes == otherTyped.notes && 
    idempotencyKey == otherTyped.idempotencyKey && 
    resultingStatus == otherTyped.resultingStatus;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, invoiceId.hashCode, amountCents.hashCode, paidAt.hashCode, notes.hashCode, idempotencyKey.hashCode, resultingStatus.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['invoiceId'] = nativeToJson<String>(invoiceId);
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

  RegisterInvoicePaymentVariables({
    required this.spaceId,
    required this.invoiceId,
    required this.amountCents,
    required this.paidAt,
    required this.notes,
    required this.idempotencyKey,
    required this.resultingStatus,
  });
}

