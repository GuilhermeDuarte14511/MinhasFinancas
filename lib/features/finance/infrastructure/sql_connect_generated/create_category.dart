part of 'client.dart';

class CreateCategoryVariablesBuilder {
  String spaceId;
  String name;
  String normalizedName;
  String icon;
  String colorHex;

  final FirebaseDataConnect _dataConnect;
  CreateCategoryVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.name,
    required this.normalizedName,
    required this.icon,
    required this.colorHex,
  });
  Deserializer<CreateCategoryData> dataDeserializer = (dynamic json) =>
      CreateCategoryData.fromJson(jsonDecode(json));
  Serializer<CreateCategoryVariables> varsSerializer =
      (CreateCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCategoryData, CreateCategoryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CreateCategoryData, CreateCategoryVariables> ref() {
    CreateCategoryVariables vars = CreateCategoryVariables(
      spaceId: spaceId,
      name: name,
      normalizedName: normalizedName,
      icon: icon,
      colorHex: colorHex,
    );
    return _dataConnect.mutation(
      "CreateCategory",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateCategoryCategory {
  final String id;
  CreateCategoryCategory.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCategoryCategory otherTyped = other as CreateCategoryCategory;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateCategoryCategory({required this.id});
}

@immutable
class CreateCategoryData {
  final CreateCategoryCategory category;
  CreateCategoryData.fromJson(dynamic json)
    : category = CreateCategoryCategory.fromJson(json['category']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCategoryData otherTyped = other as CreateCategoryData;
    return category == otherTyped.category;
  }

  @override
  int get hashCode => category.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['category'] = category.toJson();
    return json;
  }

  CreateCategoryData({required this.category});
}

@immutable
class CreateCategoryVariables {
  final String spaceId;
  final String name;
  final String normalizedName;
  final String icon;
  final String colorHex;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateCategoryVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      name = nativeFromJson<String>(json['name']),
      normalizedName = nativeFromJson<String>(json['normalizedName']),
      icon = nativeFromJson<String>(json['icon']),
      colorHex = nativeFromJson<String>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCategoryVariables otherTyped = other as CreateCategoryVariables;
    return spaceId == otherTyped.spaceId &&
        name == otherTyped.name &&
        normalizedName == otherTyped.normalizedName &&
        icon == otherTyped.icon &&
        colorHex == otherTyped.colorHex;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    name.hashCode,
    normalizedName.hashCode,
    icon.hashCode,
    colorHex.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['name'] = nativeToJson<String>(name);
    json['normalizedName'] = nativeToJson<String>(normalizedName);
    json['icon'] = nativeToJson<String>(icon);
    json['colorHex'] = nativeToJson<String>(colorHex);
    return json;
  }

  CreateCategoryVariables({
    required this.spaceId,
    required this.name,
    required this.normalizedName,
    required this.icon,
    required this.colorHex,
  });
}
