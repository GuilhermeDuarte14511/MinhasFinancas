part of 'client.dart';

class FindCreditCardInvoiceVariablesBuilder {
  String spaceId;
  String cardId;
  DateTime referenceMonth;

  final FirebaseDataConnect _dataConnect;
  FindCreditCardInvoiceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.cardId,
    required this.referenceMonth,
  });
  Deserializer<FindCreditCardInvoiceData> dataDeserializer = (dynamic json) =>
      FindCreditCardInvoiceData.fromJson(jsonDecode(json));
  Serializer<FindCreditCardInvoiceVariables> varsSerializer =
      (FindCreditCardInvoiceVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<FindCreditCardInvoiceData, FindCreditCardInvoiceVariables>>
  execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<FindCreditCardInvoiceData, FindCreditCardInvoiceVariables> ref() {
    FindCreditCardInvoiceVariables vars = FindCreditCardInvoiceVariables(
      spaceId: spaceId,
      cardId: cardId,
      referenceMonth: referenceMonth,
    );
    return _dataConnect.query(
      "FindCreditCardInvoice",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class FindCreditCardInvoiceCreditCardInvoices {
  final String id;
  final BigInt totalAmountCents;
  final BigInt paidAmountCents;
  final EnumValue<InvoiceStatus> status;
  FindCreditCardInvoiceCreditCardInvoices.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      totalAmountCents = bigIntFromJson(json['totalAmountCents']),
      paidAmountCents = bigIntFromJson(json['paidAmountCents']),
      status = invoiceStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final FindCreditCardInvoiceCreditCardInvoices otherTyped =
        other as FindCreditCardInvoiceCreditCardInvoices;
    return id == otherTyped.id &&
        totalAmountCents == otherTyped.totalAmountCents &&
        paidAmountCents == otherTyped.paidAmountCents &&
        status == otherTyped.status;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    totalAmountCents.hashCode,
    paidAmountCents.hashCode,
    status.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['paidAmountCents'] = bigIntToJson(paidAmountCents);
    json['status'] = invoiceStatusSerializer(status);
    return json;
  }

  FindCreditCardInvoiceCreditCardInvoices({
    required this.id,
    required this.totalAmountCents,
    required this.paidAmountCents,
    required this.status,
  });
}

@immutable
class FindCreditCardInvoiceData {
  final List<FindCreditCardInvoiceCreditCardInvoices> creditCardInvoices;
  FindCreditCardInvoiceData.fromJson(dynamic json)
    : creditCardInvoices = (json['creditCardInvoices'] as List<dynamic>)
          .map((e) => FindCreditCardInvoiceCreditCardInvoices.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final FindCreditCardInvoiceData otherTyped =
        other as FindCreditCardInvoiceData;
    return creditCardInvoices == otherTyped.creditCardInvoices;
  }

  @override
  int get hashCode => creditCardInvoices.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['creditCardInvoices'] = creditCardInvoices
        .map((e) => e.toJson())
        .toList();
    return json;
  }

  FindCreditCardInvoiceData({required this.creditCardInvoices});
}

@immutable
class FindCreditCardInvoiceVariables {
  final String spaceId;
  final String cardId;
  final DateTime referenceMonth;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  FindCreditCardInvoiceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      cardId = nativeFromJson<String>(json['cardId']),
      referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final FindCreditCardInvoiceVariables otherTyped =
        other as FindCreditCardInvoiceVariables;
    return spaceId == otherTyped.spaceId &&
        cardId == otherTyped.cardId &&
        referenceMonth == otherTyped.referenceMonth;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    cardId.hashCode,
    referenceMonth.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    return json;
  }

  FindCreditCardInvoiceVariables({
    required this.spaceId,
    required this.cardId,
    required this.referenceMonth,
  });
}
