part of 'client.dart';

class RegisterFullInvoicePaymentVariablesBuilder {
  String spaceId;
  String invoiceId;
  BigInt amountCents;
  Timestamp paidAt;
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;
  RegisterFullInvoicePaymentVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.invoiceId,
    required this.amountCents,
    required this.paidAt,
    required this.idempotencyKey,
  });
  Deserializer<RegisterFullInvoicePaymentData> dataDeserializer =
      (dynamic json) =>
          RegisterFullInvoicePaymentData.fromJson(jsonDecode(json));
  Serializer<RegisterFullInvoicePaymentVariables> varsSerializer =
      (RegisterFullInvoicePaymentVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      RegisterFullInvoicePaymentData,
      RegisterFullInvoicePaymentVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    RegisterFullInvoicePaymentData,
    RegisterFullInvoicePaymentVariables
  >
  ref() {
    RegisterFullInvoicePaymentVariables vars =
        RegisterFullInvoicePaymentVariables(
          spaceId: spaceId,
          invoiceId: invoiceId,
          amountCents: amountCents,
          paidAt: paidAt,
          idempotencyKey: idempotencyKey,
        );
    return _dataConnect.mutation(
      "RegisterFullInvoicePayment",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class RegisterFullInvoicePaymentPayment {
  final String id;
  RegisterFullInvoicePaymentPayment.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterFullInvoicePaymentPayment otherTyped =
        other as RegisterFullInvoicePaymentPayment;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterFullInvoicePaymentPayment({required this.id});
}

@immutable
class RegisterFullInvoicePaymentInvoice {
  final String id;
  RegisterFullInvoicePaymentInvoice.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterFullInvoicePaymentInvoice otherTyped =
        other as RegisterFullInvoicePaymentInvoice;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterFullInvoicePaymentInvoice({required this.id});
}

@immutable
class RegisterFullInvoicePaymentAudit {
  final String id;
  RegisterFullInvoicePaymentAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterFullInvoicePaymentAudit otherTyped =
        other as RegisterFullInvoicePaymentAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterFullInvoicePaymentAudit({required this.id});
}

@immutable
class RegisterFullInvoicePaymentData {
  final RegisterFullInvoicePaymentPayment payment;
  final RegisterFullInvoicePaymentInvoice? invoice;
  final int installments;
  final RegisterFullInvoicePaymentAudit audit;
  RegisterFullInvoicePaymentData.fromJson(dynamic json)
    : payment = RegisterFullInvoicePaymentPayment.fromJson(json['payment']),
      invoice = json['invoice'] == null
          ? null
          : RegisterFullInvoicePaymentInvoice.fromJson(json['invoice']),
      installments = nativeFromJson<int>(json['installments']),
      audit = RegisterFullInvoicePaymentAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterFullInvoicePaymentData otherTyped =
        other as RegisterFullInvoicePaymentData;
    return payment == otherTyped.payment &&
        invoice == otherTyped.invoice &&
        installments == otherTyped.installments &&
        audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([
    payment.hashCode,
    invoice.hashCode,
    installments.hashCode,
    audit.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['payment'] = payment.toJson();
    if (invoice != null) {
      json['invoice'] = invoice!.toJson();
    }
    json['installments'] = nativeToJson<int>(installments);
    json['audit'] = audit.toJson();
    return json;
  }

  RegisterFullInvoicePaymentData({
    required this.payment,
    this.invoice,
    required this.installments,
    required this.audit,
  });
}

@immutable
class RegisterFullInvoicePaymentVariables {
  final String spaceId;
  final String invoiceId;
  final BigInt amountCents;
  final Timestamp paidAt;
  final String idempotencyKey;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  RegisterFullInvoicePaymentVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      invoiceId = nativeFromJson<String>(json['invoiceId']),
      amountCents = bigIntFromJson(json['amountCents']),
      paidAt = Timestamp.fromJson(json['paidAt']),
      idempotencyKey = nativeFromJson<String>(json['idempotencyKey']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterFullInvoicePaymentVariables otherTyped =
        other as RegisterFullInvoicePaymentVariables;
    return spaceId == otherTyped.spaceId &&
        invoiceId == otherTyped.invoiceId &&
        amountCents == otherTyped.amountCents &&
        paidAt == otherTyped.paidAt &&
        idempotencyKey == otherTyped.idempotencyKey;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    invoiceId.hashCode,
    amountCents.hashCode,
    paidAt.hashCode,
    idempotencyKey.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['invoiceId'] = nativeToJson<String>(invoiceId);
    json['amountCents'] = bigIntToJson(amountCents);
    json['paidAt'] = paidAt.toJson();
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  RegisterFullInvoicePaymentVariables({
    required this.spaceId,
    required this.invoiceId,
    required this.amountCents,
    required this.paidAt,
    required this.idempotencyKey,
  });
}
