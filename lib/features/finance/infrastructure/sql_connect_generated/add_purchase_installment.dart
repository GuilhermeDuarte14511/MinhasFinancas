part of 'client.dart';

class AddPurchaseInstallmentVariablesBuilder {
  String spaceId;
  String purchaseId;
  String invoiceId;
  int installmentNumber;
  int installmentCount;
  BigInt amountCents;
  DateTime dueDate;

  final FirebaseDataConnect _dataConnect;
  AddPurchaseInstallmentVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.purchaseId,required  this.invoiceId,required  this.installmentNumber,required  this.installmentCount,required  this.amountCents,required  this.dueDate,});
  Deserializer<AddPurchaseInstallmentData> dataDeserializer = (dynamic json)  => AddPurchaseInstallmentData.fromJson(jsonDecode(json));
  Serializer<AddPurchaseInstallmentVariables> varsSerializer = (AddPurchaseInstallmentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddPurchaseInstallmentData, AddPurchaseInstallmentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddPurchaseInstallmentData, AddPurchaseInstallmentVariables> ref() {
    AddPurchaseInstallmentVariables vars= AddPurchaseInstallmentVariables(spaceId: spaceId,purchaseId: purchaseId,invoiceId: invoiceId,installmentNumber: installmentNumber,installmentCount: installmentCount,amountCents: amountCents,dueDate: dueDate,);
    return _dataConnect.mutation("AddPurchaseInstallment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddPurchaseInstallmentInstallment {
  final String id;
  AddPurchaseInstallmentInstallment.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPurchaseInstallmentInstallment otherTyped = other as AddPurchaseInstallmentInstallment;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddPurchaseInstallmentInstallment({
    required this.id,
  });
}

@immutable
class AddPurchaseInstallmentInvoice {
  final String id;
  AddPurchaseInstallmentInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPurchaseInstallmentInvoice otherTyped = other as AddPurchaseInstallmentInvoice;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddPurchaseInstallmentInvoice({
    required this.id,
  });
}

@immutable
class AddPurchaseInstallmentData {
  final AddPurchaseInstallmentInstallment installment;
  final AddPurchaseInstallmentInvoice? invoice;
  AddPurchaseInstallmentData.fromJson(dynamic json):
  
  installment = AddPurchaseInstallmentInstallment.fromJson(json['installment']),
  invoice = json['invoice'] == null ? null : AddPurchaseInstallmentInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPurchaseInstallmentData otherTyped = other as AddPurchaseInstallmentData;
    return installment == otherTyped.installment && 
    invoice == otherTyped.invoice;
    
  }
  @override
  int get hashCode => Object.hashAll([installment.hashCode, invoice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['installment'] = installment.toJson();
    if (invoice != null) {
      json['invoice'] = invoice!.toJson();
    }
    return json;
  }

  AddPurchaseInstallmentData({
    required this.installment,
    this.invoice,
  });
}

@immutable
class AddPurchaseInstallmentVariables {
  final String spaceId;
  final String purchaseId;
  final String invoiceId;
  final int installmentNumber;
  final int installmentCount;
  final BigInt amountCents;
  final DateTime dueDate;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddPurchaseInstallmentVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  purchaseId = nativeFromJson<String>(json['purchaseId']),
  invoiceId = nativeFromJson<String>(json['invoiceId']),
  installmentNumber = nativeFromJson<int>(json['installmentNumber']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  amountCents = bigIntFromJson(json['amountCents']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPurchaseInstallmentVariables otherTyped = other as AddPurchaseInstallmentVariables;
    return spaceId == otherTyped.spaceId && 
    purchaseId == otherTyped.purchaseId && 
    invoiceId == otherTyped.invoiceId && 
    installmentNumber == otherTyped.installmentNumber && 
    installmentCount == otherTyped.installmentCount && 
    amountCents == otherTyped.amountCents && 
    dueDate == otherTyped.dueDate;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, purchaseId.hashCode, invoiceId.hashCode, installmentNumber.hashCode, installmentCount.hashCode, amountCents.hashCode, dueDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['purchaseId'] = nativeToJson<String>(purchaseId);
    json['invoiceId'] = nativeToJson<String>(invoiceId);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    json['amountCents'] = bigIntToJson(amountCents);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    return json;
  }

  AddPurchaseInstallmentVariables({
    required this.spaceId,
    required this.purchaseId,
    required this.invoiceId,
    required this.installmentNumber,
    required this.installmentCount,
    required this.amountCents,
    required this.dueDate,
  });
}

