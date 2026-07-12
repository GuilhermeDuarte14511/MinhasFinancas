part of 'client.dart';

class CancelPurchaseVariablesBuilder {
  String spaceId;
  String purchaseId;
  String reason;

  final FirebaseDataConnect _dataConnect;
  CancelPurchaseVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.purchaseId,
    required this.reason,
  });
  Deserializer<CancelPurchaseData> dataDeserializer = (dynamic json) =>
      CancelPurchaseData.fromJson(jsonDecode(json));
  Serializer<CancelPurchaseVariables> varsSerializer =
      (CancelPurchaseVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CancelPurchaseData, CancelPurchaseVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CancelPurchaseData, CancelPurchaseVariables> ref() {
    CancelPurchaseVariables vars = CancelPurchaseVariables(
      spaceId: spaceId,
      purchaseId: purchaseId,
      reason: reason,
    );
    return _dataConnect.mutation(
      "CancelPurchase",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CancelPurchasePurchase {
  final String id;
  CancelPurchasePurchase.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchasePurchase otherTyped = other as CancelPurchasePurchase;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CancelPurchasePurchase({required this.id});
}

@immutable
class CancelPurchaseData {
  final CancelPurchasePurchase? purchase;
  final int installments;
  final int cashFlow;
  CancelPurchaseData.fromJson(dynamic json)
    : purchase = json['purchase'] == null
          ? null
          : CancelPurchasePurchase.fromJson(json['purchase']),
      installments = nativeFromJson<int>(json['installments']),
      cashFlow = nativeFromJson<int>(json['cashFlow']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseData otherTyped = other as CancelPurchaseData;
    return purchase == otherTyped.purchase &&
        installments == otherTyped.installments &&
        cashFlow == otherTyped.cashFlow;
  }

  @override
  int get hashCode => Object.hashAll([
    purchase.hashCode,
    installments.hashCode,
    cashFlow.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (purchase != null) {
      json['purchase'] = purchase!.toJson();
    }
    json['installments'] = nativeToJson<int>(installments);
    json['cashFlow'] = nativeToJson<int>(cashFlow);
    return json;
  }

  CancelPurchaseData({
    this.purchase,
    required this.installments,
    required this.cashFlow,
  });
}

@immutable
class CancelPurchaseVariables {
  final String spaceId;
  final String purchaseId;
  final String reason;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CancelPurchaseVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      purchaseId = nativeFromJson<String>(json['purchaseId']),
      reason = nativeFromJson<String>(json['reason']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CancelPurchaseVariables otherTyped = other as CancelPurchaseVariables;
    return spaceId == otherTyped.spaceId &&
        purchaseId == otherTyped.purchaseId &&
        reason == otherTyped.reason;
  }

  @override
  int get hashCode =>
      Object.hashAll([spaceId.hashCode, purchaseId.hashCode, reason.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['purchaseId'] = nativeToJson<String>(purchaseId);
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  CancelPurchaseVariables({
    required this.spaceId,
    required this.purchaseId,
    required this.reason,
  });
}
