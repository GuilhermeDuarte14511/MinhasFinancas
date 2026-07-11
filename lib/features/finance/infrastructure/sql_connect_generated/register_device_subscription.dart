part of 'client.dart';

class RegisterDeviceSubscriptionVariablesBuilder {
  String id;
  NotificationPlatform platform;
  String tokenOrEndpoint;
  String tokenHash;
  Optional<String> _deviceName = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  RegisterDeviceSubscriptionVariablesBuilder deviceName(String? t) {
    _deviceName.value = t;
    return this;
  }

  RegisterDeviceSubscriptionVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.platform,
    required this.tokenOrEndpoint,
    required this.tokenHash,
  });
  Deserializer<RegisterDeviceSubscriptionData> dataDeserializer =
      (dynamic json) =>
          RegisterDeviceSubscriptionData.fromJson(jsonDecode(json));
  Serializer<RegisterDeviceSubscriptionVariables> varsSerializer =
      (RegisterDeviceSubscriptionVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      RegisterDeviceSubscriptionData,
      RegisterDeviceSubscriptionVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    RegisterDeviceSubscriptionData,
    RegisterDeviceSubscriptionVariables
  >
  ref() {
    RegisterDeviceSubscriptionVariables vars =
        RegisterDeviceSubscriptionVariables(
          id: id,
          platform: platform,
          tokenOrEndpoint: tokenOrEndpoint,
          tokenHash: tokenHash,
          deviceName: _deviceName,
        );
    return _dataConnect.mutation(
      "RegisterDeviceSubscription",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class RegisterDeviceSubscriptionSubscription {
  final String id;
  RegisterDeviceSubscriptionSubscription.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterDeviceSubscriptionSubscription otherTyped =
        other as RegisterDeviceSubscriptionSubscription;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RegisterDeviceSubscriptionSubscription({required this.id});
}

@immutable
class RegisterDeviceSubscriptionData {
  final RegisterDeviceSubscriptionSubscription subscription;
  RegisterDeviceSubscriptionData.fromJson(dynamic json)
    : subscription = RegisterDeviceSubscriptionSubscription.fromJson(
        json['subscription'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterDeviceSubscriptionData otherTyped =
        other as RegisterDeviceSubscriptionData;
    return subscription == otherTyped.subscription;
  }

  @override
  int get hashCode => subscription.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['subscription'] = subscription.toJson();
    return json;
  }

  RegisterDeviceSubscriptionData({required this.subscription});
}

@immutable
class RegisterDeviceSubscriptionVariables {
  final String id;
  final NotificationPlatform platform;
  final String tokenOrEndpoint;
  final String tokenHash;
  late final Optional<String> deviceName;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  RegisterDeviceSubscriptionVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      platform = NotificationPlatform.values.byName(json['platform']),
      tokenOrEndpoint = nativeFromJson<String>(json['tokenOrEndpoint']),
      tokenHash = nativeFromJson<String>(json['tokenHash']) {
    deviceName = Optional.optional(nativeFromJson, nativeToJson);
    deviceName.value = json['deviceName'] == null
        ? null
        : nativeFromJson<String>(json['deviceName']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RegisterDeviceSubscriptionVariables otherTyped =
        other as RegisterDeviceSubscriptionVariables;
    return id == otherTyped.id &&
        platform == otherTyped.platform &&
        tokenOrEndpoint == otherTyped.tokenOrEndpoint &&
        tokenHash == otherTyped.tokenHash &&
        deviceName == otherTyped.deviceName;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    platform.hashCode,
    tokenOrEndpoint.hashCode,
    tokenHash.hashCode,
    deviceName.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['platform'] = platform.name;
    json['tokenOrEndpoint'] = nativeToJson<String>(tokenOrEndpoint);
    json['tokenHash'] = nativeToJson<String>(tokenHash);
    if (deviceName.state == OptionalState.set) {
      json['deviceName'] = deviceName.toJson();
    }
    return json;
  }

  RegisterDeviceSubscriptionVariables({
    required this.id,
    required this.platform,
    required this.tokenOrEndpoint,
    required this.tokenHash,
    required this.deviceName,
  });
}
