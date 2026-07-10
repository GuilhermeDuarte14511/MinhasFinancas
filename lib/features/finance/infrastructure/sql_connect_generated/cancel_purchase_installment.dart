part of 'client.dart';

class CancelPurchaseInstallmentVariablesBuilder {
  String spaceId;
  String installmentId;
  String invoiceId;
  BigInt amountCents;

  final FirebaseDataConnect _dataConnect;
  CancelPurchaseInstallmentVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.installmentId,required  this.invoiceId,required  this.amountCents,});
  Deserializer<CancelPurchaseInstallmentData> dataDeserializer = (dynamic json)  => CancelPurchaseInstallmentData.fromJson(jsonDecode(json));
  Serializer<CancelPurchaseInstallmentVariables> varsSerializer = (CancelPurchaseInstallmentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CancelPurchaseInstallmentData, CancelPurchaseInstallmentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CancelPurchaseInstallmentData, CancelPurchaseInstallmentVariables> ref() {
    CancelPurchaseInstallmentVariables vars= CancelPurchaseInstallmentVariables(spaceId: spaceId,installmentId: installmentId,invoiceId: invoiceId,amountCents: amountCents,);
    return _dataConnect.mutation("CancelPurchaseInstallment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CancelPurchaseInstallmentInstallment {
  final String id;
  CancelPurchaseInstallmentInstallment.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseInstallmentInstallment otherTyped = other as CancelPurchaseInstallmentInstallment;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelPurchaseInstallmentInstallment({
    required this.id,
  });
}

@immutable
class CancelPurchaseInstallmentInvoice {
  final String id;
  CancelPurchaseInstallmentInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseInstallmentInvoice otherTyped = other as CancelPurchaseInstallmentInvoice;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelPurchaseInstallmentInvoice({
    required this.id,
  });
}

@immutable
class CancelPurchaseInstallmentData {
  final CancelPurchaseInstallmentInstallment? installment;
  final CancelPurchaseInstallmentInvoice? invoice;
  CancelPurchaseInstallmentData.fromJson(dynamic json):
  
  installment = json['installment'] == null ? null : CancelPurchaseInstallmentInstallment.fromJson(json['installment']),
  invoice = json['invoice'] == null ? null : CancelPurchaseInstallmentInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseInstallmentData otherTyped = other as CancelPurchaseInstallmentData;
    return installment == otherTyped.installment && 
    invoice == otherTyped.invoice;
    
  }
  @override
  int get hashCode => Object.hashAll([installment.hashCode, invoice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (installment != null) {
      json['installment'] = installment!.toJson();
    }
    if (invoice != null) {
      json['invoice'] = invoice!.toJson();
    }
    return json;
  }

  CancelPurchaseInstallmentData({
    this.installment,
    this.invoice,
  });
}

@immutable
class CancelPurchaseInstallmentVariables {
  final String spaceId;
  final String installmentId;
  final String invoiceId;
  final BigInt amountCents;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CancelPurchaseInstallmentVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  installmentId = nativeFromJson<String>(json['installmentId']),
  invoiceId = nativeFromJson<String>(json['invoiceId']),
  amountCents = bigIntFromJson(json['amountCents']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseInstallmentVariables otherTyped = other as CancelPurchaseInstallmentVariables;
    return spaceId == otherTyped.spaceId && 
    installmentId == otherTyped.installmentId && 
    invoiceId == otherTyped.invoiceId && 
    amountCents == otherTyped.amountCents;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, installmentId.hashCode, invoiceId.hashCode, amountCents.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['installmentId'] = nativeToJson<String>(installmentId);
    json['invoiceId'] = nativeToJson<String>(invoiceId);
    json['amountCents'] = bigIntToJson(amountCents);
    return json;
  }

  CancelPurchaseInstallmentVariables({
    required this.spaceId,
    required this.installmentId,
    required this.invoiceId,
    required this.amountCents,
  });
}

