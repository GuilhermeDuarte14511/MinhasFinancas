part of 'client.dart';

class CreateCreditCardInvoiceVariablesBuilder {
  String spaceId;
  String cardId;
  DateTime referenceMonth;
  DateTime closingDate;
  DateTime dueDate;

  final FirebaseDataConnect _dataConnect;
  CreateCreditCardInvoiceVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.cardId,
    required this.referenceMonth,
    required this.closingDate,
    required this.dueDate,
  });
  Deserializer<CreateCreditCardInvoiceData> dataDeserializer = (dynamic json) =>
      CreateCreditCardInvoiceData.fromJson(jsonDecode(json));
  Serializer<CreateCreditCardInvoiceVariables> varsSerializer =
      (CreateCreditCardInvoiceVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      CreateCreditCardInvoiceData,
      CreateCreditCardInvoiceVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<CreateCreditCardInvoiceData, CreateCreditCardInvoiceVariables>
  ref() {
    CreateCreditCardInvoiceVariables vars = CreateCreditCardInvoiceVariables(
      spaceId: spaceId,
      cardId: cardId,
      referenceMonth: referenceMonth,
      closingDate: closingDate,
      dueDate: dueDate,
    );
    return _dataConnect.mutation(
      "CreateCreditCardInvoice",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateCreditCardInvoiceInvoice {
  final String id;
  CreateCreditCardInvoiceInvoice.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardInvoiceInvoice otherTyped =
        other as CreateCreditCardInvoiceInvoice;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCreditCardInvoiceInvoice({required this.id});
}

@immutable
class CreateCreditCardInvoiceData {
  final CreateCreditCardInvoiceInvoice invoice;
  CreateCreditCardInvoiceData.fromJson(dynamic json)
    : invoice = CreateCreditCardInvoiceInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardInvoiceData otherTyped =
        other as CreateCreditCardInvoiceData;
    return invoice == otherTyped.invoice;
  }

  @override
  int get hashCode => invoice.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoice'] = invoice.toJson();
    return json;
  }

  CreateCreditCardInvoiceData({required this.invoice});
}

@immutable
class CreateCreditCardInvoiceVariables {
  final String spaceId;
  final String cardId;
  final DateTime referenceMonth;
  final DateTime closingDate;
  final DateTime dueDate;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateCreditCardInvoiceVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      cardId = nativeFromJson<String>(json['cardId']),
      referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
      closingDate = nativeFromJson<DateTime>(json['closingDate']),
      dueDate = nativeFromJson<DateTime>(json['dueDate']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCreditCardInvoiceVariables otherTyped =
        other as CreateCreditCardInvoiceVariables;
    return spaceId == otherTyped.spaceId &&
        cardId == otherTyped.cardId &&
        referenceMonth == otherTyped.referenceMonth &&
        closingDate == otherTyped.closingDate &&
        dueDate == otherTyped.dueDate;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    cardId.hashCode,
    referenceMonth.hashCode,
    closingDate.hashCode,
    dueDate.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    json['closingDate'] = nativeToJson<DateTime>(closingDate);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    return json;
  }

  CreateCreditCardInvoiceVariables({
    required this.spaceId,
    required this.cardId,
    required this.referenceMonth,
    required this.closingDate,
    required this.dueDate,
  });
}
