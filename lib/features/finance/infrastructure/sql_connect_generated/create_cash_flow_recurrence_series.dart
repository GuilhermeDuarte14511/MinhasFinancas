part of 'client.dart';

class CreateCashFlowRecurrenceSeriesVariablesBuilder {
  String spaceId;
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);
  CashFlowDirection direction;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  String description;
  BigInt amountCents;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  CashFlowRecurrenceFrequency frequency;
  DateTime startDate;
  Optional<DateTime> _endDate = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _occurrenceLimit = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _preferredDay = Optional.optional(nativeFromJson, nativeToJson);
  Optional<DateTime> _nextOccurrenceDate = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;  CreateCashFlowRecurrenceSeriesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  CreateCashFlowRecurrenceSeriesVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  CreateCashFlowRecurrenceSeriesVariablesBuilder endDate(DateTime? t) {
   _endDate.value = t;
   return this;
  }
  CreateCashFlowRecurrenceSeriesVariablesBuilder occurrenceLimit(int? t) {
   _occurrenceLimit.value = t;
   return this;
  }
  CreateCashFlowRecurrenceSeriesVariablesBuilder preferredDay(int? t) {
   _preferredDay.value = t;
   return this;
  }
  CreateCashFlowRecurrenceSeriesVariablesBuilder nextOccurrenceDate(DateTime? t) {
   _nextOccurrenceDate.value = t;
   return this;
  }

  CreateCashFlowRecurrenceSeriesVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.direction,required  this.kind,required  this.paymentMethod,required  this.description,required  this.amountCents,required  this.frequency,required  this.startDate,required  this.idempotencyKey,});
  Deserializer<CreateCashFlowRecurrenceSeriesData> dataDeserializer = (dynamic json)  => CreateCashFlowRecurrenceSeriesData.fromJson(jsonDecode(json));
  Serializer<CreateCashFlowRecurrenceSeriesVariables> varsSerializer = (CreateCashFlowRecurrenceSeriesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCashFlowRecurrenceSeriesData, CreateCashFlowRecurrenceSeriesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateCashFlowRecurrenceSeriesData, CreateCashFlowRecurrenceSeriesVariables> ref() {
    CreateCashFlowRecurrenceSeriesVariables vars= CreateCashFlowRecurrenceSeriesVariables(spaceId: spaceId,categoryId: _categoryId,direction: direction,kind: kind,paymentMethod: paymentMethod,description: description,amountCents: amountCents,notes: _notes,frequency: frequency,startDate: startDate,endDate: _endDate,occurrenceLimit: _occurrenceLimit,preferredDay: _preferredDay,nextOccurrenceDate: _nextOccurrenceDate,idempotencyKey: idempotencyKey,);
    return _dataConnect.mutation("CreateCashFlowRecurrenceSeries", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateCashFlowRecurrenceSeriesSeries {
  final String id;
  CreateCashFlowRecurrenceSeriesSeries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCashFlowRecurrenceSeriesSeries otherTyped = other as CreateCashFlowRecurrenceSeriesSeries;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCashFlowRecurrenceSeriesSeries({
    required this.id,
  });
}

@immutable
class CreateCashFlowRecurrenceSeriesAudit {
  final String id;
  CreateCashFlowRecurrenceSeriesAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCashFlowRecurrenceSeriesAudit otherTyped = other as CreateCashFlowRecurrenceSeriesAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCashFlowRecurrenceSeriesAudit({
    required this.id,
  });
}

@immutable
class CreateCashFlowRecurrenceSeriesData {
  final CreateCashFlowRecurrenceSeriesSeries series;
  final CreateCashFlowRecurrenceSeriesAudit audit;
  CreateCashFlowRecurrenceSeriesData.fromJson(dynamic json):
  
  series = CreateCashFlowRecurrenceSeriesSeries.fromJson(json['series']),
  audit = CreateCashFlowRecurrenceSeriesAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCashFlowRecurrenceSeriesData otherTyped = other as CreateCashFlowRecurrenceSeriesData;
    return series == otherTyped.series && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([series.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['series'] = series.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateCashFlowRecurrenceSeriesData({
    required this.series,
    required this.audit,
  });
}

@immutable
class CreateCashFlowRecurrenceSeriesVariables {
  final String spaceId;
  late final Optional<String>categoryId;
  final CashFlowDirection direction;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final String description;
  final BigInt amountCents;
  late final Optional<String>notes;
  final CashFlowRecurrenceFrequency frequency;
  final DateTime startDate;
  late final Optional<DateTime>endDate;
  late final Optional<int>occurrenceLimit;
  late final Optional<int>preferredDay;
  late final Optional<DateTime>nextOccurrenceDate;
  final String idempotencyKey;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateCashFlowRecurrenceSeriesVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  direction = CashFlowDirection.values.byName(json['direction']),
  kind = CashFlowKind.values.byName(json['kind']),
  paymentMethod = CashFlowPaymentMethod.values.byName(json['paymentMethod']),
  description = nativeFromJson<String>(json['description']),
  amountCents = bigIntFromJson(json['amountCents']),
  frequency = CashFlowRecurrenceFrequency.values.byName(json['frequency']),
  startDate = nativeFromJson<DateTime>(json['startDate']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
  
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
  
  
  
  
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
  
  
    endDate = Optional.optional(nativeFromJson, nativeToJson);
    endDate.value = json['endDate'] == null ? null : nativeFromJson<DateTime>(json['endDate']);
  
  
    occurrenceLimit = Optional.optional(nativeFromJson, nativeToJson);
    occurrenceLimit.value = json['occurrenceLimit'] == null ? null : nativeFromJson<int>(json['occurrenceLimit']);
  
  
    preferredDay = Optional.optional(nativeFromJson, nativeToJson);
    preferredDay.value = json['preferredDay'] == null ? null : nativeFromJson<int>(json['preferredDay']);
  
  
    nextOccurrenceDate = Optional.optional(nativeFromJson, nativeToJson);
    nextOccurrenceDate.value = json['nextOccurrenceDate'] == null ? null : nativeFromJson<DateTime>(json['nextOccurrenceDate']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCashFlowRecurrenceSeriesVariables otherTyped = other as CreateCashFlowRecurrenceSeriesVariables;
    return spaceId == otherTyped.spaceId && 
    categoryId == otherTyped.categoryId && 
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
    idempotencyKey == otherTyped.idempotencyKey;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, categoryId.hashCode, direction.hashCode, kind.hashCode, paymentMethod.hashCode, description.hashCode, amountCents.hashCode, notes.hashCode, frequency.hashCode, startDate.hashCode, endDate.hashCode, occurrenceLimit.hashCode, preferredDay.hashCode, nextOccurrenceDate.hashCode, idempotencyKey.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    json['direction'] = 
    direction.name
    ;
    json['kind'] = 
    kind.name
    ;
    json['paymentMethod'] = 
    paymentMethod.name
    ;
    json['description'] = nativeToJson<String>(description);
    json['amountCents'] = bigIntToJson(amountCents);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['frequency'] = 
    frequency.name
    ;
    json['startDate'] = nativeToJson<DateTime>(startDate);
    if(endDate.state == OptionalState.set) {
      json['endDate'] = endDate.toJson();
    }
    if(occurrenceLimit.state == OptionalState.set) {
      json['occurrenceLimit'] = occurrenceLimit.toJson();
    }
    if(preferredDay.state == OptionalState.set) {
      json['preferredDay'] = preferredDay.toJson();
    }
    if(nextOccurrenceDate.state == OptionalState.set) {
      json['nextOccurrenceDate'] = nextOccurrenceDate.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  CreateCashFlowRecurrenceSeriesVariables({
    required this.spaceId,
    required this.categoryId,
    required this.direction,
    required this.kind,
    required this.paymentMethod,
    required this.description,
    required this.amountCents,
    required this.notes,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.occurrenceLimit,
    required this.preferredDay,
    required this.nextOccurrenceDate,
    required this.idempotencyKey,
  });
}

