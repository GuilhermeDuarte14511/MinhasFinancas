part of 'client.dart';

class UpdateCategoryVariablesBuilder {
  String spaceId;
  String categoryId;
  String name;
  String normalizedName;

  final FirebaseDataConnect _dataConnect;
  UpdateCategoryVariablesBuilder(
    this._dataConnect, {
    required this.spaceId,
    required this.categoryId,
    required this.name,
    required this.normalizedName,
  });
  Deserializer<UpdateCategoryData> dataDeserializer = (dynamic json) =>
      UpdateCategoryData.fromJson(jsonDecode(json));
  Serializer<UpdateCategoryVariables> varsSerializer =
      (UpdateCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCategoryData, UpdateCategoryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateCategoryData, UpdateCategoryVariables> ref() {
    UpdateCategoryVariables vars = UpdateCategoryVariables(
      spaceId: spaceId,
      categoryId: categoryId,
      name: name,
      normalizedName: normalizedName,
    );
    return _dataConnect.mutation(
      "UpdateCategory",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateCategoryCategory {
  final String id;
  UpdateCategoryCategory.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryCategory otherTyped = other as UpdateCategoryCategory;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCategoryCategory({required this.id});
}

@immutable
class UpdateCategoryData {
  final UpdateCategoryCategory? category;
  UpdateCategoryData.fromJson(dynamic json)
    : category = json['category'] == null
          ? null
          : UpdateCategoryCategory.fromJson(json['category']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryData otherTyped = other as UpdateCategoryData;
    return category == otherTyped.category;
  }

  @override
  int get hashCode => category.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (category != null) {
      json['category'] = category!.toJson();
    }
    return json;
  }

  UpdateCategoryData({this.category});
}

@immutable
class UpdateCategoryVariables {
  final String spaceId;
  final String categoryId;
  final String name;
  final String normalizedName;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateCategoryVariables.fromJson(Map<String, dynamic> json)
    : spaceId = nativeFromJson<String>(json['spaceId']),
      categoryId = nativeFromJson<String>(json['categoryId']),
      name = nativeFromJson<String>(json['name']),
      normalizedName = nativeFromJson<String>(json['normalizedName']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryVariables otherTyped = other as UpdateCategoryVariables;
    return spaceId == otherTyped.spaceId &&
        categoryId == otherTyped.categoryId &&
        name == otherTyped.name &&
        normalizedName == otherTyped.normalizedName;
  }

  @override
  int get hashCode => Object.hashAll([
    spaceId.hashCode,
    categoryId.hashCode,
    name.hashCode,
    normalizedName.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    json['name'] = nativeToJson<String>(name);
    json['normalizedName'] = nativeToJson<String>(normalizedName);
    return json;
  }

  UpdateCategoryVariables({
    required this.spaceId,
    required this.categoryId,
    required this.name,
    required this.normalizedName,
  });
}
