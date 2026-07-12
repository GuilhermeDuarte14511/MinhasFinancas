part of 'client.dart';

class ListWorkspaceCashFlowHistoryVariablesBuilder {
  String spaceId;
  int limit;
  int offset;

  final FirebaseDataConnect _dataConnect;
  ListWorkspaceCashFlowHistoryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.limit,required  this.offset,});
  Deserializer<ListWorkspaceCashFlowHistoryData> dataDeserializer = (dynamic json)  => ListWorkspaceCashFlowHistoryData.fromJson(jsonDecode(json));
  Serializer<ListWorkspaceCashFlowHistoryVariables> varsSerializer = (ListWorkspaceCashFlowHistoryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListWorkspaceCashFlowHistoryData, ListWorkspaceCashFlowHistoryVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListWorkspaceCashFlowHistoryData, ListWorkspaceCashFlowHistoryVariables> ref() {
    ListWorkspaceCashFlowHistoryVariables vars= ListWorkspaceCashFlowHistoryVariables(spaceId: spaceId,limit: limit,offset: offset,);
    return _dataConnect.query("ListWorkspaceCashFlowHistory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListWorkspaceCashFlowHistoryCashFlowEntries {
  final String id;
  final EnumValue<CashFlowDirection> direction;
  final EnumValue<CashFlowKind> kind;
  final EnumValue<CashFlowPaymentMethod> paymentMethod;
  final String description;
  final BigInt amountCents;
  final Timestamp occurredAt;
  final DateTime competenceMonth;
  final String? notes;
  final EnumValue<CashFlowStatus> status;
  final int? occurrenceIndex;
  final bool isRecurrenceException;
  final Timestamp? receivedAt;
  final Timestamp? paidAt;
  final String? sourceType;
  final String? sourceEntityId;
  final ListWorkspaceCashFlowHistoryCashFlowEntriesCategory? category;
  final ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries? recurrenceSeries;
  final ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser createdByUser;
  ListWorkspaceCashFlowHistoryCashFlowEntries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  direction = cashFlowDirectionDeserializer(json['direction']),
  kind = cashFlowKindDeserializer(json['kind']),
  paymentMethod = cashFlowPaymentMethodDeserializer(json['paymentMethod']),
  description = nativeFromJson<String>(json['description']),
  amountCents = bigIntFromJson(json['amountCents']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  competenceMonth = nativeFromJson<DateTime>(json['competenceMonth']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  status = cashFlowStatusDeserializer(json['status']),
  occurrenceIndex = json['occurrenceIndex'] == null ? null : nativeFromJson<int>(json['occurrenceIndex']),
  isRecurrenceException = nativeFromJson<bool>(json['isRecurrenceException']),
  receivedAt = json['receivedAt'] == null ? null : Timestamp.fromJson(json['receivedAt']),
  paidAt = json['paidAt'] == null ? null : Timestamp.fromJson(json['paidAt']),
  sourceType = json['sourceType'] == null ? null : nativeFromJson<String>(json['sourceType']),
  sourceEntityId = json['sourceEntityId'] == null ? null : nativeFromJson<String>(json['sourceEntityId']),
  category = json['category'] == null ? null : ListWorkspaceCashFlowHistoryCashFlowEntriesCategory.fromJson(json['category']),
  recurrenceSeries = json['recurrenceSeries'] == null ? null : ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries.fromJson(json['recurrenceSeries']),
  createdByUser = ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser.fromJson(json['createdByUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryCashFlowEntries otherTyped = other as ListWorkspaceCashFlowHistoryCashFlowEntries;
    return id == otherTyped.id && 
    direction == otherTyped.direction && 
    kind == otherTyped.kind && 
    paymentMethod == otherTyped.paymentMethod && 
    description == otherTyped.description && 
    amountCents == otherTyped.amountCents && 
    occurredAt == otherTyped.occurredAt && 
    competenceMonth == otherTyped.competenceMonth && 
    notes == otherTyped.notes && 
    status == otherTyped.status && 
    occurrenceIndex == otherTyped.occurrenceIndex && 
    isRecurrenceException == otherTyped.isRecurrenceException && 
    receivedAt == otherTyped.receivedAt && 
    paidAt == otherTyped.paidAt && 
    sourceType == otherTyped.sourceType && 
    sourceEntityId == otherTyped.sourceEntityId && 
    category == otherTyped.category && 
    recurrenceSeries == otherTyped.recurrenceSeries && 
    createdByUser == otherTyped.createdByUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, direction.hashCode, kind.hashCode, paymentMethod.hashCode, description.hashCode, amountCents.hashCode, occurredAt.hashCode, competenceMonth.hashCode, notes.hashCode, status.hashCode, occurrenceIndex.hashCode, isRecurrenceException.hashCode, receivedAt.hashCode, paidAt.hashCode, sourceType.hashCode, sourceEntityId.hashCode, category.hashCode, recurrenceSeries.hashCode, createdByUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['direction'] = 
    cashFlowDirectionSerializer(direction)
    ;
    json['kind'] = 
    cashFlowKindSerializer(kind)
    ;
    json['paymentMethod'] = 
    cashFlowPaymentMethodSerializer(paymentMethod)
    ;
    json['description'] = nativeToJson<String>(description);
    json['amountCents'] = bigIntToJson(amountCents);
    json['occurredAt'] = occurredAt.toJson();
    json['competenceMonth'] = nativeToJson<DateTime>(competenceMonth);
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['status'] = 
    cashFlowStatusSerializer(status)
    ;
    if (occurrenceIndex != null) {
      json['occurrenceIndex'] = nativeToJson<int?>(occurrenceIndex);
    }
    json['isRecurrenceException'] = nativeToJson<bool>(isRecurrenceException);
    if (receivedAt != null) {
      json['receivedAt'] = receivedAt!.toJson();
    }
    if (paidAt != null) {
      json['paidAt'] = paidAt!.toJson();
    }
    if (sourceType != null) {
      json['sourceType'] = nativeToJson<String?>(sourceType);
    }
    if (sourceEntityId != null) {
      json['sourceEntityId'] = nativeToJson<String?>(sourceEntityId);
    }
    if (category != null) {
      json['category'] = category!.toJson();
    }
    if (recurrenceSeries != null) {
      json['recurrenceSeries'] = recurrenceSeries!.toJson();
    }
    json['createdByUser'] = createdByUser.toJson();
    return json;
  }

  ListWorkspaceCashFlowHistoryCashFlowEntries({
    required this.id,
    required this.direction,
    required this.kind,
    required this.paymentMethod,
    required this.description,
    required this.amountCents,
    required this.occurredAt,
    required this.competenceMonth,
    this.notes,
    required this.status,
    this.occurrenceIndex,
    required this.isRecurrenceException,
    this.receivedAt,
    this.paidAt,
    this.sourceType,
    this.sourceEntityId,
    this.category,
    this.recurrenceSeries,
    required this.createdByUser,
  });
}

@immutable
class ListWorkspaceCashFlowHistoryCashFlowEntriesCategory {
  final String id;
  final String name;
  ListWorkspaceCashFlowHistoryCashFlowEntriesCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryCashFlowEntriesCategory otherTyped = other as ListWorkspaceCashFlowHistoryCashFlowEntriesCategory;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListWorkspaceCashFlowHistoryCashFlowEntriesCategory({
    required this.id,
    required this.name,
  });
}

@immutable
class ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries {
  final String id;
  ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries otherTyped = other as ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListWorkspaceCashFlowHistoryCashFlowEntriesRecurrenceSeries({
    required this.id,
  });
}

@immutable
class ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser {
  final String displayName;
  ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser otherTyped = other as ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  ListWorkspaceCashFlowHistoryCashFlowEntriesCreatedByUser({
    required this.displayName,
  });
}

@immutable
class ListWorkspaceCashFlowHistoryData {
  final List<ListWorkspaceCashFlowHistoryCashFlowEntries> cashFlowEntries;
  ListWorkspaceCashFlowHistoryData.fromJson(dynamic json):
  
  cashFlowEntries = (json['cashFlowEntries'] as List<dynamic>)
        .map((e) => ListWorkspaceCashFlowHistoryCashFlowEntries.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryData otherTyped = other as ListWorkspaceCashFlowHistoryData;
    return cashFlowEntries == otherTyped.cashFlowEntries;
    
  }
  @override
  int get hashCode => cashFlowEntries.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cashFlowEntries'] = cashFlowEntries.map((e) => e.toJson()).toList();
    return json;
  }

  ListWorkspaceCashFlowHistoryData({
    required this.cashFlowEntries,
  });
}

@immutable
class ListWorkspaceCashFlowHistoryVariables {
  final String spaceId;
  final int limit;
  final int offset;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListWorkspaceCashFlowHistoryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  limit = nativeFromJson<int>(json['limit']),
  offset = nativeFromJson<int>(json['offset']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListWorkspaceCashFlowHistoryVariables otherTyped = other as ListWorkspaceCashFlowHistoryVariables;
    return spaceId == otherTyped.spaceId && 
    limit == otherTyped.limit && 
    offset == otherTyped.offset;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, limit.hashCode, offset.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['limit'] = nativeToJson<int>(limit);
    json['offset'] = nativeToJson<int>(offset);
    return json;
  }

  ListWorkspaceCashFlowHistoryVariables({
    required this.spaceId,
    required this.limit,
    required this.offset,
  });
}

