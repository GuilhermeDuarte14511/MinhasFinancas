part of 'client.dart';

class ArchiveCategoryVariablesBuilder {
  String spaceId;
  String categoryId;

  final FirebaseDataConnect _dataConnect;
  ArchiveCategoryVariablesBuilder(this._dataConnect, {required  this.spaceId,required  this.categoryId,});
  Deserializer<ArchiveCategoryData> dataDeserializer = (dynamic json)  => ArchiveCategoryData.fromJson(jsonDecode(json));
  Serializer<ArchiveCategoryVariables> varsSerializer = (ArchiveCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ArchiveCategoryData, ArchiveCategoryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ArchiveCategoryData, ArchiveCategoryVariables> ref() {
    ArchiveCategoryVariables vars= ArchiveCategoryVariables(spaceId: spaceId,categoryId: categoryId,);
    return _dataConnect.mutation("ArchiveCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ArchiveCategoryCategory {
  final String id;
  ArchiveCategoryCategory.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCategoryCategory otherTyped = other as ArchiveCategoryCategory;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ArchiveCategoryCategory({
    required this.id,
  });
}

@immutable
class ArchiveCategoryData {
  final ArchiveCategoryCategory? category;
  ArchiveCategoryData.fromJson(dynamic json):
  
  category = json['category'] == null ? null : ArchiveCategoryCategory.fromJson(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCategoryData otherTyped = other as ArchiveCategoryData;
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

  ArchiveCategoryData({
    this.category,
  });
}

@immutable
class ArchiveCategoryVariables {
  final String spaceId;
  final String categoryId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ArchiveCategoryVariables.fromJson(Map<String, dynamic> json):
  
  spaceId = nativeFromJson<String>(json['spaceId']),
  categoryId = nativeFromJson<String>(json['categoryId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ArchiveCategoryVariables otherTyped = other as ArchiveCategoryVariables;
    return spaceId == otherTyped.spaceId && 
    categoryId == otherTyped.categoryId;
    
  }
  @override
  int get hashCode => Object.hashAll([spaceId.hashCode, categoryId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['spaceId'] = nativeToJson<String>(spaceId);
    json['categoryId'] = nativeToJson<String>(categoryId);
    return json;
  }

  ArchiveCategoryVariables({
    required this.spaceId,
    required this.categoryId,
  });
}

