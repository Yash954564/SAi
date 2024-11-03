import 'dart:convert';

class Term {
  int? id;
  int? parent;
  int? totalPropertiesCount;
  String? name;
  String? slug;
  String? thumbnail;
  String? fullImage;
  String? taxonomy;
  String? parentTerm;

  Term({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.thumbnail,
    this.taxonomy,
    this.fullImage,
    this.totalPropertiesCount,
    this.parentTerm,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parent: json['parent'],
      thumbnail: json['thumbnail'],
      taxonomy: json['taxonomy'],
      fullImage: json['fullImage'],
      totalPropertiesCount: json['totalPropertiesCount'],
      parentTerm: json['fave_parent_term'],
    );
  }

  static Map<String, dynamic> toMap(Term propertyMetaData) => {
        'id': propertyMetaData.id,
        'name': propertyMetaData.name,
        'slug': propertyMetaData.slug,
        'parent': propertyMetaData.parent,
        'thumbnail': propertyMetaData.thumbnail,
        'fullImage': propertyMetaData.fullImage,
        'taxonomy': propertyMetaData.taxonomy,
        'totalPropertiesCount': propertyMetaData.totalPropertiesCount,
        'fave_parent_term': propertyMetaData.parentTerm,
      };

  static String encode(List<dynamic> propertyMetaDataList) {
    return json.encode(propertyMetaDataList
        .map<Map<String, dynamic>>((item) => Term.toMap(item))
        .toList());
  }

  static List<dynamic> decode(String propertyMetaDataList) {
    return (json.decode(propertyMetaDataList) as List<dynamic>)
        .map<Term>((item) => Term.fromJson(item))
        .toList();
  }

  @override
  bool operator == (Object other){
    return other is Term && slug == other.slug;
  }
}
