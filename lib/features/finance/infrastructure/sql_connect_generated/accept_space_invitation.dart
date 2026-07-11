part of 'client.dart';

class AcceptSpaceInvitationVariablesBuilder {
  String tokenHash;

  final FirebaseDataConnect _dataConnect;
  AcceptSpaceInvitationVariablesBuilder(
    this._dataConnect, {
    required this.tokenHash,
  });
  Deserializer<AcceptSpaceInvitationData> dataDeserializer = (dynamic json) =>
      AcceptSpaceInvitationData.fromJson(jsonDecode(json));
  Serializer<AcceptSpaceInvitationVariables> varsSerializer =
      (AcceptSpaceInvitationVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<AcceptSpaceInvitationData, AcceptSpaceInvitationVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<AcceptSpaceInvitationData, AcceptSpaceInvitationVariables> ref() {
    AcceptSpaceInvitationVariables vars = AcceptSpaceInvitationVariables(
      tokenHash: tokenHash,
    );
    return _dataConnect.mutation(
      "AcceptSpaceInvitation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class AcceptSpaceInvitationMember {
  final String id;
  AcceptSpaceInvitationMember.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationMember otherTyped =
        other as AcceptSpaceInvitationMember;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationMember({required this.id});
}

@immutable
class AcceptSpaceInvitationInvitation {
  final String id;
  AcceptSpaceInvitationInvitation.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationInvitation otherTyped =
        other as AcceptSpaceInvitationInvitation;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationInvitation({required this.id});
}

@immutable
class AcceptSpaceInvitationPreference {
  final String id;
  AcceptSpaceInvitationPreference.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationPreference otherTyped =
        other as AcceptSpaceInvitationPreference;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationPreference({required this.id});
}

@immutable
class AcceptSpaceInvitationClosingRule {
  final String id;
  AcceptSpaceInvitationClosingRule.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationClosingRule otherTyped =
        other as AcceptSpaceInvitationClosingRule;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationClosingRule({required this.id});
}

@immutable
class AcceptSpaceInvitationDueRule {
  final String id;
  AcceptSpaceInvitationDueRule.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationDueRule otherTyped =
        other as AcceptSpaceInvitationDueRule;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationDueRule({required this.id});
}

@immutable
class AcceptSpaceInvitationLoanRule {
  final String id;
  AcceptSpaceInvitationLoanRule.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationLoanRule otherTyped =
        other as AcceptSpaceInvitationLoanRule;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationLoanRule({required this.id});
}

@immutable
class AcceptSpaceInvitationAudit {
  final String id;
  AcceptSpaceInvitationAudit.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationAudit otherTyped =
        other as AcceptSpaceInvitationAudit;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptSpaceInvitationAudit({required this.id});
}

@immutable
class AcceptSpaceInvitationData {
  final AcceptSpaceInvitationMember member;
  final AcceptSpaceInvitationInvitation? invitation;
  final AcceptSpaceInvitationPreference preference;
  final AcceptSpaceInvitationClosingRule closingRule;
  final AcceptSpaceInvitationDueRule dueRule;
  final AcceptSpaceInvitationLoanRule loanRule;
  final AcceptSpaceInvitationAudit audit;
  AcceptSpaceInvitationData.fromJson(dynamic json)
    : member = AcceptSpaceInvitationMember.fromJson(json['member']),
      invitation = json['invitation'] == null
          ? null
          : AcceptSpaceInvitationInvitation.fromJson(json['invitation']),
      preference = AcceptSpaceInvitationPreference.fromJson(json['preference']),
      closingRule = AcceptSpaceInvitationClosingRule.fromJson(
        json['closingRule'],
      ),
      dueRule = AcceptSpaceInvitationDueRule.fromJson(json['dueRule']),
      loanRule = AcceptSpaceInvitationLoanRule.fromJson(json['loanRule']),
      audit = AcceptSpaceInvitationAudit.fromJson(json['audit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationData otherTyped =
        other as AcceptSpaceInvitationData;
    return member == otherTyped.member &&
        invitation == otherTyped.invitation &&
        preference == otherTyped.preference &&
        closingRule == otherTyped.closingRule &&
        dueRule == otherTyped.dueRule &&
        loanRule == otherTyped.loanRule &&
        audit == otherTyped.audit;
  }

  @override
  int get hashCode => Object.hashAll([
    member.hashCode,
    invitation.hashCode,
    preference.hashCode,
    closingRule.hashCode,
    dueRule.hashCode,
    loanRule.hashCode,
    audit.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['member'] = member.toJson();
    if (invitation != null) {
      json['invitation'] = invitation!.toJson();
    }
    json['preference'] = preference.toJson();
    json['closingRule'] = closingRule.toJson();
    json['dueRule'] = dueRule.toJson();
    json['loanRule'] = loanRule.toJson();
    json['audit'] = audit.toJson();
    return json;
  }

  AcceptSpaceInvitationData({
    required this.member,
    this.invitation,
    required this.preference,
    required this.closingRule,
    required this.dueRule,
    required this.loanRule,
    required this.audit,
  });
}

@immutable
class AcceptSpaceInvitationVariables {
  final String tokenHash;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  AcceptSpaceInvitationVariables.fromJson(Map<String, dynamic> json)
    : tokenHash = nativeFromJson<String>(json['tokenHash']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptSpaceInvitationVariables otherTyped =
        other as AcceptSpaceInvitationVariables;
    return tokenHash == otherTyped.tokenHash;
  }

  @override
  int get hashCode => tokenHash.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tokenHash'] = nativeToJson<String>(tokenHash);
    return json;
  }

  AcceptSpaceInvitationVariables({required this.tokenHash});
}
