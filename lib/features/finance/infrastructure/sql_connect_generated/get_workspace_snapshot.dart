part of 'client.dart';

class GetWorkspaceSnapshotVariablesBuilder {
  String spaceId;

  final FirebaseDataConnect _dataConnect;
  GetWorkspaceSnapshotVariablesBuilder(this._dataConnect, {required  this.spaceId,});
  Deserializer<GetWorkspaceSnapshotData> dataDeserializer = (dynamic json)  => GetWorkspaceSnapshotData.fromJson(jsonDecode(json));
  Serializer<GetWorkspaceSnapshotVariables> varsSerializer = (GetWorkspaceSnapshotVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetWorkspaceSnapshotData, GetWorkspaceSnapshotVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetWorkspaceSnapshotData, GetWorkspaceSnapshotVariables> ref() {
    GetWorkspaceSnapshotVariables vars= GetWorkspaceSnapshotVariables(spaceId: spaceId,);
    return _dataConnect.query("GetWorkspaceSnapshot", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetWorkspaceSnapshotFinancialSpace {
  final String id;
  final String name;
  final String colorHex;
  final String currencyCode;
  final String timezone;
  final Timestamp updatedAt;
  GetWorkspaceSnapshotFinancialSpace.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  colorHex = nativeFromJson<String>(json['colorHex']),
  currencyCode = nativeFromJson<String>(json['currencyCode']),
  timezone = nativeFromJson<String>(json['timezone']),
  updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotFinancialSpace otherTyped = other as GetWorkspaceSnapshotFinancialSpace;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    colorHex == otherTyped.colorHex && 
    currencyCode == otherTyped.currencyCode && 
    timezone == otherTyped.timezone && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, colorHex.hashCode, currencyCode.hashCode, timezone.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['currencyCode'] = nativeToJson<String>(currencyCode);
    json['timezone'] = nativeToJson<String>(timezone);
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  GetWorkspaceSnapshotFinancialSpace({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.currencyCode,
    required this.timezone,
    required this.updatedAt,
  });
}

@immutable
class GetWorkspaceSnapshotSpaceMembers {
  final String id;
  final String memberFirebaseUid;
  final EnumValue<MembershipRole> role;
  final EnumValue<MembershipStatus> status;
  final Timestamp? joinedAt;
  final GetWorkspaceSnapshotSpaceMembersUser user;
  GetWorkspaceSnapshotSpaceMembers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  memberFirebaseUid = nativeFromJson<String>(json['memberFirebaseUid']),
  role = membershipRoleDeserializer(json['role']),
  status = membershipStatusDeserializer(json['status']),
  joinedAt = json['joinedAt'] == null ? null : Timestamp.fromJson(json['joinedAt']),
  user = GetWorkspaceSnapshotSpaceMembersUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotSpaceMembers otherTyped = other as GetWorkspaceSnapshotSpaceMembers;
    return id == otherTyped.id && 
    memberFirebaseUid == otherTyped.memberFirebaseUid && 
    role == otherTyped.role && 
    status == otherTyped.status && 
    joinedAt == otherTyped.joinedAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, memberFirebaseUid.hashCode, role.hashCode, status.hashCode, joinedAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['memberFirebaseUid'] = nativeToJson<String>(memberFirebaseUid);
    json['role'] = 
    membershipRoleSerializer(role)
    ;
    json['status'] = 
    membershipStatusSerializer(status)
    ;
    if (joinedAt != null) {
      json['joinedAt'] = joinedAt!.toJson();
    }
    json['user'] = user.toJson();
    return json;
  }

  GetWorkspaceSnapshotSpaceMembers({
    required this.id,
    required this.memberFirebaseUid,
    required this.role,
    required this.status,
    this.joinedAt,
    required this.user,
  });
}

@immutable
class GetWorkspaceSnapshotSpaceMembersUser {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  GetWorkspaceSnapshotSpaceMembersUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  displayName = nativeFromJson<String>(json['displayName']),
  email = nativeFromJson<String>(json['email']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotSpaceMembersUser otherTyped = other as GetWorkspaceSnapshotSpaceMembersUser;
    return id == otherTyped.id && 
    displayName == otherTyped.displayName && 
    email == otherTyped.email && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, displayName.hashCode, email.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['displayName'] = nativeToJson<String>(displayName);
    json['email'] = nativeToJson<String>(email);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    return json;
  }

  GetWorkspaceSnapshotSpaceMembersUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
}

@immutable
class GetWorkspaceSnapshotCategories {
  final String id;
  final String name;
  final String normalizedName;
  final String icon;
  final String colorHex;
  final bool isDefault;
  GetWorkspaceSnapshotCategories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  normalizedName = nativeFromJson<String>(json['normalizedName']),
  icon = nativeFromJson<String>(json['icon']),
  colorHex = nativeFromJson<String>(json['colorHex']),
  isDefault = nativeFromJson<bool>(json['isDefault']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCategories otherTyped = other as GetWorkspaceSnapshotCategories;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    normalizedName == otherTyped.normalizedName && 
    icon == otherTyped.icon && 
    colorHex == otherTyped.colorHex && 
    isDefault == otherTyped.isDefault;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, normalizedName.hashCode, icon.hashCode, colorHex.hashCode, isDefault.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['normalizedName'] = nativeToJson<String>(normalizedName);
    json['icon'] = nativeToJson<String>(icon);
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['isDefault'] = nativeToJson<bool>(isDefault);
    return json;
  }

  GetWorkspaceSnapshotCategories({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
  });
}

@immutable
class GetWorkspaceSnapshotCreditCards {
  final String id;
  final String nickname;
  final String? institutionName;
  final String? brand;
  final String lastFourDigits;
  final BigInt creditLimitCents;
  final int closingDay;
  final int dueDay;
  final String colorHex;
  final bool remindersEnabled;
  final EnumValue<CreditCardStatus> status;
  final GetWorkspaceSnapshotCreditCardsCardholderMember cardholderMember;
  GetWorkspaceSnapshotCreditCards.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nickname = nativeFromJson<String>(json['nickname']),
  institutionName = json['institutionName'] == null ? null : nativeFromJson<String>(json['institutionName']),
  brand = json['brand'] == null ? null : nativeFromJson<String>(json['brand']),
  lastFourDigits = nativeFromJson<String>(json['lastFourDigits']),
  creditLimitCents = bigIntFromJson(json['creditLimitCents']),
  closingDay = nativeFromJson<int>(json['closingDay']),
  dueDay = nativeFromJson<int>(json['dueDay']),
  colorHex = nativeFromJson<String>(json['colorHex']),
  remindersEnabled = nativeFromJson<bool>(json['remindersEnabled']),
  status = creditCardStatusDeserializer(json['status']),
  cardholderMember = GetWorkspaceSnapshotCreditCardsCardholderMember.fromJson(json['cardholderMember']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCreditCards otherTyped = other as GetWorkspaceSnapshotCreditCards;
    return id == otherTyped.id && 
    nickname == otherTyped.nickname && 
    institutionName == otherTyped.institutionName && 
    brand == otherTyped.brand && 
    lastFourDigits == otherTyped.lastFourDigits && 
    creditLimitCents == otherTyped.creditLimitCents && 
    closingDay == otherTyped.closingDay && 
    dueDay == otherTyped.dueDay && 
    colorHex == otherTyped.colorHex && 
    remindersEnabled == otherTyped.remindersEnabled && 
    status == otherTyped.status && 
    cardholderMember == otherTyped.cardholderMember;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nickname.hashCode, institutionName.hashCode, brand.hashCode, lastFourDigits.hashCode, creditLimitCents.hashCode, closingDay.hashCode, dueDay.hashCode, colorHex.hashCode, remindersEnabled.hashCode, status.hashCode, cardholderMember.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nickname'] = nativeToJson<String>(nickname);
    if (institutionName != null) {
      json['institutionName'] = nativeToJson<String?>(institutionName);
    }
    if (brand != null) {
      json['brand'] = nativeToJson<String?>(brand);
    }
    json['lastFourDigits'] = nativeToJson<String>(lastFourDigits);
    json['creditLimitCents'] = bigIntToJson(creditLimitCents);
    json['closingDay'] = nativeToJson<int>(closingDay);
    json['dueDay'] = nativeToJson<int>(dueDay);
    json['colorHex'] = nativeToJson<String>(colorHex);
    json['remindersEnabled'] = nativeToJson<bool>(remindersEnabled);
    json['status'] = 
    creditCardStatusSerializer(status)
    ;
    json['cardholderMember'] = cardholderMember.toJson();
    return json;
  }

  GetWorkspaceSnapshotCreditCards({
    required this.id,
    required this.nickname,
    this.institutionName,
    this.brand,
    required this.lastFourDigits,
    required this.creditLimitCents,
    required this.closingDay,
    required this.dueDay,
    required this.colorHex,
    required this.remindersEnabled,
    required this.status,
    required this.cardholderMember,
  });
}

@immutable
class GetWorkspaceSnapshotCreditCardsCardholderMember {
  final String id;
  final GetWorkspaceSnapshotCreditCardsCardholderMemberUser user;
  GetWorkspaceSnapshotCreditCardsCardholderMember.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  user = GetWorkspaceSnapshotCreditCardsCardholderMemberUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCreditCardsCardholderMember otherTyped = other as GetWorkspaceSnapshotCreditCardsCardholderMember;
    return id == otherTyped.id && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['user'] = user.toJson();
    return json;
  }

  GetWorkspaceSnapshotCreditCardsCardholderMember({
    required this.id,
    required this.user,
  });
}

@immutable
class GetWorkspaceSnapshotCreditCardsCardholderMemberUser {
  final String displayName;
  GetWorkspaceSnapshotCreditCardsCardholderMemberUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCreditCardsCardholderMemberUser otherTyped = other as GetWorkspaceSnapshotCreditCardsCardholderMemberUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetWorkspaceSnapshotCreditCardsCardholderMemberUser({
    required this.displayName,
  });
}

@immutable
class GetWorkspaceSnapshotPurchases {
  final String id;
  final String description;
  final String? merchantName;
  final BigInt totalAmountCents;
  final DateTime purchaseDate;
  final int installmentCount;
  final DateTime firstInvoiceReference;
  final String? notes;
  final EnumValue<PurchaseStatus> status;
  final GetWorkspaceSnapshotPurchasesCreditCard creditCard;
  final GetWorkspaceSnapshotPurchasesCategory category;
  final GetWorkspaceSnapshotPurchasesCreatedByUser createdByUser;
  GetWorkspaceSnapshotPurchases.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  description = nativeFromJson<String>(json['description']),
  merchantName = json['merchantName'] == null ? null : nativeFromJson<String>(json['merchantName']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  purchaseDate = nativeFromJson<DateTime>(json['purchaseDate']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  firstInvoiceReference = nativeFromJson<DateTime>(json['firstInvoiceReference']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  status = purchaseStatusDeserializer(json['status']),
  creditCard = GetWorkspaceSnapshotPurchasesCreditCard.fromJson(json['creditCard']),
  category = GetWorkspaceSnapshotPurchasesCategory.fromJson(json['category']),
  createdByUser = GetWorkspaceSnapshotPurchasesCreatedByUser.fromJson(json['createdByUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchases otherTyped = other as GetWorkspaceSnapshotPurchases;
    return id == otherTyped.id && 
    description == otherTyped.description && 
    merchantName == otherTyped.merchantName && 
    totalAmountCents == otherTyped.totalAmountCents && 
    purchaseDate == otherTyped.purchaseDate && 
    installmentCount == otherTyped.installmentCount && 
    firstInvoiceReference == otherTyped.firstInvoiceReference && 
    notes == otherTyped.notes && 
    status == otherTyped.status && 
    creditCard == otherTyped.creditCard && 
    category == otherTyped.category && 
    createdByUser == otherTyped.createdByUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, description.hashCode, merchantName.hashCode, totalAmountCents.hashCode, purchaseDate.hashCode, installmentCount.hashCode, firstInvoiceReference.hashCode, notes.hashCode, status.hashCode, creditCard.hashCode, category.hashCode, createdByUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['description'] = nativeToJson<String>(description);
    if (merchantName != null) {
      json['merchantName'] = nativeToJson<String?>(merchantName);
    }
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['purchaseDate'] = nativeToJson<DateTime>(purchaseDate);
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    json['firstInvoiceReference'] = nativeToJson<DateTime>(firstInvoiceReference);
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['status'] = 
    purchaseStatusSerializer(status)
    ;
    json['creditCard'] = creditCard.toJson();
    json['category'] = category.toJson();
    json['createdByUser'] = createdByUser.toJson();
    return json;
  }

  GetWorkspaceSnapshotPurchases({
    required this.id,
    required this.description,
    this.merchantName,
    required this.totalAmountCents,
    required this.purchaseDate,
    required this.installmentCount,
    required this.firstInvoiceReference,
    this.notes,
    required this.status,
    required this.creditCard,
    required this.category,
    required this.createdByUser,
  });
}

@immutable
class GetWorkspaceSnapshotPurchasesCreditCard {
  final String id;
  GetWorkspaceSnapshotPurchasesCreditCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchasesCreditCard otherTyped = other as GetWorkspaceSnapshotPurchasesCreditCard;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWorkspaceSnapshotPurchasesCreditCard({
    required this.id,
  });
}

@immutable
class GetWorkspaceSnapshotPurchasesCategory {
  final String id;
  final String name;
  GetWorkspaceSnapshotPurchasesCategory.fromJson(dynamic json):
  
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

    final GetWorkspaceSnapshotPurchasesCategory otherTyped = other as GetWorkspaceSnapshotPurchasesCategory;
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

  GetWorkspaceSnapshotPurchasesCategory({
    required this.id,
    required this.name,
  });
}

@immutable
class GetWorkspaceSnapshotPurchasesCreatedByUser {
  final String id;
  final String displayName;
  GetWorkspaceSnapshotPurchasesCreatedByUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchasesCreatedByUser otherTyped = other as GetWorkspaceSnapshotPurchasesCreatedByUser;
    return id == otherTyped.id && 
    displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, displayName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetWorkspaceSnapshotPurchasesCreatedByUser({
    required this.id,
    required this.displayName,
  });
}

@immutable
class GetWorkspaceSnapshotCreditCardInvoices {
  final String id;
  final DateTime referenceMonth;
  final DateTime closingDate;
  final DateTime dueDate;
  final EnumValue<InvoiceStatus> status;
  final BigInt totalAmountCents;
  final BigInt paidAmountCents;
  final GetWorkspaceSnapshotCreditCardInvoicesCreditCard creditCard;
  GetWorkspaceSnapshotCreditCardInvoices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  referenceMonth = nativeFromJson<DateTime>(json['referenceMonth']),
  closingDate = nativeFromJson<DateTime>(json['closingDate']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  status = invoiceStatusDeserializer(json['status']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  paidAmountCents = bigIntFromJson(json['paidAmountCents']),
  creditCard = GetWorkspaceSnapshotCreditCardInvoicesCreditCard.fromJson(json['creditCard']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCreditCardInvoices otherTyped = other as GetWorkspaceSnapshotCreditCardInvoices;
    return id == otherTyped.id && 
    referenceMonth == otherTyped.referenceMonth && 
    closingDate == otherTyped.closingDate && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    totalAmountCents == otherTyped.totalAmountCents && 
    paidAmountCents == otherTyped.paidAmountCents && 
    creditCard == otherTyped.creditCard;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, referenceMonth.hashCode, closingDate.hashCode, dueDate.hashCode, status.hashCode, totalAmountCents.hashCode, paidAmountCents.hashCode, creditCard.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['referenceMonth'] = nativeToJson<DateTime>(referenceMonth);
    json['closingDate'] = nativeToJson<DateTime>(closingDate);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['status'] = 
    invoiceStatusSerializer(status)
    ;
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['paidAmountCents'] = bigIntToJson(paidAmountCents);
    json['creditCard'] = creditCard.toJson();
    return json;
  }

  GetWorkspaceSnapshotCreditCardInvoices({
    required this.id,
    required this.referenceMonth,
    required this.closingDate,
    required this.dueDate,
    required this.status,
    required this.totalAmountCents,
    required this.paidAmountCents,
    required this.creditCard,
  });
}

@immutable
class GetWorkspaceSnapshotCreditCardInvoicesCreditCard {
  final String id;
  final String nickname;
  GetWorkspaceSnapshotCreditCardInvoicesCreditCard.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nickname = nativeFromJson<String>(json['nickname']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotCreditCardInvoicesCreditCard otherTyped = other as GetWorkspaceSnapshotCreditCardInvoicesCreditCard;
    return id == otherTyped.id && 
    nickname == otherTyped.nickname;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nickname.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nickname'] = nativeToJson<String>(nickname);
    return json;
  }

  GetWorkspaceSnapshotCreditCardInvoicesCreditCard({
    required this.id,
    required this.nickname,
  });
}

@immutable
class GetWorkspaceSnapshotPurchaseInstallments {
  final String id;
  final int installmentNumber;
  final int installmentCount;
  final BigInt amountCents;
  final DateTime dueDate;
  final EnumValue<InstallmentStatus> status;
  final GetWorkspaceSnapshotPurchaseInstallmentsPurchase purchase;
  final GetWorkspaceSnapshotPurchaseInstallmentsInvoice invoice;
  GetWorkspaceSnapshotPurchaseInstallments.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  installmentNumber = nativeFromJson<int>(json['installmentNumber']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  amountCents = bigIntFromJson(json['amountCents']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  status = installmentStatusDeserializer(json['status']),
  purchase = GetWorkspaceSnapshotPurchaseInstallmentsPurchase.fromJson(json['purchase']),
  invoice = GetWorkspaceSnapshotPurchaseInstallmentsInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchaseInstallments otherTyped = other as GetWorkspaceSnapshotPurchaseInstallments;
    return id == otherTyped.id && 
    installmentNumber == otherTyped.installmentNumber && 
    installmentCount == otherTyped.installmentCount && 
    amountCents == otherTyped.amountCents && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    purchase == otherTyped.purchase && 
    invoice == otherTyped.invoice;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, installmentNumber.hashCode, installmentCount.hashCode, amountCents.hashCode, dueDate.hashCode, status.hashCode, purchase.hashCode, invoice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    json['amountCents'] = bigIntToJson(amountCents);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['status'] = 
    installmentStatusSerializer(status)
    ;
    json['purchase'] = purchase.toJson();
    json['invoice'] = invoice.toJson();
    return json;
  }

  GetWorkspaceSnapshotPurchaseInstallments({
    required this.id,
    required this.installmentNumber,
    required this.installmentCount,
    required this.amountCents,
    required this.dueDate,
    required this.status,
    required this.purchase,
    required this.invoice,
  });
}

@immutable
class GetWorkspaceSnapshotPurchaseInstallmentsPurchase {
  final String id;
  GetWorkspaceSnapshotPurchaseInstallmentsPurchase.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchaseInstallmentsPurchase otherTyped = other as GetWorkspaceSnapshotPurchaseInstallmentsPurchase;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWorkspaceSnapshotPurchaseInstallmentsPurchase({
    required this.id,
  });
}

@immutable
class GetWorkspaceSnapshotPurchaseInstallmentsInvoice {
  final String id;
  GetWorkspaceSnapshotPurchaseInstallmentsInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotPurchaseInstallmentsInvoice otherTyped = other as GetWorkspaceSnapshotPurchaseInstallmentsInvoice;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWorkspaceSnapshotPurchaseInstallmentsInvoice({
    required this.id,
  });
}

@immutable
class GetWorkspaceSnapshotInvoicePayments {
  final String id;
  final BigInt amountCents;
  final Timestamp paidAt;
  final String? notes;
  final EnumValue<PaymentStatus> status;
  final GetWorkspaceSnapshotInvoicePaymentsInvoice invoice;
  final GetWorkspaceSnapshotInvoicePaymentsCreatedByUser createdByUser;
  GetWorkspaceSnapshotInvoicePayments.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  amountCents = bigIntFromJson(json['amountCents']),
  paidAt = Timestamp.fromJson(json['paidAt']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  status = paymentStatusDeserializer(json['status']),
  invoice = GetWorkspaceSnapshotInvoicePaymentsInvoice.fromJson(json['invoice']),
  createdByUser = GetWorkspaceSnapshotInvoicePaymentsCreatedByUser.fromJson(json['createdByUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotInvoicePayments otherTyped = other as GetWorkspaceSnapshotInvoicePayments;
    return id == otherTyped.id && 
    amountCents == otherTyped.amountCents && 
    paidAt == otherTyped.paidAt && 
    notes == otherTyped.notes && 
    status == otherTyped.status && 
    invoice == otherTyped.invoice && 
    createdByUser == otherTyped.createdByUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, amountCents.hashCode, paidAt.hashCode, notes.hashCode, status.hashCode, invoice.hashCode, createdByUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['amountCents'] = bigIntToJson(amountCents);
    json['paidAt'] = paidAt.toJson();
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['status'] = 
    paymentStatusSerializer(status)
    ;
    json['invoice'] = invoice.toJson();
    json['createdByUser'] = createdByUser.toJson();
    return json;
  }

  GetWorkspaceSnapshotInvoicePayments({
    required this.id,
    required this.amountCents,
    required this.paidAt,
    this.notes,
    required this.status,
    required this.invoice,
    required this.createdByUser,
  });
}

@immutable
class GetWorkspaceSnapshotInvoicePaymentsInvoice {
  final String id;
  GetWorkspaceSnapshotInvoicePaymentsInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotInvoicePaymentsInvoice otherTyped = other as GetWorkspaceSnapshotInvoicePaymentsInvoice;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWorkspaceSnapshotInvoicePaymentsInvoice({
    required this.id,
  });
}

@immutable
class GetWorkspaceSnapshotInvoicePaymentsCreatedByUser {
  final String displayName;
  GetWorkspaceSnapshotInvoicePaymentsCreatedByUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotInvoicePaymentsCreatedByUser otherTyped = other as GetWorkspaceSnapshotInvoicePaymentsCreatedByUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetWorkspaceSnapshotInvoicePaymentsCreatedByUser({
    required this.displayName,
  });
}

@immutable
class GetWorkspaceSnapshotLoans {
  final String id;
  final String name;
  final String? lender;
  final BigInt principalAmountCents;
  final BigInt monthlyInterestRateMicros;
  final EnumValue<LoanAmortizationMethod> amortizationMethod;
  final int installmentCount;
  final DateTime? contractedAt;
  final DateTime firstDueDate;
  final BigInt? expectedInstallmentAmountCents;
  final String? notes;
  final EnumValue<LoanStatus> status;
  final GetWorkspaceSnapshotLoansCreatedByUser createdByUser;
  GetWorkspaceSnapshotLoans.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  lender = json['lender'] == null ? null : nativeFromJson<String>(json['lender']),
  principalAmountCents = bigIntFromJson(json['principalAmountCents']),
  monthlyInterestRateMicros = bigIntFromJson(json['monthlyInterestRateMicros']),
  amortizationMethod = loanAmortizationMethodDeserializer(json['amortizationMethod']),
  installmentCount = nativeFromJson<int>(json['installmentCount']),
  contractedAt = json['contractedAt'] == null ? null : nativeFromJson<DateTime>(json['contractedAt']),
  firstDueDate = nativeFromJson<DateTime>(json['firstDueDate']),
  expectedInstallmentAmountCents = json['expectedInstallmentAmountCents'] == null ? null : bigIntFromJson(json['expectedInstallmentAmountCents']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  status = loanStatusDeserializer(json['status']),
  createdByUser = GetWorkspaceSnapshotLoansCreatedByUser.fromJson(json['createdByUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotLoans otherTyped = other as GetWorkspaceSnapshotLoans;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    lender == otherTyped.lender && 
    principalAmountCents == otherTyped.principalAmountCents && 
    monthlyInterestRateMicros == otherTyped.monthlyInterestRateMicros && 
    amortizationMethod == otherTyped.amortizationMethod && 
    installmentCount == otherTyped.installmentCount && 
    contractedAt == otherTyped.contractedAt && 
    firstDueDate == otherTyped.firstDueDate && 
    expectedInstallmentAmountCents == otherTyped.expectedInstallmentAmountCents && 
    notes == otherTyped.notes && 
    status == otherTyped.status && 
    createdByUser == otherTyped.createdByUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, lender.hashCode, principalAmountCents.hashCode, monthlyInterestRateMicros.hashCode, amortizationMethod.hashCode, installmentCount.hashCode, contractedAt.hashCode, firstDueDate.hashCode, expectedInstallmentAmountCents.hashCode, notes.hashCode, status.hashCode, createdByUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (lender != null) {
      json['lender'] = nativeToJson<String?>(lender);
    }
    json['principalAmountCents'] = bigIntToJson(principalAmountCents);
    json['monthlyInterestRateMicros'] = bigIntToJson(monthlyInterestRateMicros);
    json['amortizationMethod'] = 
    loanAmortizationMethodSerializer(amortizationMethod)
    ;
    json['installmentCount'] = nativeToJson<int>(installmentCount);
    if (contractedAt != null) {
      json['contractedAt'] = nativeToJson<DateTime?>(contractedAt);
    }
    json['firstDueDate'] = nativeToJson<DateTime>(firstDueDate);
    if (expectedInstallmentAmountCents != null) {
      json['expectedInstallmentAmountCents'] = bigIntToJson(expectedInstallmentAmountCents);
    }
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['status'] = 
    loanStatusSerializer(status)
    ;
    json['createdByUser'] = createdByUser.toJson();
    return json;
  }

  GetWorkspaceSnapshotLoans({
    required this.id,
    required this.name,
    this.lender,
    required this.principalAmountCents,
    required this.monthlyInterestRateMicros,
    required this.amortizationMethod,
    required this.installmentCount,
    this.contractedAt,
    required this.firstDueDate,
    this.expectedInstallmentAmountCents,
    this.notes,
    required this.status,
    required this.createdByUser,
  });
}

@immutable
class GetWorkspaceSnapshotLoansCreatedByUser {
  final String displayName;
  GetWorkspaceSnapshotLoansCreatedByUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotLoansCreatedByUser otherTyped = other as GetWorkspaceSnapshotLoansCreatedByUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetWorkspaceSnapshotLoansCreatedByUser({
    required this.displayName,
  });
}

@immutable
class GetWorkspaceSnapshotLoanInstallments {
  final String id;
  final int installmentNumber;
  final DateTime dueDate;
  final BigInt openingBalanceCents;
  final BigInt principalAmountCents;
  final BigInt interestAmountCents;
  final BigInt totalAmountCents;
  final BigInt paidAmountCents;
  final EnumValue<LoanInstallmentStatus> status;
  final GetWorkspaceSnapshotLoanInstallmentsLoan loan;
  GetWorkspaceSnapshotLoanInstallments.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  installmentNumber = nativeFromJson<int>(json['installmentNumber']),
  dueDate = nativeFromJson<DateTime>(json['dueDate']),
  openingBalanceCents = bigIntFromJson(json['openingBalanceCents']),
  principalAmountCents = bigIntFromJson(json['principalAmountCents']),
  interestAmountCents = bigIntFromJson(json['interestAmountCents']),
  totalAmountCents = bigIntFromJson(json['totalAmountCents']),
  paidAmountCents = bigIntFromJson(json['paidAmountCents']),
  status = loanInstallmentStatusDeserializer(json['status']),
  loan = GetWorkspaceSnapshotLoanInstallmentsLoan.fromJson(json['loan']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotLoanInstallments otherTyped = other as GetWorkspaceSnapshotLoanInstallments;
    return id == otherTyped.id && 
    installmentNumber == otherTyped.installmentNumber && 
    dueDate == otherTyped.dueDate && 
    openingBalanceCents == otherTyped.openingBalanceCents && 
    principalAmountCents == otherTyped.principalAmountCents && 
    interestAmountCents == otherTyped.interestAmountCents && 
    totalAmountCents == otherTyped.totalAmountCents && 
    paidAmountCents == otherTyped.paidAmountCents && 
    status == otherTyped.status && 
    loan == otherTyped.loan;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, installmentNumber.hashCode, dueDate.hashCode, openingBalanceCents.hashCode, principalAmountCents.hashCode, interestAmountCents.hashCode, totalAmountCents.hashCode, paidAmountCents.hashCode, status.hashCode, loan.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['installmentNumber'] = nativeToJson<int>(installmentNumber);
    json['dueDate'] = nativeToJson<DateTime>(dueDate);
    json['openingBalanceCents'] = bigIntToJson(openingBalanceCents);
    json['principalAmountCents'] = bigIntToJson(principalAmountCents);
    json['interestAmountCents'] = bigIntToJson(interestAmountCents);
    json['totalAmountCents'] = bigIntToJson(totalAmountCents);
    json['paidAmountCents'] = bigIntToJson(paidAmountCents);
    json['status'] = 
    loanInstallmentStatusSerializer(status)
    ;
    json['loan'] = loan.toJson();
    return json;
  }

  GetWorkspaceSnapshotLoanInstallments({
    required this.id,
    required this.installmentNumber,
    required this.dueDate,
    required this.openingBalanceCents,
    required this.principalAmountCents,
    required this.interestAmountCents,
    required this.totalAmountCents,
    required this.paidAmountCents,
    required this.status,
    required this.loan,
  });
}

@immutable
class GetWorkspaceSnapshotLoanInstallmentsLoan {
  final String id;
  GetWorkspaceSnapshotLoanInstallmentsLoan.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotLoanInstallmentsLoan otherTyped = other as GetWorkspaceSnapshotLoanInstallmentsLoan;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetWorkspaceSnapshotLoanInstallmentsLoan({
    required this.id,
  });
}

@immutable
class GetWorkspaceSnapshotNotificationPreferences {
  final String id;
  final bool enabled;
  final bool pushEnabled;
  final bool inAppEnabled;
  final String preferredTime;
  final String timezone;
  GetWorkspaceSnapshotNotificationPreferences.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  enabled = nativeFromJson<bool>(json['enabled']),
  pushEnabled = nativeFromJson<bool>(json['pushEnabled']),
  inAppEnabled = nativeFromJson<bool>(json['inAppEnabled']),
  preferredTime = nativeFromJson<String>(json['preferredTime']),
  timezone = nativeFromJson<String>(json['timezone']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotNotificationPreferences otherTyped = other as GetWorkspaceSnapshotNotificationPreferences;
    return id == otherTyped.id && 
    enabled == otherTyped.enabled && 
    pushEnabled == otherTyped.pushEnabled && 
    inAppEnabled == otherTyped.inAppEnabled && 
    preferredTime == otherTyped.preferredTime && 
    timezone == otherTyped.timezone;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, enabled.hashCode, pushEnabled.hashCode, inAppEnabled.hashCode, preferredTime.hashCode, timezone.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['enabled'] = nativeToJson<bool>(enabled);
    json['pushEnabled'] = nativeToJson<bool>(pushEnabled);
    json['inAppEnabled'] = nativeToJson<bool>(inAppEnabled);
    json['preferredTime'] = nativeToJson<String>(preferredTime);
    json['timezone'] = nativeToJson<String>(timezone);
    return json;
  }

  GetWorkspaceSnapshotNotificationPreferences({
    required this.id,
    required this.enabled,
    required this.pushEnabled,
    required this.inAppEnabled,
    required this.preferredTime,
    required this.timezone,
  });
}

@immutable
class GetWorkspaceSnapshotAuditEvents {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String summary;
  final Timestamp occurredAt;
  final GetWorkspaceSnapshotAuditEventsActorUser actorUser;
  GetWorkspaceSnapshotAuditEvents.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  entityType = nativeFromJson<String>(json['entityType']),
  entityId = nativeFromJson<String>(json['entityId']),
  action = nativeFromJson<String>(json['action']),
  summary = nativeFromJson<String>(json['summary']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  actorUser = GetWorkspaceSnapshotAuditEventsActorUser.fromJson(json['actorUser']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotAuditEvents otherTyped = other as GetWorkspaceSnapshotAuditEvents;
    return id == otherTyped.id && 
    entityType == otherTyped.entityType && 
    entityId == otherTyped.entityId && 
    action == otherTyped.action && 
    summary == otherTyped.summary && 
    occurredAt == otherTyped.occurredAt && 
    actorUser == otherTyped.actorUser;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, entityType.hashCode, entityId.hashCode, action.hashCode, summary.hashCode, occurredAt.hashCode, actorUser.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['entityType'] = nativeToJson<String>(entityType);
    json['entityId'] = nativeToJson<String>(entityId);
    json['action'] = nativeToJson<String>(action);
    json['summary'] = nativeToJson<String>(summary);
    json['occurredAt'] = occurredAt.toJson();
    json['actorUser'] = actorUser.toJson();
    return json;
  }

  GetWorkspaceSnapshotAuditEvents({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.summary,
    required this.occurredAt,
    required this.actorUser,
  });
}

@immutable
class GetWorkspaceSnapshotAuditEventsActorUser {
  final String displayName;
  GetWorkspaceSnapshotAuditEventsActorUser.fromJson(dynamic json):
  
  displayName = nativeFromJson<String>(json['displayName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotAuditEventsActorUser otherTyped = other as GetWorkspaceSnapshotAuditEventsActorUser;
    return displayName == otherTyped.displayName;
    
  }
  @override
  int get hashCode => displayName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['displayName'] = nativeToJson<String>(displayName);
    return json;
  }

  GetWorkspaceSnapshotAuditEventsActorUser({
    required this.displayName,
  });
}

@immutable
class GetWorkspaceSnapshotData {
  final GetWorkspaceSnapshotFinancialSpace? financialSpace;
  final List<GetWorkspaceSnapshotSpaceMembers> spaceMembers;
  final List<GetWorkspaceSnapshotCategories> categories;
  final List<GetWorkspaceSnapshotCreditCards> creditCards;
  final List<GetWorkspaceSnapshotPurchases> purchases;
  final List<GetWorkspaceSnapshotCreditCardInvoices> creditCardInvoices;
  final List<GetWorkspaceSnapshotPurchaseInstallments> purchaseInstallments;
  final List<GetWorkspaceSnapshotInvoicePayments> invoicePayments;
  final List<GetWorkspaceSnapshotLoans> loans;
  final List<GetWorkspaceSnapshotLoanInstallments> loanInstallments;
  final List<GetWorkspaceSnapshotNotificationPreferences> notificationPreferences;
  final List<GetWorkspaceSnapshotAuditEvents> auditEvents;
  GetWorkspaceSnapshotData.fromJson(dynamic json):
  
  financialSpace = json['financialSpace'] == null ? null : GetWorkspaceSnapshotFinancialSpace.fromJson(json['financialSpace']),
  spaceMembers = (json['spaceMembers'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotSpaceMembers.fromJson(e))
        .toList(),
  categories = (json['categories'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotCategories.fromJson(e))
        .toList(),
  creditCards = (json['creditCards'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotCreditCards.fromJson(e))
        .toList(),
  purchases = (json['purchases'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotPurchases.fromJson(e))
        .toList(),
  creditCardInvoices = (json['creditCardInvoices'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotCreditCardInvoices.fromJson(e))
        .toList(),
  purchaseInstallments = (json['purchaseInstallments'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotPurchaseInstallments.fromJson(e))
        .toList(),
  invoicePayments = (json['invoicePayments'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotInvoicePayments.fromJson(e))
        .toList(),
  loans = (json['loans'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotLoans.fromJson(e))
        .toList(),
  loanInstallments = (json['loanInstallments'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotLoanInstallments.fromJson(e))
        .toList(),
  notificationPreferences = (json['notificationPreferences'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotNotificationPreferences.fromJson(e))
        .toList(),
  auditEvents = (json['auditEvents'] as List<dynamic>)
        .map((e) => GetWorkspaceSnapshotAuditEvents.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotData otherTyped = other as GetWorkspaceSnapshotData;
    return financialSpace == otherTyped.financialSpace && 
    spaceMembers == otherTyped.spaceMembers && 
    categories == otherTyped.categories && 
    creditCards == otherTyped.creditCards && 
    purchases == otherTyped.purchases && 
    creditCardInvoices == otherTyped.creditCardInvoices && 
    purchaseInstallments == otherTyped.purchaseInstallments && 
    invoicePayments == otherTyped.invoicePayments && 
    loans == otherTyped.loans && 
    loanInstallments == otherTyped.loanInstallments && 
    notificationPreferences == otherTyped.notificationPreferences && 
    auditEvents == otherTyped.auditEvents;
    
  }
  @override
  int get hashCode => Object.hashAll([financialSpace.hashCode, spaceMembers.hashCode, categories.hashCode, creditCards.hashCode, purchases.hashCode, creditCardInvoices.hashCode, purchaseInstallments.hashCode, invoicePayments.hashCode, loans.hashCode, loanInstallments.hashCode, notificationPreferences.hashCode, auditEvents.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (financialSpace != null) {
      json['financialSpace'] = financialSpace!.toJson();
    }
    json['spaceMembers'] = spaceMembers.map((e) => e.toJson()).toList();
    json['categories'] = categories.map((e) => e.toJson()).toList();
    json['creditCards'] = creditCards.map((e) => e.toJson()).toList();
    json['purchases'] = purchases.map((e) => e.toJson()).toList();
    json['creditCardInvoices'] = creditCardInvoices.map((e) => e.toJson()).toList();
    json['purchaseInstallments'] = purchaseInstallments.map((e) => e.toJson()).toList();
    json['invoicePayments'] = invoicePayments.map((e) => e.toJson()).toList();
    json['loans'] = loans.map((e) => e.toJson()).toList();
    json['loanInstallments'] = loanInstallments.map((e) => e.toJson()).toList();
    json['notificationPreferences'] = notificationPreferences.map((e) => e.toJson()).toList();
    json['auditEvents'] = auditEvents.map((e) => e.toJson()).toList();
    return json;
  }

  GetWorkspaceSnapshotData({
    this.financialSpace,
    required this.spaceMembers,
    required this.categories,
    required this.creditCards,
    required this.purchases,
    required this.creditCardInvoices,
    required this.purchaseInstallments,
    required this.invoicePayments,
    required this.loans,
    required this.loanInstallments,
    required this.notificationPreferences,
    required this.auditEvents,
  });
}

@immutable
class GetWorkspaceSnapshotVariables {
  final String spaceId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetWorkspaceSnapshotVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkspaceSnapshotVariables otherTyped = other as GetWorkspaceSnapshotVariables;
    return spaceId == otherTyped.spaceId;
    
  }
  @override
  int get hashCode => spaceId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    return json;
  }

  GetWorkspaceSnapshotVariables({
    required this.spaceId,
  });
}

