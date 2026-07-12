part of 'client.dart';

class CreateScheduledIncomeEntryVariablesBuilder {
  String spaceId;
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Timestamp occurredAt;
  DateTime competenceMonth;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;  CreateScheduledIncomeEntryVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  CreateScheduledIncomeEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  CreateScheduledIncomeEntryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.description,required  this.kind,required  this.paymentMethod,required  this.amountCents,required  this.occurredAt,required  this.competenceMonth,required  this.idempotencyKey,});
  Deserializer<CreateScheduledIncomeEntryData> dataDeserializer = (dynamic json)  => CreateScheduledIncomeEntryData.fromJson(jsonDecode(json));
  Serializer<CreateScheduledIncomeEntryVariables> varsSerializer = (CreateScheduledIncomeEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateScheduledIncomeEntryData, CreateScheduledIncomeEntryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateScheduledIncomeEntryData, CreateScheduledIncomeEntryVariables> ref() {
    CreateScheduledIncomeEntryVariables vars= CreateScheduledIncomeEntryVariables(spaceId: spaceId,categoryId: _categoryId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,notes: _notes,idempotencyKey: idempotencyKey,);
    return _dataConnect.mutation("CreateScheduledIncomeEntry", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateScheduledIncomeEntryEntry {
  final String id;
  CreateScheduledIncomeEntryEntry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateScheduledIncomeEntryEntry otherTyped = other as CreateScheduledIncomeEntryEntry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateScheduledIncomeEntryEntry({
    required this.id,
  });
}

@immutable
class CreateScheduledIncomeEntryAudit {
  final String id;
  CreateScheduledIncomeEntryAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateScheduledIncomeEntryAudit otherTyped = other as CreateScheduledIncomeEntryAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateScheduledIncomeEntryAudit({
    required this.id,
  });
}

@immutable
class CreateScheduledIncomeEntryData {
  final CreateScheduledIncomeEntryEntry entry;
  final CreateScheduledIncomeEntryAudit audit;
  CreateScheduledIncomeEntryData.fromJson(dynamic json):
  
  entry = CreateScheduledIncomeEntryEntry.fromJson(json['entry']),
  audit = CreateScheduledIncomeEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateScheduledIncomeEntryData otherTyped = other as CreateScheduledIncomeEntryData;
    return entry == otherTyped.entry && 
    audit == otherTyped.audit;
    
  }
  @override
  int get hashCode => Object.hashAll([entry.hashCode, audit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entry'] = entry.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  CreateScheduledIncomeEntryData({
    required this.entry,
    required this.audit,
  });
}

@immutable
class CreateScheduledIncomeEntryVariables {
  final String spaceId;
  late final Optional<String>categoryId;
  final String description;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  late final Optional<String>notes;
  final String idempotencyKey;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateScheduledIncomeEntryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  description = nativeFromJson<String>(json['description']),
  kind = CashFlowKind.values.byName(json['kind']),
  paymentMethod = CashFlowPaymentMethod.values.byName(json['paymentMethod']),
  amountCents = bigIntFromJson(json['amountCents']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
  
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
  
  
  
  
  
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateScheduledIncomeEntryVariables otherTyped = other as CreateScheduledIncomeEntryVariables;
    return spaceId == otherTyped.spaceId && 
    categoryId == otherTyped.categoryId && 
    description == otherTyped.description && 
    kind == otherTyped.kind && 
    paymentMethod == otherTyped.paymentMethod && 
    amountCents == otherTyped.amountCents && 
    occurredAt == otherTyped.occurredAt && 
    competenceMonth == otherTyped.competenceMonth && 
    notes == otherTyped.notes && 
    idempotencyKey == otherTyped.idempotencyKey;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, categoryId.hashCode, description.hashCode, kind.hashCode, paymentMethod.hashCode, amountCents.hashCode, occurredAt.hashCode, competenceMonth.hashCode, notes.hashCode, idempotencyKey.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    json['kind'] = 
    kind.name
    ;
    json['paymentMethod'] = 
    paymentMethod.name
    ;
    json['amountCents'] = bigIntToJson(amountCents);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['idempotencyKey'] = nativeToJson<String>(idempotencyKey);
    return json;
  }

  CreateScheduledIncomeEntryVariables({
    required this.spaceId,
    required this.categoryId,
    required this.description,
    required this.kind,
    required this.paymentMethod,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    required this.notes,
    required this.idempotencyKey,
  });
}

