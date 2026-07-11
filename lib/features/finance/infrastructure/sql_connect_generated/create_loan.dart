part of 'client.dart';

class CreateLoanVariablesBuilder {
  String spaceId;
  String name;
  Optional<String> _lender = Optional.optional(nativeFromJson, nativeToJson);
  BigInt principalAmountCents;
  BigInt monthlyInterestRateMicros;
  LoanAmortizationMethod amortizationMethod;
  int installmentCount;
  Optional<DateTime> _contractedAt = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  DateTime firstDueDate;
  Optional<BigInt> _expectedInstallmentAmountCents = Optional.optional(
    bigIntFromJson,
    bigIntToJson,
  );
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreateLoanVariablesBuilder lender(String? t) {
    _lender.value = t;
    return this;
  }

  CreateLoanVariablesBuilder contractedAt(DateTime? t) {
    _contractedAt.value = t;
    return this;
  }

  CreateLoanVariablesBuilder expectedInstallmentAmountCents(BigInt? t) {
    _expectedInstallmentAmountCents.value = t;
    return this;
  }

  CreateLoanVariablesBuilder notes(String? t) {
    _notes.value = t;
    return this;
  }

  CreateLoanVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.name,
    required this.principalAmountCents,
    required this.monthlyInterestRateMicros,
    required this.amortizationMethod,
    required this.installmentCount,
    required this.firstDueDate,
  });
  Deserializer<CreateLoanData> dataDeserializer = (dynamic json) =>
      CreateLoanData.fromJson(jsonDecode(json));
  Serializer<CreateLoanVariables> varsSerializer = (CreateLoanVariables vars) =>
      jsonEncode(vars.toJson());
  Future<OperationResult<CreateLoanData, CreateLoanVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateLoanData, CreateLoanVariables> ref() {
    CreateLoanVariables vars = CreateLoanVariables(
      spaceId: spaceId,
      name: name,
      lender: _lender,
      principalAmountCents: principalAmountCents,
      monthlyInterestRateMicros: monthlyInterestRateMicros,
      amortizationMethod: amortizationMethod,
      installmentCount: installmentCount,
      contractedAt: _contractedAt,
      firstDueDate: firstDueDate,
      expectedInstallmentAmountCents: _expectedInstallmentAmountCents,
      notes: _notes,
    );
    return _dataConnect.mutation(
      "CreateLoan",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateLoanLoan {
  final String id;
  CreateLoanLoan.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLoanLoan otherTyped = other as CreateLoanLoan;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateLoanLoan({required this.id});
}

@immutable
class CreateLoanAudit {
  final String id;
  CreateLoanAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLoanAudit otherTyped = other as CreateLoanAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateLoanAudit({required this.id});
}

@immutable
class CreateLoanData {
  final CreateLoanLoan loan;
  final CreateLoanAudit audit;
  CreateLoanData.fromJson(dynamic json)
    : loan = CreateLoanLoan.fromJson(json['loan']),
      audit = CreateLoanAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLoanData otherTyped = other as CreateLoanData;
    return loan == otherTyped.loan && audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([loan.hashCode, audit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['loan'] = loan.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateLoanData({required this.loan, required this.audit});
}

@immutable
class CreateLoanVariables {
  final String spaceId;
  final String name;
  late final Optional<String> lender;
  final BigInt principalAmountCents;
  final BigInt monthlyInterestRateMicros;
  final LoanAmortizationMethod amortizationMethod;
  final int installmentCount;
  late final Optional<DateTime> contractedAt;
  final DateTime firstDueDate;
  late final Optional<BigInt> expectedInstallmentAmountCents;
  late final Optional<String> notes;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateLoanVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      name = nativeFromJson<String>(json['name']),
      principalAmountCents = bigIntFromJson(json['principalAmountCents']),
      monthlyInterestRateMicros = bigIntFromJson(
        json['monthlyInterestRateMicros'],
      ),
      amortizationMethod = LoanAmortizationMethod.values.byName(
        json['amortizationMethod'],
      ),
      installmentCount = nativeFromJson<int>(json['installmentCount']),
      firstDueDate = nativeFromJson<DateTime>(json['firstDueDate']) {
    lender = Optional.optional(nativeFromJson, nativeToJson);
    lender.value = json['lender'] == null
        ? null
        : nativeFromJson<String>(json['lender']);

    contractedAt = Optional.optional(nativeFromJson, nativeToJson);
    contractedAt.value = json['contractedAt'] == null
        ? null
        : nativeFromJson<DateTime>(json['contractedAt']);

    expectedInstallmentAmountCents = Optional.optional(
      bigIntFromJson,
      bigIntToJson,
    );
    expectedInstallmentAmountCents.value =
        json['expectedInstallmentAmountCents'] == null
        ? null
        : bigIntFromJson(json['expectedInstallmentAmountCents']);

    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null
        ? null
        : nativeFromJson<String>(json['notes']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLoanVariables otherTyped = other as CreateLoanVariables;
    return spaceId == otherTyped.spaceId &&
        name == otherTyped.name &&
        lender == otherTyped.lender &&
        principalAmountCents == otherTyped.principalAmountCents &&
        monthlyInterestRateMicros == otherTyped.monthlyInterestRateMicros &&
        amortizationMethod == otherTyped.amortizationMethod &&
        installmentCount == otherTyped.installmentCount &&
        contractedAt == otherTyped.contractedAt &&
        firstDueDate == otherTyped.firstDueDate &&
        expectedInstallmentAmountCents ==
            otherTyped.expectedInstallmentAmountCents &&
        notes == otherTyped.notes;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    name.hashCode,
    lender.hashCode,
    principalAmountCents.hashCode,
    monthlyInterestRateMicros.hashCode,
    amortizationMethod.hashCode,
    installmentCount.hashCode,
    contractedAt.hashCode,
    firstDueDate.hashCode,
    expectedInstallmentAmountCents.hashCode,
    notes.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['name'] = nativeToJson<String>(name);
    if (lender.state == OptionalState.set) {
      json['lender'] = lender.toJson();
    }
    json['principalAmountCents'] = bigIntToJson(principalAmountCents);
    json['monthlyInterestRateMicros'] = bigIntToJson(monthlyInterestRateMicros);
    json['amortizationMethod'] = amortizationMethod.name;
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    if (contractedAt.state == OptionalState.set) {
      json['contractedAt'] = contractedAt.toJson();
    }
    json['firstDueDate'] = nativeToJson<DateTime>(firstDueDate);
    if (expectedInstallmentAmountCents.state == OptionalState.set) {
      json['expectedInstallmentAmountCents'] = expectedInstallmentAmountCents
          .toJson();
    }
    if (notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    return json;
  }

  CreateLoanVariables({
    required this.spaceId,
    required this.name,
    required this.lender,
    required this.principalAmountCents,
    required this.monthlyInterestRateMicros,
    required this.amortizationMethod,
    required this.installmentCount,
    required this.contractedAt,
    required this.firstDueDate,
    required this.expectedInstallmentAmountCents,
    required this.notes,
  });
}
