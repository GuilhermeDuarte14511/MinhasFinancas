part of 'client.dart';

class AddLoanInstallmentVariablesBuilder {
  String spaceId;
  String loanId;
  int installmentNumber;
  DateTime dueDate;
  BigInt openingBalanceCents;
  BigInt principalAmountCents;
  BigInt interestAmountCents;
  BigInt totalAmountCents;

  final FirebaseDataConnect _dataConnect;
  AddLoanInstallmentVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.loanId,
    required this.installmentNumber,
    required this.dueDate,
    required this.openingBalanceCents,
    required this.principalAmountCents,
    required this.interestAmountCents,
    required this.totalAmountCents,
  });
  Deserializer<AddLoanInstallmentData> dataDeserializer = (dynamic json) =>
      AddLoanInstallmentData.fromJson(jsonDecode(json));
  Serializer<AddLoanInstallmentVariables> varsSerializer =
      (AddLoanInstallmentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddLoanInstallmentData, AddLoanInstallmentVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<AddLoanInstallmentData, AddLoanInstallmentVariables> ref() {
    AddLoanInstallmentVariables vars = AddLoanInstallmentVariables(
      spaceId: spaceId,
      loanId: loanId,
      installmentNumber: installmentNumber,
      dueDate: dueDate,
      openingBalanceCents: openingBalanceCents,
      principalAmountCents: principalAmountCents,
      interestAmountCents: interestAmountCents,
      totalAmountCents: totalAmountCents,
    );
    return _dataConnect.mutation(
      "AddLoanInstallment",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class AddLoanInstallmentInstallment {
  final String id;
  AddLoanInstallmentInstallment.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddLoanInstallmentInstallment otherTyped =
        other as AddLoanInstallmentInstallment;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddLoanInstallmentInstallment({required this.id});
}

@immutable
class AddLoanInstallmentData {
  final AddLoanInstallmentInstallment installment;
  AddLoanInstallmentData.fromJson(dynamic json)
    : installment = AddLoanInstallmentInstallment.fromJson(json['installment']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddLoanInstallmentData otherTyped = other as AddLoanInstallmentData;
    return installment == otherTyped.installment;
  }

  @override
  int get hashCode => installment.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['installment'] = installment.toJson();
    return json;
  }

  AddLoanInstallmentData({required this.installment});
}

@immutable
class AddLoanInstallmentVariables {
  final String spaceId;
  final String loanId;
  final int installmentNumber;
  final DateTime dueDate;
  final BigInt openingBalanceCents;
  final BigInt principalAmountCents;
  final BigInt interestAmountCents;
  final BigInt totalAmountCents;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  AddLoanInstallmentVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      loanId = nativeFromJson<String>(json['loanId']),
      installmentNumber = nativeFromJson<int>(json['installmentNumber']),
      dueDate = nativeFromJson<DateTime>(json['dueDate']),
      openingBalanceCents = bigIntFromJson(json['openingBalanceCents']),
      principalAmountCents = bigIntFromJson(json['principalAmountCents']),
      interestAmountCents = bigIntFromJson(json['interestAmountCents']),
      totalAmountCents = bigIntFromJson(json['totalAmountCents']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddLoanInstallmentVariables otherTyped =
        other as AddLoanInstallmentVariables;
    return spaceId == otherTyped.spaceId &&
        loanId == otherTyped.loanId &&
        installmentNumber == otherTyped.installmentNumber &&
        dueDate == otherTyped.dueDate &&
        openingBalanceCents == otherTyped.openingBalanceCents &&
        principalAmountCents == otherTyped.principalAmountCents &&
        interestAmountCents == otherTyped.interestAmountCents &&
        totalAmountCents == otherTyped.totalAmountCents;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    loanId.hashCode,
    installmentNumber.hashCode,
    dueDate.hashCode,
    openingBalanceCents.hashCode,
    principalAmountCents.hashCode,
    interestAmountCents.hashCode,
    totalAmountCents.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['loanId'] = nativeToJson<String>(loanId);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['openingBalanceCents'] = bigIntToJson(openingBalanceCents);
    json['principalAmountCents'] = bigIntToJson(principalAmountCents);
    json['interestAmountCents'] = bigIntToJson(interestAmountCents);
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    return json;
  }

  AddLoanInstallmentVariables({
    required this.spaceId,
    required this.loanId,
    required this.installmentNumber,
    required this.dueDate,
    required this.openingBalanceCents,
    required this.principalAmountCents,
    required this.interestAmountCents,
    required this.totalAmountCents,
  });
}
