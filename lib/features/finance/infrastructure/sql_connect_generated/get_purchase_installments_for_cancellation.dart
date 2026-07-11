part of 'client.dart';

class GetPurchaseInstallmentsForCancellationVariablesBuilder {
  String spaceId;
  String purchaseId;

  final FirebaseDataConnect _dataConnect;
  GetPurchaseInstallmentsForCancellationVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.purchaseId,
  });
  Deserializer<GetPurchaseInstallmentsForCancellationData> dataDeserializer =
      (dynamic json) =>
          GetPurchaseInstallmentsForCancellationData.fromJson(jsonDecode(json));
  Serializer<GetPurchaseInstallmentsForCancellationVariables> varsSerializer =
      (GetPurchaseInstallmentsForCancellationVariables vars) =>
          jsonEncode(vars.toJson());
  Future<
    QueryResult<
      GetPurchaseInstallmentsForCancellationData,
      GetPurchaseInstallmentsForCancellationVariables
    >
  >
  execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<
    GetPurchaseInstallmentsForCancellationData,
    GetPurchaseInstallmentsForCancellationVariables
  >
  ref() {
    GetPurchaseInstallmentsForCancellationVariables vars =
        GetPurchaseInstallmentsForCancellationVariables(
          spaceId: spaceId,
          purchaseId: purchaseId,
        );
    return _dataConnect.query(
      "GetPurchaseInstallmentsForCancellation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetPurchaseInstallmentsForCancellationPurchaseInstallments {
  final String id;
  final BigInt amountCents;
  final GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice
  invoice;
  GetPurchaseInstallmentsForCancellationPurchaseInstallments.fromJson(
    dynamic json,
  ) : id = nativeFromJson<String>(json['id']),
      amountCents = bigIntFromJson(json['amountCents']),
      invoice =
          GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice.fromJson(
            json['invoice'],
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPurchaseInstallmentsForCancellationPurchaseInstallments
    otherTyped =
        other as GetPurchaseInstallmentsForCancellationPurchaseInstallments;
    return id == otherTyped.id &&
        amountCents == otherTyped.amountCents &&
        invoice == otherTyped.invoice;
  }

  @override
  int get hashCode =>
      Object.hashAll([id.hashCode, amountCents.hashCode, invoice.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['amountCents'] = bigIntToJson(amountCents);
    json['invoice'] = invoice.toJson();
    return json;
  }

  GetPurchaseInstallmentsForCancellationPurchaseInstallments({
    required this.id,
    required this.amountCents,
    required this.invoice,
  });
}

@immutable
class GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice {
  final String id;
  GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice.fromJson(
    dynamic json,
  ) : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice
    otherTyped =
        other
            as GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetPurchaseInstallmentsForCancellationPurchaseInstallmentsInvoice({
    required this.id,
  });
}

@immutable
class GetPurchaseInstallmentsForCancellationData {
  final List<GetPurchaseInstallmentsForCancellationPurchaseInstallments>
  purchaseInstallments;
  GetPurchaseInstallmentsForCancellationData.fromJson(dynamic json)
    : purchaseInstallments = (json['purchaseInstallments'] as List<dynamic>)
          .map(
            (e) =>
                GetPurchaseInstallmentsForCancellationPurchaseInstallments.fromJson(
                  e,
                ),
          )
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPurchaseInstallmentsForCancellationData otherTyped =
        other as GetPurchaseInstallmentsForCancellationData;
    return purchaseInstallments == otherTyped.purchaseInstallments;
  }

  @override
  int get hashCode => purchaseInstallments.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['purchaseInstallments'] = purchaseInstallments
        .map((e) => e.toJson())
        .toList();
    return json;
  }

  GetPurchaseInstallmentsForCancellationData({
    required this.purchaseInstallments,
  });
}

@immutable
class GetPurchaseInstallmentsForCancellationVariables {
  final String spaceId;
  final String purchaseId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetPurchaseInstallmentsForCancellationVariables.fromJson(
    Map<String, dynamic> json,
  ) : spaceId = nativeFromJson<String>(json['spaceId']),
      purchaseId = nativeFromJson<String>(json['purchaseId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPurchaseInstallmentsForCancellationVariables otherTyped =
        other as GetPurchaseInstallmentsForCancellationVariables;
    return spaceId == otherTyped.spaceId && purchaseId == otherTyped.purchaseId;
  }

  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, purchaseId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['purchaseId'] = nativeToJson<String>(purchaseId);
    return json;
  }

  GetPurchaseInstallmentsForCancellationVariables({
    required this.spaceId,
    required this.purchaseId,
  });
}
