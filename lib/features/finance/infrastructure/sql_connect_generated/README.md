# nossa_grana_sql_connect SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ClientConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetMyProfile
#### Required Arguments
```dart
// No required arguments
ClientConnector.instance.getMyProfile().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyProfileData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.getMyProfile();
GetMyProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ClientConnector.instance.getMyProfile().ref();
ref.execute();

ref.subscribe(...);
```


### ListMySpaces
#### Required Arguments
```dart
// No required arguments
ClientConnector.instance.listMySpaces().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMySpacesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.listMySpaces();
ListMySpacesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ClientConnector.instance.listMySpaces().ref();
ref.execute();

ref.subscribe(...);
```


### GetWorkspaceSnapshot
#### Required Arguments
```dart
String spaceId = ...;
ClientConnector.instance.getWorkspaceSnapshot(
  spaceId: spaceId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetWorkspaceSnapshotData, GetWorkspaceSnapshotVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.getWorkspaceSnapshot(
  spaceId: spaceId,
);
GetWorkspaceSnapshotData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;

final ref = ClientConnector.instance.getWorkspaceSnapshot(
  spaceId: spaceId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetCashFlowSummary
#### Required Arguments
```dart
String spaceId = ...;
DateTime monthStart = ...;
DateTime yearStart = ...;
DateTime nextYearStart = ...;
Timestamp monthStartedAt = ...;
Timestamp nextMonthStartedAt = ...;
Timestamp yearStartedAt = ...;
Timestamp nextYearStartedAt = ...;
ClientConnector.instance.getCashFlowSummary(
  spaceId: spaceId,
  monthStart: monthStart,
  yearStart: yearStart,
  nextYearStart: nextYearStart,
  monthStartedAt: monthStartedAt,
  nextMonthStartedAt: nextMonthStartedAt,
  yearStartedAt: yearStartedAt,
  nextYearStartedAt: nextYearStartedAt,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCashFlowSummaryData, GetCashFlowSummaryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.getCashFlowSummary(
  spaceId: spaceId,
  monthStart: monthStart,
  yearStart: yearStart,
  nextYearStart: nextYearStart,
  monthStartedAt: monthStartedAt,
  nextMonthStartedAt: nextMonthStartedAt,
  yearStartedAt: yearStartedAt,
  nextYearStartedAt: nextYearStartedAt,
);
GetCashFlowSummaryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
DateTime monthStart = ...;
DateTime yearStart = ...;
DateTime nextYearStart = ...;
Timestamp monthStartedAt = ...;
Timestamp nextMonthStartedAt = ...;
Timestamp yearStartedAt = ...;
Timestamp nextYearStartedAt = ...;

final ref = ClientConnector.instance.getCashFlowSummary(
  spaceId: spaceId,
  monthStart: monthStart,
  yearStart: yearStart,
  nextYearStart: nextYearStart,
  monthStartedAt: monthStartedAt,
  nextMonthStartedAt: nextMonthStartedAt,
  yearStartedAt: yearStartedAt,
  nextYearStartedAt: nextYearStartedAt,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetAgendaEntries
#### Required Arguments
```dart
String spaceId = ...;
Timestamp rangeStart = ...;
Timestamp rangeEnd = ...;
DateTime rangeStartDate = ...;
DateTime rangeEndDate = ...;
ClientConnector.instance.getAgendaEntries(
  spaceId: spaceId,
  rangeStart: rangeStart,
  rangeEnd: rangeEnd,
  rangeStartDate: rangeStartDate,
  rangeEndDate: rangeEndDate,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAgendaEntriesData, GetAgendaEntriesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.getAgendaEntries(
  spaceId: spaceId,
  rangeStart: rangeStart,
  rangeEnd: rangeEnd,
  rangeStartDate: rangeStartDate,
  rangeEndDate: rangeEndDate,
);
GetAgendaEntriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
Timestamp rangeStart = ...;
Timestamp rangeEnd = ...;
DateTime rangeStartDate = ...;
DateTime rangeEndDate = ...;

final ref = ClientConnector.instance.getAgendaEntries(
  spaceId: spaceId,
  rangeStart: rangeStart,
  rangeEnd: rangeEnd,
  rangeStartDate: rangeStartDate,
  rangeEndDate: rangeEndDate,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListSpaceInvitations
#### Required Arguments
```dart
String spaceId = ...;
ClientConnector.instance.listSpaceInvitations(
  spaceId: spaceId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListSpaceInvitationsData, ListSpaceInvitationsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.listSpaceInvitations(
  spaceId: spaceId,
);
ListSpaceInvitationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;

final ref = ClientConnector.instance.listSpaceInvitations(
  spaceId: spaceId,
).ref();
ref.execute();

ref.subscribe(...);
```


### FindCreditCardInvoice
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
DateTime referenceMonth = ...;
ClientConnector.instance.findCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<FindCreditCardInvoiceData, FindCreditCardInvoiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.findCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
);
FindCreditCardInvoiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;
DateTime referenceMonth = ...;

final ref = ClientConnector.instance.findCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPurchaseInstallmentsForCancellation
#### Required Arguments
```dart
String spaceId = ...;
String purchaseId = ...;
ClientConnector.instance.getPurchaseInstallmentsForCancellation(
  spaceId: spaceId,
  purchaseId: purchaseId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPurchaseInstallmentsForCancellationData, GetPurchaseInstallmentsForCancellationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ClientConnector.instance.getPurchaseInstallmentsForCancellation(
  spaceId: spaceId,
  purchaseId: purchaseId,
);
GetPurchaseInstallmentsForCancellationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String purchaseId = ...;

final ref = ClientConnector.instance.getPurchaseInstallmentsForCancellation(
  spaceId: spaceId,
  purchaseId: purchaseId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateMyProfile
#### Required Arguments
```dart
String displayName = ...;
ClientConnector.instance.createMyProfile(
  displayName: displayName,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateMyProfileData, CreateMyProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createMyProfile(
  displayName: displayName,
);
CreateMyProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String displayName = ...;

final ref = ClientConnector.instance.createMyProfile(
  displayName: displayName,
).ref();
ref.execute();
```


### UpdateMyProfile
#### Required Arguments
```dart
String displayName = ...;
ClientConnector.instance.updateMyProfile(
  displayName: displayName,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateMyProfile, we created `UpdateMyProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateMyProfileVariablesBuilder {
  ...
   UpdateMyProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.updateMyProfile(
  displayName: displayName,
)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateMyProfileData, UpdateMyProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateMyProfile(
  displayName: displayName,
);
UpdateMyProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String displayName = ...;

final ref = ClientConnector.instance.updateMyProfile(
  displayName: displayName,
).ref();
ref.execute();
```


### CreateFinancialSpace
#### Required Arguments
```dart
String name = ...;
String colorHex = ...;
ClientConnector.instance.createFinancialSpace(
  name: name,
  colorHex: colorHex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateFinancialSpaceData, CreateFinancialSpaceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createFinancialSpace(
  name: name,
  colorHex: colorHex,
);
CreateFinancialSpaceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String colorHex = ...;

final ref = ClientConnector.instance.createFinancialSpace(
  name: name,
  colorHex: colorHex,
).ref();
ref.execute();
```


### CreateSpaceInvitation
#### Required Arguments
```dart
String spaceId = ...;
String email = ...;
String normalizedEmail = ...;
MembershipRole role = ...;
String tokenHash = ...;
Timestamp expiresAt = ...;
ClientConnector.instance.createSpaceInvitation(
  spaceId: spaceId,
  email: email,
  normalizedEmail: normalizedEmail,
  role: role,
  tokenHash: tokenHash,
  expiresAt: expiresAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateSpaceInvitationData, CreateSpaceInvitationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createSpaceInvitation(
  spaceId: spaceId,
  email: email,
  normalizedEmail: normalizedEmail,
  role: role,
  tokenHash: tokenHash,
  expiresAt: expiresAt,
);
CreateSpaceInvitationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String email = ...;
String normalizedEmail = ...;
MembershipRole role = ...;
String tokenHash = ...;
Timestamp expiresAt = ...;

final ref = ClientConnector.instance.createSpaceInvitation(
  spaceId: spaceId,
  email: email,
  normalizedEmail: normalizedEmail,
  role: role,
  tokenHash: tokenHash,
  expiresAt: expiresAt,
).ref();
ref.execute();
```


### AcceptSpaceInvitation
#### Required Arguments
```dart
String tokenHash = ...;
ClientConnector.instance.acceptSpaceInvitation(
  tokenHash: tokenHash,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AcceptSpaceInvitationData, AcceptSpaceInvitationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.acceptSpaceInvitation(
  tokenHash: tokenHash,
);
AcceptSpaceInvitationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String tokenHash = ...;

final ref = ClientConnector.instance.acceptSpaceInvitation(
  tokenHash: tokenHash,
).ref();
ref.execute();
```


### CreateCategory
#### Required Arguments
```dart
String spaceId = ...;
String name = ...;
String normalizedName = ...;
String icon = ...;
String colorHex = ...;
ClientConnector.instance.createCategory(
  spaceId: spaceId,
  name: name,
  normalizedName: normalizedName,
  icon: icon,
  colorHex: colorHex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateCategoryData, CreateCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createCategory(
  spaceId: spaceId,
  name: name,
  normalizedName: normalizedName,
  icon: icon,
  colorHex: colorHex,
);
CreateCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String name = ...;
String normalizedName = ...;
String icon = ...;
String colorHex = ...;

final ref = ClientConnector.instance.createCategory(
  spaceId: spaceId,
  name: name,
  normalizedName: normalizedName,
  icon: icon,
  colorHex: colorHex,
).ref();
ref.execute();
```


### CreateIncomeEntry
#### Required Arguments
```dart
String spaceId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;
ClientConnector.instance.createIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateIncomeEntry, we created `CreateIncomeEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateIncomeEntryVariablesBuilder {
  ...
   CreateIncomeEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateIncomeEntryData, CreateIncomeEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
);
CreateIncomeEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreateScheduledIncomeEntry
#### Required Arguments
```dart
String spaceId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;
ClientConnector.instance.createScheduledIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateScheduledIncomeEntry, we created `CreateScheduledIncomeEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateScheduledIncomeEntryVariablesBuilder {
  ...
   CreateScheduledIncomeEntryVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  CreateScheduledIncomeEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createScheduledIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
)
.categoryId(categoryId)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateScheduledIncomeEntryData, CreateScheduledIncomeEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createScheduledIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
);
CreateScheduledIncomeEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createScheduledIncomeEntry(
  spaceId: spaceId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreateExpenseEntry
#### Required Arguments
```dart
String spaceId = ...;
String categoryId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;
ClientConnector.instance.createExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateExpenseEntry, we created `CreateExpenseEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateExpenseEntryVariablesBuilder {
  ...
   CreateExpenseEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateExpenseEntryData, CreateExpenseEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
);
CreateExpenseEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String categoryId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreatePlannedExpenseEntry
#### Required Arguments
```dart
String spaceId = ...;
String categoryId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;
ClientConnector.instance.createPlannedExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreatePlannedExpenseEntry, we created `CreatePlannedExpenseEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreatePlannedExpenseEntryVariablesBuilder {
  ...
   CreatePlannedExpenseEntryVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createPlannedExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreatePlannedExpenseEntryData, CreatePlannedExpenseEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createPlannedExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
);
CreatePlannedExpenseEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String categoryId = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createPlannedExpenseEntry(
  spaceId: spaceId,
  categoryId: categoryId,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreateCashFlowRecurrenceSeries
#### Required Arguments
```dart
String spaceId = ...;
CashFlowDirection direction = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
String description = ...;
BigInt amountCents = ...;
CashFlowRecurrenceFrequency frequency = ...;
DateTime startDate = ...;
String idempotencyKey = ...;
ClientConnector.instance.createCashFlowRecurrenceSeries(
  spaceId: spaceId,
  direction: direction,
  kind: kind,
  paymentMethod: paymentMethod,
  description: description,
  amountCents: amountCents,
  frequency: frequency,
  startDate: startDate,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateCashFlowRecurrenceSeries, we created `CreateCashFlowRecurrenceSeriesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateCashFlowRecurrenceSeriesVariablesBuilder {
  ...
   CreateCashFlowRecurrenceSeriesVariablesBuilder categoryId(String? t) {
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

  ...
}
ClientConnector.instance.createCashFlowRecurrenceSeries(
  spaceId: spaceId,
  direction: direction,
  kind: kind,
  paymentMethod: paymentMethod,
  description: description,
  amountCents: amountCents,
  frequency: frequency,
  startDate: startDate,
  idempotencyKey: idempotencyKey,
)
.categoryId(categoryId)
.notes(notes)
.endDate(endDate)
.occurrenceLimit(occurrenceLimit)
.preferredDay(preferredDay)
.nextOccurrenceDate(nextOccurrenceDate)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateCashFlowRecurrenceSeriesData, CreateCashFlowRecurrenceSeriesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createCashFlowRecurrenceSeries(
  spaceId: spaceId,
  direction: direction,
  kind: kind,
  paymentMethod: paymentMethod,
  description: description,
  amountCents: amountCents,
  frequency: frequency,
  startDate: startDate,
  idempotencyKey: idempotencyKey,
);
CreateCashFlowRecurrenceSeriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
CashFlowDirection direction = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
String description = ...;
BigInt amountCents = ...;
CashFlowRecurrenceFrequency frequency = ...;
DateTime startDate = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createCashFlowRecurrenceSeries(
  spaceId: spaceId,
  direction: direction,
  kind: kind,
  paymentMethod: paymentMethod,
  description: description,
  amountCents: amountCents,
  frequency: frequency,
  startDate: startDate,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreateRecurringCashFlowOccurrence
#### Required Arguments
```dart
String spaceId = ...;
String seriesId = ...;
int occurrenceIndex = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
CashFlowStatus status = ...;
String idempotencyKey = ...;
ClientConnector.instance.createRecurringCashFlowOccurrence(
  spaceId: spaceId,
  seriesId: seriesId,
  occurrenceIndex: occurrenceIndex,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
  idempotencyKey: idempotencyKey,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateRecurringCashFlowOccurrence, we created `CreateRecurringCashFlowOccurrenceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateRecurringCashFlowOccurrenceVariablesBuilder {
  ...
   CreateRecurringCashFlowOccurrenceVariablesBuilder receivedAt(Timestamp? t) {
   _receivedAt.value = t;
   return this;
  }
  CreateRecurringCashFlowOccurrenceVariablesBuilder paidAt(Timestamp? t) {
   _paidAt.value = t;
   return this;
  }
  CreateRecurringCashFlowOccurrenceVariablesBuilder nextOccurrenceDate(DateTime? t) {
   _nextOccurrenceDate.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createRecurringCashFlowOccurrence(
  spaceId: spaceId,
  seriesId: seriesId,
  occurrenceIndex: occurrenceIndex,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
  idempotencyKey: idempotencyKey,
)
.receivedAt(receivedAt)
.paidAt(paidAt)
.nextOccurrenceDate(nextOccurrenceDate)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateRecurringCashFlowOccurrenceData, CreateRecurringCashFlowOccurrenceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createRecurringCashFlowOccurrence(
  spaceId: spaceId,
  seriesId: seriesId,
  occurrenceIndex: occurrenceIndex,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
  idempotencyKey: idempotencyKey,
);
CreateRecurringCashFlowOccurrenceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String seriesId = ...;
int occurrenceIndex = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
CashFlowStatus status = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.createRecurringCashFlowOccurrence(
  spaceId: spaceId,
  seriesId: seriesId,
  occurrenceIndex: occurrenceIndex,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### MarkIncomeEntryReceived
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
Timestamp receivedAt = ...;
ClientConnector.instance.markIncomeEntryReceived(
  spaceId: spaceId,
  entryId: entryId,
  receivedAt: receivedAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<MarkIncomeEntryReceivedData, MarkIncomeEntryReceivedVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.markIncomeEntryReceived(
  spaceId: spaceId,
  entryId: entryId,
  receivedAt: receivedAt,
);
MarkIncomeEntryReceivedData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
Timestamp receivedAt = ...;

final ref = ClientConnector.instance.markIncomeEntryReceived(
  spaceId: spaceId,
  entryId: entryId,
  receivedAt: receivedAt,
).ref();
ref.execute();
```


### MarkExpenseEntryPaid
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
Timestamp paidAt = ...;
ClientConnector.instance.markExpenseEntryPaid(
  spaceId: spaceId,
  entryId: entryId,
  paidAt: paidAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<MarkExpenseEntryPaidData, MarkExpenseEntryPaidVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.markExpenseEntryPaid(
  spaceId: spaceId,
  entryId: entryId,
  paidAt: paidAt,
);
MarkExpenseEntryPaidData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
Timestamp paidAt = ...;

final ref = ClientConnector.instance.markExpenseEntryPaid(
  spaceId: spaceId,
  entryId: entryId,
  paidAt: paidAt,
).ref();
ref.execute();
```


### UpdateCashFlowOccurrence
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
CashFlowStatus status = ...;
ClientConnector.instance.updateCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateCashFlowOccurrence, we created `UpdateCashFlowOccurrenceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateCashFlowOccurrenceVariablesBuilder {
  ...
   UpdateCashFlowOccurrenceVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  UpdateCashFlowOccurrenceVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  UpdateCashFlowOccurrenceVariablesBuilder receivedAt(Timestamp? t) {
   _receivedAt.value = t;
   return this;
  }
  UpdateCashFlowOccurrenceVariablesBuilder paidAt(Timestamp? t) {
   _paidAt.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.updateCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
)
.categoryId(categoryId)
.notes(notes)
.receivedAt(receivedAt)
.paidAt(paidAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateCashFlowOccurrenceData, UpdateCashFlowOccurrenceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
);
UpdateCashFlowOccurrenceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
Timestamp occurredAt = ...;
DateTime competenceMonth = ...;
CashFlowStatus status = ...;

final ref = ClientConnector.instance.updateCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  occurredAt: occurredAt,
  competenceMonth: competenceMonth,
  status: status,
).ref();
ref.execute();
```


### UpdateCashFlowSeriesFrom
#### Required Arguments
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
Timestamp cutoffAt = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
CashFlowStatus entryStatus = ...;
ClientConnector.instance.updateCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateCashFlowSeriesFrom, we created `UpdateCashFlowSeriesFromBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateCashFlowSeriesFromVariablesBuilder {
  ...
   UpdateCashFlowSeriesFromVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  UpdateCashFlowSeriesFromVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  UpdateCashFlowSeriesFromVariablesBuilder receivedAt(Timestamp? t) {
   _receivedAt.value = t;
   return this;
  }
  UpdateCashFlowSeriesFromVariablesBuilder paidAt(Timestamp? t) {
   _paidAt.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.updateCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
)
.categoryId(categoryId)
.notes(notes)
.receivedAt(receivedAt)
.paidAt(paidAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateCashFlowSeriesFromData, UpdateCashFlowSeriesFromVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
);
UpdateCashFlowSeriesFromData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
Timestamp cutoffAt = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
CashFlowStatus entryStatus = ...;

final ref = ClientConnector.instance.updateCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
).ref();
ref.execute();
```


### UpdateEntireCashFlowSeries
#### Required Arguments
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
CashFlowStatus entryStatus = ...;
ClientConnector.instance.updateEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateEntireCashFlowSeries, we created `UpdateEntireCashFlowSeriesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateEntireCashFlowSeriesVariablesBuilder {
  ...
   UpdateEntireCashFlowSeriesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  UpdateEntireCashFlowSeriesVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  UpdateEntireCashFlowSeriesVariablesBuilder receivedAt(Timestamp? t) {
   _receivedAt.value = t;
   return this;
  }
  UpdateEntireCashFlowSeriesVariablesBuilder paidAt(Timestamp? t) {
   _paidAt.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.updateEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
)
.categoryId(categoryId)
.notes(notes)
.receivedAt(receivedAt)
.paidAt(paidAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateEntireCashFlowSeriesData, UpdateEntireCashFlowSeriesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
);
UpdateEntireCashFlowSeriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
String description = ...;
CashFlowKind kind = ...;
CashFlowPaymentMethod paymentMethod = ...;
BigInt amountCents = ...;
CashFlowStatus entryStatus = ...;

final ref = ClientConnector.instance.updateEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  description: description,
  kind: kind,
  paymentMethod: paymentMethod,
  amountCents: amountCents,
  entryStatus: entryStatus,
).ref();
ref.execute();
```


### DeleteStandaloneCashFlowEntry
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;
ClientConnector.instance.deleteStandaloneCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteStandaloneCashFlowEntryData, DeleteStandaloneCashFlowEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.deleteStandaloneCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
);
DeleteStandaloneCashFlowEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;

final ref = ClientConnector.instance.deleteStandaloneCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
).ref();
ref.execute();
```


### DeleteCashFlowOccurrence
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;
String reason = ...;
ClientConnector.instance.deleteCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  reason: reason,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCashFlowOccurrenceData, DeleteCashFlowOccurrenceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.deleteCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  reason: reason,
);
DeleteCashFlowOccurrenceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
CashFlowMutationScope scope = ...;
String reason = ...;

final ref = ClientConnector.instance.deleteCashFlowOccurrence(
  spaceId: spaceId,
  entryId: entryId,
  scope: scope,
  reason: reason,
).ref();
ref.execute();
```


### DeleteCashFlowSeriesFrom
#### Required Arguments
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
Timestamp cutoffAt = ...;
String reason = ...;
ClientConnector.instance.deleteCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  reason: reason,
).execute();
```

#### Optional Arguments
We return a builder for each query. For DeleteCashFlowSeriesFrom, we created `DeleteCashFlowSeriesFromBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class DeleteCashFlowSeriesFromVariablesBuilder {
  ...
   DeleteCashFlowSeriesFromVariablesBuilder lastKeptDate(DateTime? t) {
   _lastKeptDate.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.deleteCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  reason: reason,
)
.lastKeptDate(lastKeptDate)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<DeleteCashFlowSeriesFromData, DeleteCashFlowSeriesFromVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.deleteCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  reason: reason,
);
DeleteCashFlowSeriesFromData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
Timestamp cutoffAt = ...;
String reason = ...;

final ref = ClientConnector.instance.deleteCashFlowSeriesFrom(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  cutoffAt: cutoffAt,
  reason: reason,
).ref();
ref.execute();
```


### DeleteEntireCashFlowSeries
#### Required Arguments
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
String reason = ...;
ClientConnector.instance.deleteEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  reason: reason,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteEntireCashFlowSeriesData, DeleteEntireCashFlowSeriesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.deleteEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  reason: reason,
);
DeleteEntireCashFlowSeriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String seriesId = ...;
CashFlowMutationScope scope = ...;
String reason = ...;

final ref = ClientConnector.instance.deleteEntireCashFlowSeries(
  spaceId: spaceId,
  seriesId: seriesId,
  scope: scope,
  reason: reason,
).ref();
ref.execute();
```


### CancelCashFlowEntry
#### Required Arguments
```dart
String spaceId = ...;
String entryId = ...;
String reason = ...;
ClientConnector.instance.cancelCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  reason: reason,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CancelCashFlowEntryData, CancelCashFlowEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.cancelCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  reason: reason,
);
CancelCashFlowEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String entryId = ...;
String reason = ...;

final ref = ClientConnector.instance.cancelCashFlowEntry(
  spaceId: spaceId,
  entryId: entryId,
  reason: reason,
).ref();
ref.execute();
```


### CreateCreditCard
#### Required Arguments
```dart
String spaceId = ...;
String nickname = ...;
String lastFourDigits = ...;
BigInt creditLimitCents = ...;
int closingDay = ...;
int dueDay = ...;
String colorHex = ...;
ClientConnector.instance.createCreditCard(
  spaceId: spaceId,
  nickname: nickname,
  lastFourDigits: lastFourDigits,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateCreditCard, we created `CreateCreditCardBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateCreditCardVariablesBuilder {
  ...
   CreateCreditCardVariablesBuilder institutionName(String? t) {
   _institutionName.value = t;
   return this;
  }
  CreateCreditCardVariablesBuilder brand(String? t) {
   _brand.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createCreditCard(
  spaceId: spaceId,
  nickname: nickname,
  lastFourDigits: lastFourDigits,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
)
.institutionName(institutionName)
.brand(brand)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateCreditCardData, CreateCreditCardVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createCreditCard(
  spaceId: spaceId,
  nickname: nickname,
  lastFourDigits: lastFourDigits,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
);
CreateCreditCardData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String nickname = ...;
String lastFourDigits = ...;
BigInt creditLimitCents = ...;
int closingDay = ...;
int dueDay = ...;
String colorHex = ...;

final ref = ClientConnector.instance.createCreditCard(
  spaceId: spaceId,
  nickname: nickname,
  lastFourDigits: lastFourDigits,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
).ref();
ref.execute();
```


### CreatePurchase
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
String categoryId = ...;
String description = ...;
BigInt totalAmountCents = ...;
DateTime purchaseDate = ...;
int installmentCount = ...;
DateTime firstInvoiceReference = ...;
ClientConnector.instance.createPurchase(
  spaceId: spaceId,
  cardId: cardId,
  categoryId: categoryId,
  description: description,
  totalAmountCents: totalAmountCents,
  purchaseDate: purchaseDate,
  installmentCount: installmentCount,
  firstInvoiceReference: firstInvoiceReference,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreatePurchase, we created `CreatePurchaseBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreatePurchaseVariablesBuilder {
  ...
   CreatePurchaseVariablesBuilder merchantName(String? t) {
   _merchantName.value = t;
   return this;
  }
  CreatePurchaseVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.createPurchase(
  spaceId: spaceId,
  cardId: cardId,
  categoryId: categoryId,
  description: description,
  totalAmountCents: totalAmountCents,
  purchaseDate: purchaseDate,
  installmentCount: installmentCount,
  firstInvoiceReference: firstInvoiceReference,
)
.merchantName(merchantName)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreatePurchaseData, CreatePurchaseVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createPurchase(
  spaceId: spaceId,
  cardId: cardId,
  categoryId: categoryId,
  description: description,
  totalAmountCents: totalAmountCents,
  purchaseDate: purchaseDate,
  installmentCount: installmentCount,
  firstInvoiceReference: firstInvoiceReference,
);
CreatePurchaseData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;
String categoryId = ...;
String description = ...;
BigInt totalAmountCents = ...;
DateTime purchaseDate = ...;
int installmentCount = ...;
DateTime firstInvoiceReference = ...;

final ref = ClientConnector.instance.createPurchase(
  spaceId: spaceId,
  cardId: cardId,
  categoryId: categoryId,
  description: description,
  totalAmountCents: totalAmountCents,
  purchaseDate: purchaseDate,
  installmentCount: installmentCount,
  firstInvoiceReference: firstInvoiceReference,
).ref();
ref.execute();
```


### CreateCreditCardInvoice
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
DateTime referenceMonth = ...;
DateTime closingDate = ...;
DateTime dueDate = ...;
ClientConnector.instance.createCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
  closingDate: closingDate,
  dueDate: dueDate,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateCreditCardInvoiceData, CreateCreditCardInvoiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
  closingDate: closingDate,
  dueDate: dueDate,
);
CreateCreditCardInvoiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;
DateTime referenceMonth = ...;
DateTime closingDate = ...;
DateTime dueDate = ...;

final ref = ClientConnector.instance.createCreditCardInvoice(
  spaceId: spaceId,
  cardId: cardId,
  referenceMonth: referenceMonth,
  closingDate: closingDate,
  dueDate: dueDate,
).ref();
ref.execute();
```


### AddPurchaseInstallment
#### Required Arguments
```dart
String spaceId = ...;
String purchaseId = ...;
String invoiceId = ...;
int installmentNumber = ...;
int installmentCount = ...;
BigInt amountCents = ...;
DateTime dueDate = ...;
ClientConnector.instance.addPurchaseInstallment(
  spaceId: spaceId,
  purchaseId: purchaseId,
  invoiceId: invoiceId,
  installmentNumber: installmentNumber,
  installmentCount: installmentCount,
  amountCents: amountCents,
  dueDate: dueDate,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddPurchaseInstallmentData, AddPurchaseInstallmentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.addPurchaseInstallment(
  spaceId: spaceId,
  purchaseId: purchaseId,
  invoiceId: invoiceId,
  installmentNumber: installmentNumber,
  installmentCount: installmentCount,
  amountCents: amountCents,
  dueDate: dueDate,
);
AddPurchaseInstallmentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String purchaseId = ...;
String invoiceId = ...;
int installmentNumber = ...;
int installmentCount = ...;
BigInt amountCents = ...;
DateTime dueDate = ...;

final ref = ClientConnector.instance.addPurchaseInstallment(
  spaceId: spaceId,
  purchaseId: purchaseId,
  invoiceId: invoiceId,
  installmentNumber: installmentNumber,
  installmentCount: installmentCount,
  amountCents: amountCents,
  dueDate: dueDate,
).ref();
ref.execute();
```


### UpdatePurchaseDetails
#### Required Arguments
```dart
String spaceId = ...;
String purchaseId = ...;
String description = ...;
String categoryId = ...;
ClientConnector.instance.updatePurchaseDetails(
  spaceId: spaceId,
  purchaseId: purchaseId,
  description: description,
  categoryId: categoryId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdatePurchaseDetailsData, UpdatePurchaseDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updatePurchaseDetails(
  spaceId: spaceId,
  purchaseId: purchaseId,
  description: description,
  categoryId: categoryId,
);
UpdatePurchaseDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String purchaseId = ...;
String description = ...;
String categoryId = ...;

final ref = ClientConnector.instance.updatePurchaseDetails(
  spaceId: spaceId,
  purchaseId: purchaseId,
  description: description,
  categoryId: categoryId,
).ref();
ref.execute();
```


### CancelPurchaseInstallment
#### Required Arguments
```dart
String spaceId = ...;
String installmentId = ...;
String invoiceId = ...;
BigInt amountCents = ...;
ClientConnector.instance.cancelPurchaseInstallment(
  spaceId: spaceId,
  installmentId: installmentId,
  invoiceId: invoiceId,
  amountCents: amountCents,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CancelPurchaseInstallmentData, CancelPurchaseInstallmentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.cancelPurchaseInstallment(
  spaceId: spaceId,
  installmentId: installmentId,
  invoiceId: invoiceId,
  amountCents: amountCents,
);
CancelPurchaseInstallmentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String installmentId = ...;
String invoiceId = ...;
BigInt amountCents = ...;

final ref = ClientConnector.instance.cancelPurchaseInstallment(
  spaceId: spaceId,
  installmentId: installmentId,
  invoiceId: invoiceId,
  amountCents: amountCents,
).ref();
ref.execute();
```


### CancelPurchase
#### Required Arguments
```dart
String spaceId = ...;
String purchaseId = ...;
String reason = ...;
ClientConnector.instance.cancelPurchase(
  spaceId: spaceId,
  purchaseId: purchaseId,
  reason: reason,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CancelPurchaseData, CancelPurchaseVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.cancelPurchase(
  spaceId: spaceId,
  purchaseId: purchaseId,
  reason: reason,
);
CancelPurchaseData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String purchaseId = ...;
String reason = ...;

final ref = ClientConnector.instance.cancelPurchase(
  spaceId: spaceId,
  purchaseId: purchaseId,
  reason: reason,
).ref();
ref.execute();
```


### RegisterInvoicePayment
#### Required Arguments
```dart
String spaceId = ...;
String invoiceId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;
InvoiceStatus resultingStatus = ...;
ClientConnector.instance.registerInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For RegisterInvoicePayment, we created `RegisterInvoicePaymentBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class RegisterInvoicePaymentVariablesBuilder {
  ...
   RegisterInvoicePaymentVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.registerInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<RegisterInvoicePaymentData, RegisterInvoicePaymentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.registerInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
);
RegisterInvoicePaymentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String invoiceId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;
InvoiceStatus resultingStatus = ...;

final ref = ClientConnector.instance.registerInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
).ref();
ref.execute();
```


### RegisterFullInvoicePayment
#### Required Arguments
```dart
String spaceId = ...;
String invoiceId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;
ClientConnector.instance.registerFullInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RegisterFullInvoicePaymentData, RegisterFullInvoicePaymentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.registerFullInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
);
RegisterFullInvoicePaymentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String invoiceId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;

final ref = ClientConnector.instance.registerFullInvoicePayment(
  spaceId: spaceId,
  invoiceId: invoiceId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
).ref();
ref.execute();
```


### CreateLoan
#### Required Arguments
```dart
String spaceId = ...;
String name = ...;
BigInt principalAmountCents = ...;
BigInt monthlyInterestRateMicros = ...;
LoanAmortizationMethod amortizationMethod = ...;
int installmentCount = ...;
DateTime firstDueDate = ...;
ClientConnector.instance.createLoan(
  spaceId: spaceId,
  name: name,
  principalAmountCents: principalAmountCents,
  monthlyInterestRateMicros: monthlyInterestRateMicros,
  amortizationMethod: amortizationMethod,
  installmentCount: installmentCount,
  firstDueDate: firstDueDate,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateLoan, we created `CreateLoanBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateLoanVariablesBuilder {
  ...
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

  ...
}
ClientConnector.instance.createLoan(
  spaceId: spaceId,
  name: name,
  principalAmountCents: principalAmountCents,
  monthlyInterestRateMicros: monthlyInterestRateMicros,
  amortizationMethod: amortizationMethod,
  installmentCount: installmentCount,
  firstDueDate: firstDueDate,
)
.lender(lender)
.contractedAt(contractedAt)
.expectedInstallmentAmountCents(expectedInstallmentAmountCents)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateLoanData, CreateLoanVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.createLoan(
  spaceId: spaceId,
  name: name,
  principalAmountCents: principalAmountCents,
  monthlyInterestRateMicros: monthlyInterestRateMicros,
  amortizationMethod: amortizationMethod,
  installmentCount: installmentCount,
  firstDueDate: firstDueDate,
);
CreateLoanData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String name = ...;
BigInt principalAmountCents = ...;
BigInt monthlyInterestRateMicros = ...;
LoanAmortizationMethod amortizationMethod = ...;
int installmentCount = ...;
DateTime firstDueDate = ...;

final ref = ClientConnector.instance.createLoan(
  spaceId: spaceId,
  name: name,
  principalAmountCents: principalAmountCents,
  monthlyInterestRateMicros: monthlyInterestRateMicros,
  amortizationMethod: amortizationMethod,
  installmentCount: installmentCount,
  firstDueDate: firstDueDate,
).ref();
ref.execute();
```


### AddLoanInstallment
#### Required Arguments
```dart
String spaceId = ...;
String loanId = ...;
int installmentNumber = ...;
DateTime dueDate = ...;
BigInt openingBalanceCents = ...;
BigInt principalAmountCents = ...;
BigInt interestAmountCents = ...;
BigInt totalAmountCents = ...;
ClientConnector.instance.addLoanInstallment(
  spaceId: spaceId,
  loanId: loanId,
  installmentNumber: installmentNumber,
  dueDate: dueDate,
  openingBalanceCents: openingBalanceCents,
  principalAmountCents: principalAmountCents,
  interestAmountCents: interestAmountCents,
  totalAmountCents: totalAmountCents,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddLoanInstallmentData, AddLoanInstallmentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.addLoanInstallment(
  spaceId: spaceId,
  loanId: loanId,
  installmentNumber: installmentNumber,
  dueDate: dueDate,
  openingBalanceCents: openingBalanceCents,
  principalAmountCents: principalAmountCents,
  interestAmountCents: interestAmountCents,
  totalAmountCents: totalAmountCents,
);
AddLoanInstallmentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String loanId = ...;
int installmentNumber = ...;
DateTime dueDate = ...;
BigInt openingBalanceCents = ...;
BigInt principalAmountCents = ...;
BigInt interestAmountCents = ...;
BigInt totalAmountCents = ...;

final ref = ClientConnector.instance.addLoanInstallment(
  spaceId: spaceId,
  loanId: loanId,
  installmentNumber: installmentNumber,
  dueDate: dueDate,
  openingBalanceCents: openingBalanceCents,
  principalAmountCents: principalAmountCents,
  interestAmountCents: interestAmountCents,
  totalAmountCents: totalAmountCents,
).ref();
ref.execute();
```


### RegisterLoanPayment
#### Required Arguments
```dart
String spaceId = ...;
String loanId = ...;
String loanInstallmentId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;
LoanInstallmentStatus resultingStatus = ...;
ClientConnector.instance.registerLoanPayment(
  spaceId: spaceId,
  loanId: loanId,
  loanInstallmentId: loanInstallmentId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
).execute();
```

#### Optional Arguments
We return a builder for each query. For RegisterLoanPayment, we created `RegisterLoanPaymentBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class RegisterLoanPaymentVariablesBuilder {
  ...
   RegisterLoanPaymentVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.registerLoanPayment(
  spaceId: spaceId,
  loanId: loanId,
  loanInstallmentId: loanInstallmentId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<RegisterLoanPaymentData, RegisterLoanPaymentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.registerLoanPayment(
  spaceId: spaceId,
  loanId: loanId,
  loanInstallmentId: loanInstallmentId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
);
RegisterLoanPaymentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String loanId = ...;
String loanInstallmentId = ...;
BigInt amountCents = ...;
Timestamp paidAt = ...;
String idempotencyKey = ...;
LoanInstallmentStatus resultingStatus = ...;

final ref = ClientConnector.instance.registerLoanPayment(
  spaceId: spaceId,
  loanId: loanId,
  loanInstallmentId: loanInstallmentId,
  amountCents: amountCents,
  paidAt: paidAt,
  idempotencyKey: idempotencyKey,
  resultingStatus: resultingStatus,
).ref();
ref.execute();
```


### CancelLoan
#### Required Arguments
```dart
String spaceId = ...;
String loanId = ...;
ClientConnector.instance.cancelLoan(
  spaceId: spaceId,
  loanId: loanId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CancelLoanData, CancelLoanVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.cancelLoan(
  spaceId: spaceId,
  loanId: loanId,
);
CancelLoanData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String loanId = ...;

final ref = ClientConnector.instance.cancelLoan(
  spaceId: spaceId,
  loanId: loanId,
).ref();
ref.execute();
```


### UpdateNotificationPreference
#### Required Arguments
```dart
String spaceId = ...;
bool enabled = ...;
bool pushEnabled = ...;
bool inAppEnabled = ...;
String preferredTime = ...;
ClientConnector.instance.updateNotificationPreference(
  spaceId: spaceId,
  enabled: enabled,
  pushEnabled: pushEnabled,
  inAppEnabled: inAppEnabled,
  preferredTime: preferredTime,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateNotificationPreferenceData, UpdateNotificationPreferenceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateNotificationPreference(
  spaceId: spaceId,
  enabled: enabled,
  pushEnabled: pushEnabled,
  inAppEnabled: inAppEnabled,
  preferredTime: preferredTime,
);
UpdateNotificationPreferenceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
bool enabled = ...;
bool pushEnabled = ...;
bool inAppEnabled = ...;
String preferredTime = ...;

final ref = ClientConnector.instance.updateNotificationPreference(
  spaceId: spaceId,
  enabled: enabled,
  pushEnabled: pushEnabled,
  inAppEnabled: inAppEnabled,
  preferredTime: preferredTime,
).ref();
ref.execute();
```


### UpdateNotificationRules
#### Required Arguments
```dart
String spaceId = ...;
bool invoiceClosing = ...;
bool invoiceDue = ...;
bool loanDue = ...;
int daysBefore = ...;
ClientConnector.instance.updateNotificationRules(
  spaceId: spaceId,
  invoiceClosing: invoiceClosing,
  invoiceDue: invoiceDue,
  loanDue: loanDue,
  daysBefore: daysBefore,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateNotificationRulesData, UpdateNotificationRulesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateNotificationRules(
  spaceId: spaceId,
  invoiceClosing: invoiceClosing,
  invoiceDue: invoiceDue,
  loanDue: loanDue,
  daysBefore: daysBefore,
);
UpdateNotificationRulesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
bool invoiceClosing = ...;
bool invoiceDue = ...;
bool loanDue = ...;
int daysBefore = ...;

final ref = ClientConnector.instance.updateNotificationRules(
  spaceId: spaceId,
  invoiceClosing: invoiceClosing,
  invoiceDue: invoiceDue,
  loanDue: loanDue,
  daysBefore: daysBefore,
).ref();
ref.execute();
```


### RegisterDeviceSubscription
#### Required Arguments
```dart
String id = ...;
NotificationPlatform platform = ...;
String tokenOrEndpoint = ...;
String tokenHash = ...;
ClientConnector.instance.registerDeviceSubscription(
  id: id,
  platform: platform,
  tokenOrEndpoint: tokenOrEndpoint,
  tokenHash: tokenHash,
).execute();
```

#### Optional Arguments
We return a builder for each query. For RegisterDeviceSubscription, we created `RegisterDeviceSubscriptionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class RegisterDeviceSubscriptionVariablesBuilder {
  ...
   RegisterDeviceSubscriptionVariablesBuilder deviceName(String? t) {
   _deviceName.value = t;
   return this;
  }

  ...
}
ClientConnector.instance.registerDeviceSubscription(
  id: id,
  platform: platform,
  tokenOrEndpoint: tokenOrEndpoint,
  tokenHash: tokenHash,
)
.deviceName(deviceName)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<RegisterDeviceSubscriptionData, RegisterDeviceSubscriptionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.registerDeviceSubscription(
  id: id,
  platform: platform,
  tokenOrEndpoint: tokenOrEndpoint,
  tokenHash: tokenHash,
);
RegisterDeviceSubscriptionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
NotificationPlatform platform = ...;
String tokenOrEndpoint = ...;
String tokenHash = ...;

final ref = ClientConnector.instance.registerDeviceSubscription(
  id: id,
  platform: platform,
  tokenOrEndpoint: tokenOrEndpoint,
  tokenHash: tokenHash,
).ref();
ref.execute();
```


### UpdateFinancialSpace
#### Required Arguments
```dart
String spaceId = ...;
String name = ...;
String colorHex = ...;
ClientConnector.instance.updateFinancialSpace(
  spaceId: spaceId,
  name: name,
  colorHex: colorHex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateFinancialSpaceData, UpdateFinancialSpaceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateFinancialSpace(
  spaceId: spaceId,
  name: name,
  colorHex: colorHex,
);
UpdateFinancialSpaceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String name = ...;
String colorHex = ...;

final ref = ClientConnector.instance.updateFinancialSpace(
  spaceId: spaceId,
  name: name,
  colorHex: colorHex,
).ref();
ref.execute();
```


### ArchiveFinancialSpace
#### Required Arguments
```dart
String spaceId = ...;
ClientConnector.instance.archiveFinancialSpace(
  spaceId: spaceId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ArchiveFinancialSpaceData, ArchiveFinancialSpaceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.archiveFinancialSpace(
  spaceId: spaceId,
);
ArchiveFinancialSpaceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;

final ref = ClientConnector.instance.archiveFinancialSpace(
  spaceId: spaceId,
).ref();
ref.execute();
```


### RevokeSpaceInvitation
#### Required Arguments
```dart
String spaceId = ...;
String invitationId = ...;
ClientConnector.instance.revokeSpaceInvitation(
  spaceId: spaceId,
  invitationId: invitationId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RevokeSpaceInvitationData, RevokeSpaceInvitationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.revokeSpaceInvitation(
  spaceId: spaceId,
  invitationId: invitationId,
);
RevokeSpaceInvitationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String invitationId = ...;

final ref = ClientConnector.instance.revokeSpaceInvitation(
  spaceId: spaceId,
  invitationId: invitationId,
).ref();
ref.execute();
```


### UpdateMemberRole
#### Required Arguments
```dart
String spaceId = ...;
String memberId = ...;
MembershipRole role = ...;
ClientConnector.instance.updateMemberRole(
  spaceId: spaceId,
  memberId: memberId,
  role: role,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateMemberRoleData, UpdateMemberRoleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateMemberRole(
  spaceId: spaceId,
  memberId: memberId,
  role: role,
);
UpdateMemberRoleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String memberId = ...;
MembershipRole role = ...;

final ref = ClientConnector.instance.updateMemberRole(
  spaceId: spaceId,
  memberId: memberId,
  role: role,
).ref();
ref.execute();
```


### RemoveSpaceMember
#### Required Arguments
```dart
String spaceId = ...;
String memberId = ...;
ClientConnector.instance.removeSpaceMember(
  spaceId: spaceId,
  memberId: memberId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RemoveSpaceMemberData, RemoveSpaceMemberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.removeSpaceMember(
  spaceId: spaceId,
  memberId: memberId,
);
RemoveSpaceMemberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String memberId = ...;

final ref = ClientConnector.instance.removeSpaceMember(
  spaceId: spaceId,
  memberId: memberId,
).ref();
ref.execute();
```


### UpdateCategory
#### Required Arguments
```dart
String spaceId = ...;
String categoryId = ...;
String name = ...;
String normalizedName = ...;
ClientConnector.instance.updateCategory(
  spaceId: spaceId,
  categoryId: categoryId,
  name: name,
  normalizedName: normalizedName,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateCategoryData, UpdateCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateCategory(
  spaceId: spaceId,
  categoryId: categoryId,
  name: name,
  normalizedName: normalizedName,
);
UpdateCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String categoryId = ...;
String name = ...;
String normalizedName = ...;

final ref = ClientConnector.instance.updateCategory(
  spaceId: spaceId,
  categoryId: categoryId,
  name: name,
  normalizedName: normalizedName,
).ref();
ref.execute();
```


### ArchiveCategory
#### Required Arguments
```dart
String spaceId = ...;
String categoryId = ...;
ClientConnector.instance.archiveCategory(
  spaceId: spaceId,
  categoryId: categoryId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ArchiveCategoryData, ArchiveCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.archiveCategory(
  spaceId: spaceId,
  categoryId: categoryId,
);
ArchiveCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String categoryId = ...;

final ref = ClientConnector.instance.archiveCategory(
  spaceId: spaceId,
  categoryId: categoryId,
).ref();
ref.execute();
```


### UpdateCreditCard
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
String nickname = ...;
BigInt creditLimitCents = ...;
int closingDay = ...;
int dueDay = ...;
String colorHex = ...;
ClientConnector.instance.updateCreditCard(
  spaceId: spaceId,
  cardId: cardId,
  nickname: nickname,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateCreditCardData, UpdateCreditCardVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.updateCreditCard(
  spaceId: spaceId,
  cardId: cardId,
  nickname: nickname,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
);
UpdateCreditCardData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;
String nickname = ...;
BigInt creditLimitCents = ...;
int closingDay = ...;
int dueDay = ...;
String colorHex = ...;

final ref = ClientConnector.instance.updateCreditCard(
  spaceId: spaceId,
  cardId: cardId,
  nickname: nickname,
  creditLimitCents: creditLimitCents,
  closingDay: closingDay,
  dueDay: dueDay,
  colorHex: colorHex,
).ref();
ref.execute();
```


### ArchiveCreditCard
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
ClientConnector.instance.archiveCreditCard(
  spaceId: spaceId,
  cardId: cardId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ArchiveCreditCardData, ArchiveCreditCardVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.archiveCreditCard(
  spaceId: spaceId,
  cardId: cardId,
);
ArchiveCreditCardData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;

final ref = ClientConnector.instance.archiveCreditCard(
  spaceId: spaceId,
  cardId: cardId,
).ref();
ref.execute();
```


### DeleteCreditCardCascade
#### Required Arguments
```dart
String spaceId = ...;
String cardId = ...;
ClientConnector.instance.deleteCreditCardCascade(
  spaceId: spaceId,
  cardId: cardId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCreditCardCascadeData, DeleteCreditCardCascadeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ClientConnector.instance.deleteCreditCardCascade(
  spaceId: spaceId,
  cardId: cardId,
);
DeleteCreditCardCascadeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String spaceId = ...;
String cardId = ...;

final ref = ClientConnector.instance.deleteCreditCardCascade(
  spaceId: spaceId,
  cardId: cardId,
).ref();
ref.execute();
```

