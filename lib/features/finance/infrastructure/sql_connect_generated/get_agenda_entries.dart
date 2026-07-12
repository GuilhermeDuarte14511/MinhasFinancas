part of 'client.dart';

class GetAgendaEntriesVariablesBuilder {
  String spaceId;
  Timestamp rangeStart;
  Timestamp rangeEnd;
  DateTime rangeStartDate;
  DateTime rangeEndDate;

  final FirebaseDataConnect _dataConnect;
  GetAgendaEntriesVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.rangeStart,required  this.rangeEnd,required  this.rangeStartDate,required  this.rangeEndDate,});
  Deserializer<GetAgendaEntriesData> dataDeserializer = (dynamic json)  => GetAgendaEntriesData.fromJson(jsonDecode(json));
  Serializer<GetAgendaEntriesVariables> varsSerializer = (GetAgendaEntriesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAgendaEntriesData, GetAgendaEntriesVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAgendaEntriesData, GetAgendaEntriesVariables> ref() {
    GetAgendaEntriesVariables vars= GetAgendaEntriesVariables(spaceId: spaceId,rangeStart: rangeStart,rangeEnd: rangeEnd,rangeStartDate: rangeStartDate,rangeEndDate: rangeEndDate,);
    return _dataConnect.query("GetAgendaEntries", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAgendaEntriesCashFlowEntries {
  final String id;
  final EnumValue<CashFlowDirection> direction;
  final EnumValue<CashFlowKind> kind;
  final EnumValue<CashFlowPaymentMethod> paymentMethod;
  final String description;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  final String? notes;
  final EnumValue<CashFlowStatus> status;
  final int? occurrenceIndex;
  final bool isRecurrenceException;
  final Timestamp? receivedAt;
  final Timestamp? paidAt;
  final GetAgendaEntriesCashFlowEntriesCategory? category;
  final GetAgendaEntriesCashFlowEntriesRecurrenceSeries? recurrenceSeries;
  GetAgendaEntriesCashFlowEntries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  direction = cashFlowDirectionDeserializer(json['direction']),
  kind = cashFlowKindDeserializer(json['kind']),
  paymentMethod = cashFlowPaymentMethodDeserializer(json['paymentMethod']),
  description = nativeFromJson<String>(json['description']),
  amountCents = bigIntFromJson(json['amountCents']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  status = cashFlowStatusDeserializer(json['status']),
  occurrenceIndex = json['occurrenceIndex'] == null ? null : nativeFromJson<int>(json['occurrenceIndex']),
  isRecurrenceException = nativeFromJson<bool>(json['isRecurrenceException']),
  receivedAt = json['receivedAt'] == null ? null : Timestamp.fromJson(json['receivedAt']),
  paidAt = json['paidAt'] == null ? null : Timestamp.fromJson(json['paidAt']),
  category = json['category'] == null ? null : GetAgendaEntriesCashFlowEntriesCategory.fromJson(json['category']),
  recurrenceSeries = json['recurrenceSeries'] == null ? null : GetAgendaEntriesCashFlowEntriesRecurrenceSeries.fromJson(json['recurrenceSeries']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesCashFlowEntries otherTyped = other as GetAgendaEntriesCashFlowEntries;
    return id == otherTyped.id && 
    direction == otherTyped.direction && 
    kind == otherTyped.kind && 
    paymentMethod == otherTyped.paymentMethod && 
    description == otherTyped.description && 
    amountCents == otherTyped.amountCents && 
    occurredAt == otherTyped.occurredAt && 
    competenceMonth == otherTyped.competenceMonth && 
    notes == otherTyped.notes && 
    status == otherTyped.status && 
    occurrenceIndex == otherTyped.occurrenceIndex && 
    isRecurrenceException == otherTyped.isRecurrenceException && 
    receivedAt == otherTyped.receivedAt && 
    paidAt == otherTyped.paidAt && 
    category == otherTyped.category && 
    recurrenceSeries == otherTyped.recurrenceSeries;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, direction.hashCode, kind.hashCode, paymentMethod.hashCode, description.hashCode, amountCents.hashCode, occurredAt.hashCode, competenceMonth.hashCode, notes.hashCode, status.hashCode, occurrenceIndex.hashCode, isRecurrenceException.hashCode, receivedAt.hashCode, paidAt.hashCode, category.hashCode, recurrenceSeries.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    json['kind'] = 
    cashFlowKindSerializer(kind)
    ;
    json['paymentMethod'] = 
    cashFlowPaymentMethodSerializer(paymentMethod)
    ;
    json['description'] = nativeToJson<String>(description);
    json['amountCents'] = bigIntToJson(amountCents);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['status'] = 
    cashFlowStatusSerializer(status)
    ;
    if (occurrenceIndex != null) {
      json['occurrenceIndex'] = nativeToJson<int?>(occurrenceIndex);
    }
    json['isRecurrenceException'] = nativeToJson<bool>(isRecurrenceException);
    if (receivedAt != null) {
      json['receivedAt'] = receivedAt!.toJson();
    }
    if (paidAt != null) {
      json['paidAt'] = paidAt!.toJson();
    }
    if (category != null) {
      json['category'] = category!.toJson();
    }
    if (recurrenceSeries != null) {
      json['recurrenceSeries'] = recurrenceSeries!.toJson();
    }
    return json;
  }

  GetAgendaEntriesCashFlowEntries({
    required this.id,
    required this.direction,
    required this.kind,
    required this.paymentMethod,
    required this.description,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    this.notes,
    required this.status,
    this.occurrenceIndex,
    required this.isRecurrenceException,
    this.receivedAt,
    this.paidAt,
    this.category,
    this.recurrenceSeries,
  });
}

@immutable
class GetAgendaEntriesCashFlowEntriesCategory {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  GetAgendaEntriesCashFlowEntriesCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  icon = nativeFromJson<String>(json['icon']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesCashFlowEntriesCategory otherTyped = other as GetAgendaEntriesCashFlowEntriesCategory;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    icon == otherTyped.icon && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, icon.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['icon'] = nativeToJson<String>(icon);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  GetAgendaEntriesCashFlowEntriesCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
  });
}

@immutable
class GetAgendaEntriesCashFlowEntriesRecurrenceSeries {
  final String id;
  final EnumValue<CashFlowRecurrenceFrequency> frequency;
  final int? preferredDay;
  final EnumValue<CashFlowRecurrenceSeriesStatus> status;
  GetAgendaEntriesCashFlowEntriesRecurrenceSeries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  frequency = cashFlowRecurrenceFrequencyDeserializer(json['frequency']),
  preferredDay = json['preferredDay'] == null ? null : nativeFromJson<int>(json['preferredDay']),
  status = cashFlowRecurrenceSeriesStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesCashFlowEntriesRecurrenceSeries otherTyped = other as GetAgendaEntriesCashFlowEntriesRecurrenceSeries;
    return id == otherTyped.id && 
    frequency == otherTyped.frequency && 
    preferredDay == otherTyped.preferredDay && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, frequency.hashCode, preferredDay.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['frequency'] = 
    cashFlowRecurrenceFrequencySerializer(frequency)
    ;
    if (preferredDay != null) {
      json['preferredDay'] = nativeToJson<int?>(preferredDay);
    }
    json['status'] = 
    cashFlowRecurrenceSeriesStatusSerializer(status)
    ;
    return json;
  }

  GetAgendaEntriesCashFlowEntriesRecurrenceSeries({
    required this.id,
    required this.frequency,
    this.preferredDay,
    required this.status,
  });
}

@immutable
class GetAgendaEntriesCreditCardInvoices {
  final String id;
  final DateTime referenceMonth;
  final DateTime closingDate;
  final DateTime dueDate;
  final EnumValue<InvoiceStatus> status;
  final BigInt totalAmountCents;
  final BigInt paidAmountCents;
  final GetAgendaEntriesCreditCardInvoicesCreditCard creditCard;
  GetAgendaEntriesCreditCardInvoices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
  closingDate = nativeFromJson<DateTime>(json['closingDate']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  status = invoiceStatusDeserializer(json['status']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  paidAmountCents = bigIntFromJson(json['paidAmountCents']),
  creditCard = GetAgendaEntriesCreditCardInvoicesCreditCard.fromJson(json['creditCard']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesCreditCardInvoices otherTyped = other as GetAgendaEntriesCreditCardInvoices;
    return id == otherTyped.id && 
    referenceMonth == otherTyped.referenceMonth && 
    closingDate == otherTyped.closingDate && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    totalAmountCents == otherTyped.totalAmountCents && 
    paidAmountCents == otherTyped.paidAmountCents && 
    creditCard == otherTyped.creditCard;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, referenceMonth.hashCode, closingDate.hashCode, dueDate.hashCode, status.hashCode, totalAmountCents.hashCode, paidAmountCents.hashCode, creditCard.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    json['closingDate'] = nativeToJson<DateTime>(closingDate);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['status'] = 
    invoiceStatusSerializer(status)
    ;
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['paidAmountCents'] = bigIntToJson(paidAmountCents);
    json['creditCard'] = creditCard.toJson();
    return json;
  }

  GetAgendaEntriesCreditCardInvoices({
    required this.id,
    required this.referenceMonth,
    required this.closingDate,
    required this.dueDate,
    required this.status,
    required this.totalAmountCents,
    required this.paidAmountCents,
    required this.creditCard,
  });
}

@immutable
class GetAgendaEntriesCreditCardInvoicesCreditCard {
  final String id;
  final String nickname;
  final String lastFourDigits;
  final String colorHex;
  GetAgendaEntriesCreditCardInvoicesCreditCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nickname = nativeFromJson<String>(json['nickname']),
  lastFourDigits = nativeFromJson<String>(json['lastFourDigits']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesCreditCardInvoicesCreditCard otherTyped = other as GetAgendaEntriesCreditCardInvoicesCreditCard;
    return id == otherTyped.id && 
    nickname == otherTyped.nickname && 
    lastFourDigits == otherTyped.lastFourDigits && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nickname.hashCode, lastFourDigits.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nickname'] = nativeToJson<String>(nickname);
    json['lastFourDigits'] = nativeToJson<String>(lastFourDigits);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  GetAgendaEntriesCreditCardInvoicesCreditCard({
    required this.id,
    required this.nickname,
    required this.lastFourDigits,
    required this.colorHex,
  });
}

@immutable
class GetAgendaEntriesPurchaseInstallments {
  final String id;
  final int installmentNumber;
  final int installmentCount;
  final BigInt amountCents;
  final DateTime dueDate;
  final EnumValue<InstallmentStatus> status;
  final GetAgendaEntriesPurchaseInstallmentsPurchase purchase;
  final GetAgendaEntriesPurchaseInstallmentsInvoice invoice;
  GetAgendaEntriesPurchaseInstallments.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  installmentNumber = nativeFromJson<int>(json['installmentNumber']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  amountCents = bigIntFromJson(json['amountCents']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  status = installmentStatusDeserializer(json['status']),
  purchase = GetAgendaEntriesPurchaseInstallmentsPurchase.fromJson(json['purchase']),
  invoice = GetAgendaEntriesPurchaseInstallmentsInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesPurchaseInstallments otherTyped = other as GetAgendaEntriesPurchaseInstallments;
    return id == otherTyped.id && 
    installmentNumber == otherTyped.installmentNumber && 
    installmentCount == otherTyped.installmentCount && 
    amountCents == otherTyped.amountCents && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    purchase == otherTyped.purchase && 
    invoice == otherTyped.invoice;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, installmentNumber.hashCode, installmentCount.hashCode, amountCents.hashCode, dueDate.hashCode, status.hashCode, purchase.hashCode, invoice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    json['amountCents'] = bigIntToJson(amountCents);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['status'] = 
    installmentStatusSerializer(status)
    ;
    json['purchase'] = purchase.toJson();
    json['invoice'] = invoice.toJson();
    return json;
  }

  GetAgendaEntriesPurchaseInstallments({
    required this.id,
    required this.installmentNumber,
    required this.installmentCount,
    required this.amountCents,
    required this.dueDate,
    required this.status,
    required this.purchase,
    required this.invoice,
  });
}

@immutable
class GetAgendaEntriesPurchaseInstallmentsPurchase {
  final String id;
  final String description;
  final GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard creditCard;
  GetAgendaEntriesPurchaseInstallmentsPurchase.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  description = nativeFromJson<String>(json['description']),
  creditCard = GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard.fromJson(json['creditCard']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesPurchaseInstallmentsPurchase otherTyped = other as GetAgendaEntriesPurchaseInstallmentsPurchase;
    return id == otherTyped.id && 
    description == otherTyped.description && 
    creditCard == otherTyped.creditCard;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, description.hashCode, creditCard.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['description'] = nativeToJson<String>(description);
    json['creditCard'] = creditCard.toJson();
    return json;
  }

  GetAgendaEntriesPurchaseInstallmentsPurchase({
    required this.id,
    required this.description,
    required this.creditCard,
  });
}

@immutable
class GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard {
  final String id;
  final String nickname;
  final String lastFourDigits;
  final String colorHex;
  GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nickname = nativeFromJson<String>(json['nickname']),
  lastFourDigits = nativeFromJson<String>(json['lastFourDigits']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard otherTyped = other as GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard;
    return id == otherTyped.id && 
    nickname == otherTyped.nickname && 
    lastFourDigits == otherTyped.lastFourDigits && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nickname.hashCode, lastFourDigits.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nickname'] = nativeToJson<String>(nickname);
    json['lastFourDigits'] = nativeToJson<String>(lastFourDigits);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  GetAgendaEntriesPurchaseInstallmentsPurchaseCreditCard({
    required this.id,
    required this.nickname,
    required this.lastFourDigits,
    required this.colorHex,
  });
}

@immutable
class GetAgendaEntriesPurchaseInstallmentsInvoice {
  final String id;
  final DateTime referenceMonth;
  final EnumValue<InvoiceStatus> status;
  GetAgendaEntriesPurchaseInstallmentsInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
  status = invoiceStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesPurchaseInstallmentsInvoice otherTyped = other as GetAgendaEntriesPurchaseInstallmentsInvoice;
    return id == otherTyped.id && 
    referenceMonth == otherTyped.referenceMonth && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, referenceMonth.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    json['status'] = 
    invoiceStatusSerializer(status)
    ;
    return json;
  }

  GetAgendaEntriesPurchaseInstallmentsInvoice({
    required this.id,
    required this.referenceMonth,
    required this.status,
  });
}

@immutable
class GetAgendaEntriesLoanInstallments {
  final String id;
  final int installmentNumber;
  final DateTime dueDate;
  final BigInt totalAmountCents;
  final BigInt paidAmountCents;
  final EnumValue<LoanInstallmentStatus> status;
  final GetAgendaEntriesLoanInstallmentsLoan loan;
  GetAgendaEntriesLoanInstallments.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  installmentNumber = nativeFromJson<int>(json['installmentNumber']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  paidAmountCents = bigIntFromJson(json['paidAmountCents']),
  status = loanInstallmentStatusDeserializer(json['status']),
  loan = GetAgendaEntriesLoanInstallmentsLoan.fromJson(json['loan']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesLoanInstallments otherTyped = other as GetAgendaEntriesLoanInstallments;
    return id == otherTyped.id && 
    installmentNumber == otherTyped.installmentNumber && 
    dueDate == otherTyped.dueDate && 
    totalAmountCents == otherTyped.totalAmountCents && 
    paidAmountCents == otherTyped.paidAmountCents && 
    status == otherTyped.status && 
    loan == otherTyped.loan;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, installmentNumber.hashCode, dueDate.hashCode, totalAmountCents.hashCode, paidAmountCents.hashCode, status.hashCode, loan.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['paidAmountCents'] = bigIntToJson(paidAmountCents);
    json['status'] = 
    loanInstallmentStatusSerializer(status)
    ;
    json['loan'] = loan.toJson();
    return json;
  }

  GetAgendaEntriesLoanInstallments({
    required this.id,
    required this.installmentNumber,
    required this.dueDate,
    required this.totalAmountCents,
    required this.paidAmountCents,
    required this.status,
    required this.loan,
  });
}

@immutable
class GetAgendaEntriesLoanInstallmentsLoan {
  final String id;
  final String name;
  final String? lender;
  final EnumValue<LoanStatus> status;
  GetAgendaEntriesLoanInstallmentsLoan.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  lender = json['lender'] == null ? null : nativeFromJson<String>(json['lender']),
  status = loanStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesLoanInstallmentsLoan otherTyped = other as GetAgendaEntriesLoanInstallmentsLoan;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    lender == otherTyped.lender && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, lender.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (lender != null) {
      json['lender'] = nativeToJson<String?>(lender);
    }
    json['status'] = 
    loanStatusSerializer(status)
    ;
    return json;
  }

  GetAgendaEntriesLoanInstallmentsLoan({
    required this.id,
    required this.name,
    this.lender,
    required this.status,
  });
}

@immutable
class GetAgendaEntriesRecurrenceSeries {
  final String id;
  final EnumValue<CashFlowDirection> direction;
  final EnumValue<CashFlowKind> kind;
  final EnumValue<CashFlowPaymentMethod> paymentMethod;
  final String description;
  final BigInt amountCents;
  final String? notes;
  final EnumValue<CashFlowRecurrenceFrequency> frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final int? occurrenceLimit;
  final int? preferredDay;
  final DateTime? nextOccurrenceDate;
  final EnumValue<CashFlowRecurrenceSeriesStatus> status;
  final GetAgendaEntriesRecurrenceSeriesCategory? category;
  GetAgendaEntriesRecurrenceSeries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  direction = cashFlowDirectionDeserializer(json['direction']),
  kind = cashFlowKindDeserializer(json['kind']),
  paymentMethod = cashFlowPaymentMethodDeserializer(json['paymentMethod']),
  description = nativeFromJson<String>(json['description']),
  amountCents = bigIntFromJson(json['amountCents']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  frequency = cashFlowRecurrenceFrequencyDeserializer(json['frequency']),
  startDate = nativeFromJson<DateTime>(json['startDate']),
  endDate = json['endDate'] == null ? null : nativeFromJson<DateTime>(json['endDate']),
  occurrenceLimit = json['occurrenceLimit'] == null ? null : nativeFromJson<int>(json['occurrenceLimit']),
  preferredDay = json['preferredDay'] == null ? null : nativeFromJson<int>(json['preferredDay']),
  nextOccurrenceDate = json['nextOccurrenceDate'] == null ? null : nativeFromJson<DateTime>(json['nextOccurrenceDate']),
  status = cashFlowRecurrenceSeriesStatusDeserializer(json['status']),
  category = json['category'] == null ? null : GetAgendaEntriesRecurrenceSeriesCategory.fromJson(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesRecurrenceSeries otherTyped = other as GetAgendaEntriesRecurrenceSeries;
    return id == otherTyped.id && 
    direction == otherTyped.direction && 
    kind == otherTyped.kind && 
    paymentMethod == otherTyped.paymentMethod && 
    description == otherTyped.description && 
    amountCents == otherTyped.amountCents && 
    notes == otherTyped.notes && 
    frequency == otherTyped.frequency && 
    startDate == otherTyped.startDate && 
    endDate == otherTyped.endDate && 
    occurrenceLimit == otherTyped.occurrenceLimit && 
    preferredDay == otherTyped.preferredDay && 
    nextOccurrenceDate == otherTyped.nextOccurrenceDate && 
    status == otherTyped.status && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, direction.hashCode, kind.hashCode, paymentMethod.hashCode, description.hashCode, amountCents.hashCode, notes.hashCode, frequency.hashCode, startDate.hashCode, endDate.hashCode, occurrenceLimit.hashCode, preferredDay.hashCode, nextOccurrenceDate.hashCode, status.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    json['kind'] = 
    cashFlowKindSerializer(kind)
    ;
    json['paymentMethod'] = 
    cashFlowPaymentMethodSerializer(paymentMethod)
    ;
    json['description'] = nativeToJson<String>(description);
    json['amountCents'] = bigIntToJson(amountCents);
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['frequency'] = 
    cashFlowRecurrenceFrequencySerializer(frequency)
    ;
    json['startDate'] = nativeToJson<DateTime>(startDate);
    if (endDate != null) {
      json['endDate'] = nativeToJson<DateTime?>(endDate);
    }
    if (occurrenceLimit != null) {
      json['occurrenceLimit'] = nativeToJson<int?>(occurrenceLimit);
    }
    if (preferredDay != null) {
      json['preferredDay'] = nativeToJson<int?>(preferredDay);
    }
    if (nextOccurrenceDate != null) {
      json['nextOccurrenceDate'] = nativeToJson<DateTime?>(nextOccurrenceDate);
    }
    json['status'] = 
    cashFlowRecurrenceSeriesStatusSerializer(status)
    ;
    if (category != null) {
      json['category'] = category!.toJson();
    }
    return json;
  }

  GetAgendaEntriesRecurrenceSeries({
    required this.id,
    required this.direction,
    required this.kind,
    required this.paymentMethod,
    required this.description,
    required this.amountCents,
    this.notes,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.occurrenceLimit,
    this.preferredDay,
    this.nextOccurrenceDate,
    required this.status,
    this.category,
  });
}

@immutable
class GetAgendaEntriesRecurrenceSeriesCategory {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  GetAgendaEntriesRecurrenceSeriesCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  icon = nativeFromJson<String>(json['icon']),
  colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesRecurrenceSeriesCategory otherTyped = other as GetAgendaEntriesRecurrenceSeriesCategory;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    icon == otherTyped.icon && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, icon.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['icon'] = nativeToJson<String>(icon);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  GetAgendaEntriesRecurrenceSeriesCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
  });
}

@immutable
class GetAgendaEntriesData {
  final List<GetAgendaEntriesCashFlowEntries> cashFlowEntries;
  final List<GetAgendaEntriesCreditCardInvoices> creditCardInvoices;
  final List<GetAgendaEntriesPurchaseInstallments> purchaseInstallments;
  final List<GetAgendaEntriesLoanInstallments> loanInstallments;
  final List<GetAgendaEntriesRecurrenceSeries> recurrenceSeries;
  GetAgendaEntriesData.fromJson(dynamic json):
  
  cashFlowEntries = (json['cashFlowEntries'] as List<dynamic>)
        .map((e) => GetAgendaEntriesCashFlowEntries.fromJson(e))
        .toList(),
  creditCardInvoices = (json['creditCardInvoices'] as List<dynamic>)
        .map((e) => GetAgendaEntriesCreditCardInvoices.fromJson(e))
        .toList(),
  purchaseInstallments = (json['purchaseInstallments'] as List<dynamic>)
        .map((e) => GetAgendaEntriesPurchaseInstallments.fromJson(e))
        .toList(),
  loanInstallments = (json['loanInstallments'] as List<dynamic>)
        .map((e) => GetAgendaEntriesLoanInstallments.fromJson(e))
        .toList(),
  recurrenceSeries = (json['recurrenceSeries'] as List<dynamic>)
        .map((e) => GetAgendaEntriesRecurrenceSeries.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesData otherTyped = other as GetAgendaEntriesData;
    return cashFlowEntries == otherTyped.cashFlowEntries && 
    creditCardInvoices == otherTyped.creditCardInvoices && 
    purchaseInstallments == otherTyped.purchaseInstallments && 
    loanInstallments == otherTyped.loanInstallments && 
    recurrenceSeries == otherTyped.recurrenceSeries;
    
  }
  @override
  int get hashCode => Object.hashAll([cashFlowEntries.hashCode, creditCardInvoices.hashCode, purchaseInstallments.hashCode, loanInstallments.hashCode, recurrenceSeries.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cashFlowEntries'] = cashFlowEntries.map((e) => e.toJson()).toList();
    json['creditCardInvoices'] = creditCardInvoices.map((e) => e.toJson()).toList();
    json['purchaseInstallments'] = purchaseInstallments.map((e) => e.toJson()).toList();
    json['loanInstallments'] = loanInstallments.map((e) => e.toJson()).toList();
    json['recurrenceSeries'] = recurrenceSeries.map((e) => e.toJson()).toList();
    return json;
  }

  GetAgendaEntriesData({
    required this.cashFlowEntries,
    required this.creditCardInvoices,
    required this.purchaseInstallments,
    required this.loanInstallments,
    required this.recurrenceSeries,
  });
}

@immutable
class GetAgendaEntriesVariables {
  final String spaceId;
  final Timestamp rangeStart;
  final Timestamp rangeEnd;
  final DateTime rangeStartDate;
  final DateTime rangeEndDate;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAgendaEntriesVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  rangeStart = Timestamp.fromJson(json['rangeStart']),
  rangeEnd = Timestamp.fromJson(json['rangeEnd']),
  rangeStartDate = nativeFromJson<DateTime>(json['rangeStartDate']),
  rangeEndDate = nativeFromJson<DateTime>(json['rangeEndDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAgendaEntriesVariables otherTyped = other as GetAgendaEntriesVariables;
    return spaceId == otherTyped.spaceId && 
    rangeStart == otherTyped.rangeStart && 
    rangeEnd == otherTyped.rangeEnd && 
    rangeStartDate == otherTyped.rangeStartDate && 
    rangeEndDate == otherTyped.rangeEndDate;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, rangeStart.hashCode, rangeEnd.hashCode, rangeStartDate.hashCode, rangeEndDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['rangeStart'] = rangeStart.toJson();
    json['rangeEnd'] = rangeEnd.toJson();
    json['rangeStartDate'] = nativeToJson<DateTime>(rangeStartDate);
    json['rangeEndDate'] = nativeToJson<DateTime>(rangeEndDate);
    return json;
  }

  GetAgendaEntriesVariables({
    required this.spaceId,
    required this.rangeStart,
    required this.rangeEnd,
    required this.rangeStartDate,
    required this.rangeEndDate,
  });
}

