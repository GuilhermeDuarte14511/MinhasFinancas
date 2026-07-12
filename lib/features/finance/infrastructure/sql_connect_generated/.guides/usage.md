# Basic Usage

```dart
ClientConnector.instance.ListWorkspaceCashFlowHistory(listWorkspaceCashFlowHistoryVariables).execute();
ClientConnector.instance.ListWorkspaceActivityHistory(listWorkspaceActivityHistoryVariables).execute();
ClientConnector.instance.GetMyProfile().execute();
ClientConnector.instance.CreateMyProfile(createMyProfileVariables).execute();
ClientConnector.instance.UpdateMyProfile(updateMyProfileVariables).execute();
ClientConnector.instance.ListMySpaces().execute();
ClientConnector.instance.GetWorkspaceSnapshot(getWorkspaceSnapshotVariables).execute();
ClientConnector.instance.GetCashFlowSummary(getCashFlowSummaryVariables).execute();
ClientConnector.instance.GetAgendaEntries(getAgendaEntriesVariables).execute();
ClientConnector.instance.CreateFinancialSpace(createFinancialSpaceVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ClientConnector.instance.RegisterDeviceSubscription({ ... })
.deviceName(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

