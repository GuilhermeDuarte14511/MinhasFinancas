part of 'client.dart';

class DeleteCreditCardCascadeVariablesBuilder {
  String spaceId;
  String cardId;

  final FirebaseDataConnect _dataConnect;
  DeleteCreditCardCascadeVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.cardId,
  });
  Deserializer<DeleteCreditCardCascadeData> dataDeserializer = (dynamic json) =>
      DeleteCreditCardCascadeData.fromJson(jsonDecode(json));
  Serializer<DeleteCreditCardCascadeVariables> varsSerializer =
      (DeleteCreditCardCascadeVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      DeleteCreditCardCascadeData,
      DeleteCreditCardCascadeVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteCreditCardCascadeData, DeleteCreditCardCascadeVariables>
  ref() {
    DeleteCreditCardCascadeVariables vars = DeleteCreditCardCascadeVariables(
      spaceId: spaceId,
      cardId: cardId,
    );
    return _dataConnect.mutation(
      "DeleteCreditCardCascade",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteCreditCardCascadeCard {
  final String id;
  DeleteCreditCardCascadeCard.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCreditCardCascadeCard otherTyped =
        other as DeleteCreditCardCascadeCard;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCreditCardCascadeCard({required this.id});
}

@immutable
class DeleteCreditCardCascadeAudit {
  final String id;
  DeleteCreditCardCascadeAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCreditCardCascadeAudit otherTyped =
        other as DeleteCreditCardCascadeAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCreditCardCascadeAudit({required this.id});
}

@immutable
class DeleteCreditCardCascadeData {
  final int directNotifications;
  final int invoicePayments;
  final int installments;
  final int generatedCashFlow;
  final int invoices;
  final int purchases;
  final DeleteCreditCardCascadeCard? card;
  final DeleteCreditCardCascadeAudit audit;
  DeleteCreditCardCascadeData.fromJson(dynamic json)
    : directNotifications = nativeFromJson<int>(json['directNotifications']),
      invoicePayments = nativeFromJson<int>(json['invoicePayments']),
      installments = nativeFromJson<int>(json['installments']),
      generatedCashFlow = nativeFromJson<int>(json['generatedCashFlow']),
      invoices = nativeFromJson<int>(json['invoices']),
      purchases = nativeFromJson<int>(json['purchases']),
      card = json['card'] == null
          ? null
          : DeleteCreditCardCascadeCard.fromJson(json['card']),
      audit = DeleteCreditCardCascadeAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCreditCardCascadeData otherTyped =
        other as DeleteCreditCardCascadeData;
    return directNotifications == otherTyped.directNotifications &&
        invoicePayments == otherTyped.invoicePayments &&
        installments == otherTyped.installments &&
        generatedCashFlow == otherTyped.generatedCashFlow &&
        invoices == otherTyped.invoices &&
        purchases == otherTyped.purchases &&
        card == otherTyped.card &&
        audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([
    directNotifications.hashCode,
    invoicePayments.hashCode,
    installments.hashCode,
    generatedCashFlow.hashCode,
    invoices.hashCode,
    purchases.hashCode,
    card.hashCode,
    audit.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['directNotifications'] = nativeToJson<int>(directNotifications);
    json['invoicePayments'] = nativeToJson<int>(invoicePayments);
    json['installments'] = nativeToJson<int>(installments);
    json['generatedCashFlow'] = nativeToJson<int>(generatedCashFlow);
    json['invoices'] = nativeToJson<int>(invoices);
    json['purchases'] = nativeToJson<int>(purchases);
    if (card != null) {
      json['card'] = card!.toJson();
    }
    json['audit'] = audit.toJson();
    return json;
  }

  DeleteCreditCardCascadeData({
    required this.directNotifications,
    required this.invoicePayments,
    required this.installments,
    required this.generatedCashFlow,
    required this.invoices,
    required this.purchases,
    this.card,
    required this.audit,
  });
}

@immutable
class DeleteCreditCardCascadeVariables {
  final String spaceId;
  final String cardId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteCreditCardCascadeVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      cardId = nativeFromJson<String>(json['cardId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCreditCardCascadeVariables otherTyped =
        other as DeleteCreditCardCascadeVariables;
    return spaceId == otherTyped.spaceId && cardId == otherTyped.cardId;
  }

  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, cardId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['cardId'] = nativeToJson<String>(cardId);
    return json;
  }

  DeleteCreditCardCascadeVariables({
    required this.spaceId,
    required this.cardId,
  });
}
