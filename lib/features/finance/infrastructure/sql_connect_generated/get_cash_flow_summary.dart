part of 'client.dart';

class GetCashFlowSummaryVariablesBuilder {
  String spaceId;
  DateTime monthStart;
  DateTime yearStart;
  DateTime nextYearStart;
  Timestamp monthStartedAt;
  Timestamp nextMonthStartedAt;
  Timestamp yearStartedAt;
  Timestamp nextYearStartedAt;

  final FirebaseDataConnect _dataConnect;
  GetCashFlowSummaryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.monthStart,required  this.yearStart,required  this.nextYearStart,required  this.monthStartedAt,required  this.nextMonthStartedAt,required  this.yearStartedAt,required  this.nextYearStartedAt,});
  Deserializer<GetCashFlowSummaryData> dataDeserializer = (dynamic json)  => GetCashFlowSummaryData.fromJson(jsonDecode(json));
  Serializer<GetCashFlowSummaryVariables> varsSerializer = (GetCashFlowSummaryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetCashFlowSummaryData, GetCashFlowSummaryVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetCashFlowSummaryData, GetCashFlowSummaryVariables> ref() {
    GetCashFlowSummaryVariables vars= GetCashFlowSummaryVariables(spaceId: spaceId,monthStart: monthStart,yearStart: yearStart,nextYearStart: nextYearStart,monthStartedAt: monthStartedAt,nextMonthStartedAt: nextMonthStartedAt,yearStartedAt: yearStartedAt,nextYearStartedAt: nextYearStartedAt,);
    return _dataConnect.query("GetCashFlowSummary", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetCashFlowSummaryMonth {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryMonth.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryMonth otherTyped = other as GetCashFlowSummaryMonth;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryMonth({
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryYear {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryYear.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryYear otherTyped = other as GetCashFlowSummaryYear;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryYear({
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryLifetime {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  final DateTime? competenceMonth_min;
  final DateTime? competenceMonth_max;
  GetCashFlowSummaryLifetime.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']),
  competenceMonth_min = json['competenceMonth_min'] == null ? null : nativeFromJson<DateTime>(json['competenceMonth_min']),
  competenceMonth_max = json['competenceMonth_max'] == null ? null : nativeFromJson<DateTime>(json['competenceMonth_max']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLifetime otherTyped = other as GetCashFlowSummaryLifetime;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum && 
    competenceMonth_min == otherTyped.competenceMonth_min && 
    competenceMonth_max == otherTyped.competenceMonth_max;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode, competenceMonth_min.hashCode, competenceMonth_max.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    if (competenceMonth_min != null) {
      json['competenceMonth_min'] = nativeToJson<DateTime?>(competenceMonth_min);
    }
    if (competenceMonth_max != null) {
      json['competenceMonth_max'] = nativeToJson<DateTime?>(competenceMonth_max);
    }
    return json;
  }

  GetCashFlowSummaryLifetime({
    required this.direction,
    this.amountCents_sum,
    this.competenceMonth_min,
    this.competenceMonth_max,
  });
}

@immutable
class GetCashFlowSummaryYearSeries {
  final DateTime competenceMonth;
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryYearSeries.fromJson(dynamic json):
  
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryYearSeries otherTyped = other as GetCashFlowSummaryYearSeries;
    return competenceMonth == otherTyped.competenceMonth && 
    direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([competenceMonth.hashCode, direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryYearSeries({
    required this.competenceMonth,
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryMonthPlanned {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryMonthPlanned.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryMonthPlanned otherTyped = other as GetCashFlowSummaryMonthPlanned;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryMonthPlanned({
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryYearPlanned {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryYearPlanned.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryYearPlanned otherTyped = other as GetCashFlowSummaryYearPlanned;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryYearPlanned({
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryLifetimePlanned {
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  final DateTime? competenceMonth_min;
  final DateTime? competenceMonth_max;
  GetCashFlowSummaryLifetimePlanned.fromJson(dynamic json):
  
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']),
  competenceMonth_min = json['competenceMonth_min'] == null ? null : nativeFromJson<DateTime>(json['competenceMonth_min']),
  competenceMonth_max = json['competenceMonth_max'] == null ? null : nativeFromJson<DateTime>(json['competenceMonth_max']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLifetimePlanned otherTyped = other as GetCashFlowSummaryLifetimePlanned;
    return direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum && 
    competenceMonth_min == otherTyped.competenceMonth_min && 
    competenceMonth_max == otherTyped.competenceMonth_max;
    
  }
  @override
  int get hashCode => Object.hashAll([direction.hashCode, amountCents_sum.hashCode, competenceMonth_min.hashCode, competenceMonth_max.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    if (competenceMonth_min != null) {
      json['competenceMonth_min'] = nativeToJson<DateTime?>(competenceMonth_min);
    }
    if (competenceMonth_max != null) {
      json['competenceMonth_max'] = nativeToJson<DateTime?>(competenceMonth_max);
    }
    return json;
  }

  GetCashFlowSummaryLifetimePlanned({
    required this.direction,
    this.amountCents_sum,
    this.competenceMonth_min,
    this.competenceMonth_max,
  });
}

@immutable
class GetCashFlowSummaryYearPlannedSeries {
  final DateTime competenceMonth;
  final EnumValue<CashFlowDirection> direction;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryYearPlannedSeries.fromJson(dynamic json):
  
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  direction = cashFlowDirectionDeserializer(json['direction']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryYearPlannedSeries otherTyped = other as GetCashFlowSummaryYearPlannedSeries;
    return competenceMonth == otherTyped.competenceMonth && 
    direction == otherTyped.direction && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([competenceMonth.hashCode, direction.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryYearPlannedSeries({
    required this.competenceMonth,
    required this.direction,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryCardMonth {
  final BigInt? totalAmountCents_sum;
  GetCashFlowSummaryCardMonth.fromJson(dynamic json):
  
  totalAmountCents_sum = json['totalAmountCents_sum'] == null ? null : bigIntFromJson(json['totalAmountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryCardMonth otherTyped = other as GetCashFlowSummaryCardMonth;
    return totalAmountCents_sum == otherTyped.totalAmountCents_sum;
    
  }
  @override
  int get hashCode => totalAmountCents_sum.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (totalAmountCents_sum != null) {
      json['totalAmountCents_sum'] = bigIntToJson(totalAmountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryCardMonth({
    this.totalAmountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryCardYear {
  final BigInt? totalAmountCents_sum;
  GetCashFlowSummaryCardYear.fromJson(dynamic json):
  
  totalAmountCents_sum = json['totalAmountCents_sum'] == null ? null : bigIntFromJson(json['totalAmountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryCardYear otherTyped = other as GetCashFlowSummaryCardYear;
    return totalAmountCents_sum == otherTyped.totalAmountCents_sum;
    
  }
  @override
  int get hashCode => totalAmountCents_sum.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (totalAmountCents_sum != null) {
      json['totalAmountCents_sum'] = bigIntToJson(totalAmountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryCardYear({
    this.totalAmountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryCardLifetime {
  final BigInt? totalAmountCents_sum;
  final DateTime? referenceMonth_min;
  final DateTime? referenceMonth_max;
  GetCashFlowSummaryCardLifetime.fromJson(dynamic json):
  
  totalAmountCents_sum = json['totalAmountCents_sum'] == null ? null : bigIntFromJson(json['totalAmountCents_sum']),
  referenceMonth_min = json['referenceMonth_min'] == null ? null : nativeFromJson<DateTime>(json['referenceMonth_min']),
  referenceMonth_max = json['referenceMonth_max'] == null ? null : nativeFromJson<DateTime>(json['referenceMonth_max']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryCardLifetime otherTyped = other as GetCashFlowSummaryCardLifetime;
    return totalAmountCents_sum == otherTyped.totalAmountCents_sum && 
    referenceMonth_min == otherTyped.referenceMonth_min && 
    referenceMonth_max == otherTyped.referenceMonth_max;
    
  }
  @override
  int get hashCode => Object.hashAll([totalAmountCents_sum.hashCode, referenceMonth_min.hashCode, referenceMonth_max.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (totalAmountCents_sum != null) {
      json['totalAmountCents_sum'] = bigIntToJson(totalAmountCents_sum);
    }
    if (referenceMonth_min != null) {
      json['referenceMonth_min'] = nativeToJson<DateTime?>(referenceMonth_min);
    }
    if (referenceMonth_max != null) {
      json['referenceMonth_max'] = nativeToJson<DateTime?>(referenceMonth_max);
    }
    return json;
  }

  GetCashFlowSummaryCardLifetime({
    this.totalAmountCents_sum,
    this.referenceMonth_min,
    this.referenceMonth_max,
  });
}

@immutable
class GetCashFlowSummaryCardYearSeries {
  final DateTime referenceMonth;
  final BigInt? totalAmountCents_sum;
  GetCashFlowSummaryCardYearSeries.fromJson(dynamic json):
  
  referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
  totalAmountCents_sum = json['totalAmountCents_sum'] == null ? null : bigIntFromJson(json['totalAmountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryCardYearSeries otherTyped = other as GetCashFlowSummaryCardYearSeries;
    return referenceMonth == otherTyped.referenceMonth && 
    totalAmountCents_sum == otherTyped.totalAmountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([referenceMonth.hashCode, totalAmountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    if (totalAmountCents_sum != null) {
      json['totalAmountCents_sum'] = bigIntToJson(totalAmountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryCardYearSeries({
    required this.referenceMonth,
    this.totalAmountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryLoanMonth {
  final BigInt? amountCents_sum;
  GetCashFlowSummaryLoanMonth.fromJson(dynamic json):
  
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLoanMonth otherTyped = other as GetCashFlowSummaryLoanMonth;
    return amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => amountCents_sum.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryLoanMonth({
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryLoanYear {
  final BigInt? amountCents_sum;
  GetCashFlowSummaryLoanYear.fromJson(dynamic json):
  
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLoanYear otherTyped = other as GetCashFlowSummaryLoanYear;
    return amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => amountCents_sum.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryLoanYear({
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryLoanLifetime {
  final BigInt? amountCents_sum;
  final Timestamp? paidAt_min;
  final Timestamp? paidAt_max;
  GetCashFlowSummaryLoanLifetime.fromJson(dynamic json):
  
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']),
  paidAt_min = json['paidAt_min'] == null ? null : Timestamp.fromJson(json['paidAt_min']),
  paidAt_max = json['paidAt_max'] == null ? null : Timestamp.fromJson(json['paidAt_max']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLoanLifetime otherTyped = other as GetCashFlowSummaryLoanLifetime;
    return amountCents_sum == otherTyped.amountCents_sum && 
    paidAt_min == otherTyped.paidAt_min && 
    paidAt_max == otherTyped.paidAt_max;
    
  }
  @override
  int get hashCode => Object.hashAll([amountCents_sum.hashCode, paidAt_min.hashCode, paidAt_max.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    if (paidAt_min != null) {
      json['paidAt_min'] = paidAt_min!.toJson();
    }
    if (paidAt_max != null) {
      json['paidAt_max'] = paidAt_max!.toJson();
    }
    return json;
  }

  GetCashFlowSummaryLoanLifetime({
    this.amountCents_sum,
    this.paidAt_min,
    this.paidAt_max,
  });
}

@immutable
class GetCashFlowSummaryLoanYearSeries {
  final Timestamp paidAt;
  final BigInt? amountCents_sum;
  GetCashFlowSummaryLoanYearSeries.fromJson(dynamic json):
  
  paidAt = Timestamp.fromJson(json['paidAt']),
  amountCents_sum = json['amountCents_sum'] == null ? null : bigIntFromJson(json['amountCents_sum']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryLoanYearSeries otherTyped = other as GetCashFlowSummaryLoanYearSeries;
    return paidAt == otherTyped.paidAt && 
    amountCents_sum == otherTyped.amountCents_sum;
    
  }
  @override
  int get hashCode => Object.hashAll([paidAt.hashCode, amountCents_sum.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paidAt'] = paidAt.toJson();
    if (amountCents_sum != null) {
      json['amountCents_sum'] = bigIntToJson(amountCents_sum);
    }
    return json;
  }

  GetCashFlowSummaryLoanYearSeries({
    required this.paidAt,
    this.amountCents_sum,
  });
}

@immutable
class GetCashFlowSummaryData {
  final List<GetCashFlowSummaryMonth> month;
  final List<GetCashFlowSummaryYear> year;
  final List<GetCashFlowSummaryLifetime> lifetime;
  final List<GetCashFlowSummaryYearSeries> yearSeries;
  final List<GetCashFlowSummaryMonthPlanned> monthPlanned;
  final List<GetCashFlowSummaryYearPlanned> yearPlanned;
  final List<GetCashFlowSummaryLifetimePlanned> lifetimePlanned;
  final List<GetCashFlowSummaryYearPlannedSeries> yearPlannedSeries;
  final List<GetCashFlowSummaryCardMonth> cardMonth;
  final List<GetCashFlowSummaryCardYear> cardYear;
  final List<GetCashFlowSummaryCardLifetime> cardLifetime;
  final List<GetCashFlowSummaryCardYearSeries> cardYearSeries;
  final List<GetCashFlowSummaryLoanMonth> loanMonth;
  final List<GetCashFlowSummaryLoanYear> loanYear;
  final List<GetCashFlowSummaryLoanLifetime> loanLifetime;
  final List<GetCashFlowSummaryLoanYearSeries> loanYearSeries;
  GetCashFlowSummaryData.fromJson(dynamic json):
  
  month = (json['month'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryMonth.fromJson(e))
        .toList(),
  year = (json['year'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryYear.fromJson(e))
        .toList(),
  lifetime = (json['lifetime'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLifetime.fromJson(e))
        .toList(),
  yearSeries = (json['yearSeries'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryYearSeries.fromJson(e))
        .toList(),
  monthPlanned = (json['monthPlanned'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryMonthPlanned.fromJson(e))
        .toList(),
  yearPlanned = (json['yearPlanned'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryYearPlanned.fromJson(e))
        .toList(),
  lifetimePlanned = (json['lifetimePlanned'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLifetimePlanned.fromJson(e))
        .toList(),
  yearPlannedSeries = (json['yearPlannedSeries'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryYearPlannedSeries.fromJson(e))
        .toList(),
  cardMonth = (json['cardMonth'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryCardMonth.fromJson(e))
        .toList(),
  cardYear = (json['cardYear'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryCardYear.fromJson(e))
        .toList(),
  cardLifetime = (json['cardLifetime'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryCardLifetime.fromJson(e))
        .toList(),
  cardYearSeries = (json['cardYearSeries'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryCardYearSeries.fromJson(e))
        .toList(),
  loanMonth = (json['loanMonth'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLoanMonth.fromJson(e))
        .toList(),
  loanYear = (json['loanYear'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLoanYear.fromJson(e))
        .toList(),
  loanLifetime = (json['loanLifetime'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLoanLifetime.fromJson(e))
        .toList(),
  loanYearSeries = (json['loanYearSeries'] as List<dynamic>)
        .map((e) => GetCashFlowSummaryLoanYearSeries.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryData otherTyped = other as GetCashFlowSummaryData;
    return month == otherTyped.month && 
    year == otherTyped.year && 
    lifetime == otherTyped.lifetime && 
    yearSeries == otherTyped.yearSeries && 
    monthPlanned == otherTyped.monthPlanned && 
    yearPlanned == otherTyped.yearPlanned && 
    lifetimePlanned == otherTyped.lifetimePlanned && 
    yearPlannedSeries == otherTyped.yearPlannedSeries && 
    cardMonth == otherTyped.cardMonth && 
    cardYear == otherTyped.cardYear && 
    cardLifetime == otherTyped.cardLifetime && 
    cardYearSeries == otherTyped.cardYearSeries && 
    loanMonth == otherTyped.loanMonth && 
    loanYear == otherTyped.loanYear && 
    loanLifetime == otherTyped.loanLifetime && 
    loanYearSeries == otherTyped.loanYearSeries;
    
  }
  @override
  int get hashCode => Object.hashAll([month.hashCode, year.hashCode, lifetime.hashCode, yearSeries.hashCode, monthPlanned.hashCode, yearPlanned.hashCode, lifetimePlanned.hashCode, yearPlannedSeries.hashCode, cardMonth.hashCode, cardYear.hashCode, cardLifetime.hashCode, cardYearSeries.hashCode, loanMonth.hashCode, loanYear.hashCode, loanLifetime.hashCode, loanYearSeries.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['month'] = month.map((e) => e.toJson()).toList();
    json['year'] = year.map((e) => e.toJson()).toList();
    json['lifetime'] = lifetime.map((e) => e.toJson()).toList();
    json['yearSeries'] = yearSeries.map((e) => e.toJson()).toList();
    json['monthPlanned'] = monthPlanned.map((e) => e.toJson()).toList();
    json['yearPlanned'] = yearPlanned.map((e) => e.toJson()).toList();
    json['lifetimePlanned'] = lifetimePlanned.map((e) => e.toJson()).toList();
    json['yearPlannedSeries'] = yearPlannedSeries.map((e) => e.toJson()).toList();
    json['cardMonth'] = cardMonth.map((e) => e.toJson()).toList();
    json['cardYear'] = cardYear.map((e) => e.toJson()).toList();
    json['cardLifetime'] = cardLifetime.map((e) => e.toJson()).toList();
    json['cardYearSeries'] = cardYearSeries.map((e) => e.toJson()).toList();
    json['loanMonth'] = loanMonth.map((e) => e.toJson()).toList();
    json['loanYear'] = loanYear.map((e) => e.toJson()).toList();
    json['loanLifetime'] = loanLifetime.map((e) => e.toJson()).toList();
    json['loanYearSeries'] = loanYearSeries.map((e) => e.toJson()).toList();
    return json;
  }

  GetCashFlowSummaryData({
    required this.month,
    required this.year,
    required this.lifetime,
    required this.yearSeries,
    required this.monthPlanned,
    required this.yearPlanned,
    required this.lifetimePlanned,
    required this.yearPlannedSeries,
    required this.cardMonth,
    required this.cardYear,
    required this.cardLifetime,
    required this.cardYearSeries,
    required this.loanMonth,
    required this.loanYear,
    required this.loanLifetime,
    required this.loanYearSeries,
  });
}

@immutable
class GetCashFlowSummaryVariables {
  final String spaceId;
  final DateTime monthStart;
  final DateTime yearStart;
  final DateTime nextYearStart;
  final Timestamp monthStartedAt;
  final Timestamp nextMonthStartedAt;
  final Timestamp yearStartedAt;
  final Timestamp nextYearStartedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetCashFlowSummaryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  monthStart = nativeFromJson<DateTime>(json['monthStart']),
  yearStart = nativeFromJson<DateTime>(json['yearStart']),
  nextYearStart = nativeFromJson<DateTime>(json['nextYearStart']),
  monthStartedAt = Timestamp.fromJson(json['monthStartedAt']),
  nextMonthStartedAt = Timestamp.fromJson(json['nextMonthStartedAt']),
  yearStartedAt = Timestamp.fromJson(json['yearStartedAt']),
  nextYearStartedAt = Timestamp.fromJson(json['nextYearStartedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCashFlowSummaryVariables otherTyped = other as GetCashFlowSummaryVariables;
    return spaceId == otherTyped.spaceId && 
    monthStart == otherTyped.monthStart && 
    yearStart == otherTyped.yearStart && 
    nextYearStart == otherTyped.nextYearStart && 
    monthStartedAt == otherTyped.monthStartedAt && 
    nextMonthStartedAt == otherTyped.nextMonthStartedAt && 
    yearStartedAt == otherTyped.yearStartedAt && 
    nextYearStartedAt == otherTyped.nextYearStartedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, monthStart.hashCode, yearStart.hashCode, nextYearStart.hashCode, monthStartedAt.hashCode, nextMonthStartedAt.hashCode, yearStartedAt.hashCode, nextYearStartedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['monthStart'] = nativeToJson<DateTime>(monthStart);
    json['yearStart'] = nativeToJson<DateTime>(yearStart);
    json['nextYearStart'] = nativeToJson<DateTime>(nextYearStart);
    json['monthStartedAt'] = monthStartedAt.toJson();
    json['nextMonthStartedAt'] = nextMonthStartedAt.toJson();
    json['yearStartedAt'] = yearStartedAt.toJson();
    json['nextYearStartedAt'] = nextYearStartedAt.toJson();
    return json;
  }

  GetCashFlowSummaryVariables({
    required this.spaceId,
    required this.monthStart,
    required this.yearStart,
    required this.nextYearStart,
    required this.monthStartedAt,
    required this.nextMonthStartedAt,
    required this.yearStartedAt,
    required this.nextYearStartedAt,
  });
}

