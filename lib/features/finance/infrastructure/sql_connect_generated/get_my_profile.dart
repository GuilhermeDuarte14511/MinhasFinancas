part of 'client.dart';

class GetMyProfileVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  GetMyProfileVariablesBuilder(this._dataConnect);
  Deserializer<GetMyProfileData> dataDeserializer = (dynamic json) =>
      GetMyProfileData.fromJson(jsonDecode(json));

  Future<QueryResult<GetMyProfileData, void>> execute({
    QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache,
  }) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetMyProfileData, void> ref() {
    return _dataConnect.query(
      "GetMyProfile",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class GetMyProfileUserProfiles {
  final String id;
  final String firebaseUid;
  final String email;
  final String normalizedEmail;
  final String displayName;
  final String? photoUrl;
  final String locale;
  final String timezone;
  GetMyProfileUserProfiles.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      firebaseUid = nativeFromJson<String>(json['firebaseUid']),
      email = nativeFromJson<String>(json['email']),
      normalizedEmail = nativeFromJson<String>(json['normalizedEmail']),
      displayName = nativeFromJson<String>(json['displayName']),
      photoUrl = json['photoUrl'] == null
          ? null
          : nativeFromJson<String>(json['photoUrl']),
      locale = nativeFromJson<String>(json['locale']),
      timezone = nativeFromJson<String>(json['timezone']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProfileUserProfiles otherTyped =
        other as GetMyProfileUserProfiles;
    return id == otherTyped.id &&
        firebaseUid == otherTyped.firebaseUid &&
        email == otherTyped.email &&
        normalizedEmail == otherTyped.normalizedEmail &&
        displayName == otherTyped.displayName &&
        photoUrl == otherTyped.photoUrl &&
        locale == otherTyped.locale &&
        timezone == otherTyped.timezone;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    firebaseUid.hashCode,
    email.hashCode,
    normalizedEmail.hashCode,
    displayName.hashCode,
    photoUrl.hashCode,
    locale.hashCode,
    timezone.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['firebaseUid'] = nativeToJson<String>(firebaseUid);
    json['email'] = nativeToJson<String>(email);
    json['normalizedEmail'] = nativeToJson<String>(normalizedEmail);
    json['displayName'] = nativeToJson<String>(displayName);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['locale'] = nativeToJson<String>(locale);
    json['timezone'] = nativeToJson<String>(timezone);
    return json;
  }

  GetMyProfileUserProfiles({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.normalizedEmail,
    required this.displayName,
    this.photoUrl,
    required this.locale,
    required this.timezone,
  });
}

@immutable
class GetMyProfileData {
  final List<GetMyProfileUserProfiles> userProfiles;
  GetMyProfileData.fromJson(dynamic json)
    : userProfiles = (json['userProfiles'] as List<dynamic>)
          .map((e) => GetMyProfileUserProfiles.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProfileData otherTyped = other as GetMyProfileData;
    return userProfiles == otherTyped.userProfiles;
  }

  @override
  int get hashCode => userProfiles.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userProfiles'] = userProfiles.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyProfileData({required this.userProfiles});
}
