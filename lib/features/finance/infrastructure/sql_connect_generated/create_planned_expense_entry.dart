part of 'client.dart';

class CreatePlannedExpenseEntryVariablesBuilder {
  String spaceId;
  String categoryId;
  Optional<String> _accountId = Optional.optional(nativeFromJson, nativeToJson);
  String description;
  CashFlowKind kind;
  CashFlowPaymentMethod paymentMethod;
  BigInt amountCents;
  Timestamp occurredAt;
  DateTime competenceMonth;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String idempotencyKey;

  final FirebaseDataConnect _dataConnect;  CreatePlannedExpenseEntryVariablesBuilder accountId(String? t) {
   _accountId.value = t;
   return this;
  }
  CreatePlannedExpenseEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  CreatePlannedExpenseEntryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.categoryId,required  this.description,required  this.kind,required  this.paymentMethod,required  this.amountCents,required  this.occurredAt,required  this.competenceMonth,required  this.idempotencyKey,});
  Deserializer<CreatePlannedExpenseEntryData> dataDeserializer = (dynamic json)  => CreatePlannedExpenseEntryData.fromJson(jsonDecode(json));
  Serializer<CreatePlannedExpenseEntryVariables> varsSerializer = (CreatePlannedExpenseEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePlannedExpenseEntryData, CreatePlannedExpenseEntryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePlannedExpenseEntryData, CreatePlannedExpenseEntryVariables> ref() {
    CreatePlannedExpenseEntryVariables vars= CreatePlannedExpenseEntryVariables(spaceId: spaceId,categoryId: categoryId,accountId: _accountId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,notes: _notes,idempotencyKey: idempotencyKey,);
    return _dataConnect.mutation("CreatePlannedExpenseEntry", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePlannedExpenseEntryEntry {
  final String id;
  CreatePlannedExpenseEntryEntry.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePlannedExpenseEntryEntry otherTyped = other as CreatePlannedExpenseEntryEntry;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePlannedExpenseEntryEntry({
    required this.id,
  });
}

@immutable
class CreatePlannedExpenseEntryAudit {
  final String id;
  CreatePlannedExpenseEntryAudit.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePlannedExpenseEntryAudit otherTyped = other as CreatePlannedExpenseEntryAudit;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePlannedExpenseEntryAudit({
    required this.id,
  });
}

@immutable
class CreatePlannedExpenseEntryData {
  final CreatePlannedExpenseEntryEntry entry;
  final CreatePlannedExpenseEntryAudit audit;
  CreatePlannedExpenseEntryData.fromJson(dynamic json):
  
  entry = CreatePlannedExpenseEntryEntry.fromJson(json['entry']),
  audit = CreatePlannedExpenseEntryAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePlannedExpenseEntryData otherTyped = other as CreatePlannedExpenseEntryData;
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

  CreatePlannedExpenseEntryData({
    required this.entry,
    required this.audit,
  });
}

@immutable
class CreatePlannedExpenseEntryVariables {
  final String spaceId;
  final String categoryId;
  late final Optional<String>accountId;
  final String description;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  late final Optional<String>notes;
  final String idempotencyKey;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePlannedExpenseEntryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  categoryId = nativeFromJson<String>(json['categoryId']),
  description = nativeFromJson<String>(json['description']),
  kind = CashFlowKind.values.byName(json['kind']),
  paymentMethod = CashFlowPaymentMethod.values.byName(json['paymentMethod']),
  amountCents = bigIntFromJson(json['amountCents']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  idempotencyKey = nativeFromJson<String>(json['idempotencyKey']) {
  
  
  
  
    accountId = Optional.optional(nativeFromJson, nativeToJson);
    accountId.value = json['accountId'] == null ? null : nativeFromJson<String>(json['accountId']);
  
  
  
  
  
  
  
  
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

    final CreatePlannedExpenseEntryVariables otherTyped = other as CreatePlannedExpenseEntryVariables;
    return spaceId == otherTyped.spaceId && 
    categoryId == otherTyped.categoryId && 
    accountId == otherTyped.accountId && 
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
  int get hashCode => Object.hashAll([spaceId.hashCode, categoryId.hashCode, accountId.hashCode, description.hashCode, kind.hashCode, paymentMethod.hashCode, amountCents.hashCode, occurredAt.hashCode, competenceMonth.hashCode, notes.hashCode, idempotencyKey.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    if(accountId.state == OptionalState.set) {
      json['accountId'] = accountId.toJson();
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

  CreatePlannedExpenseEntryVariables({
    required this.spaceId,
    required this.categoryId,
    required this.accountId,
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

