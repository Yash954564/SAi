import 'dart:convert';

class BlogTagsData {
  bool? success;
  List<BlogTag>? tagsList;

  BlogTagsData({
    this.success,
    this.tagsList,
  });

  factory BlogTagsData.fromRawJson(String str) => BlogTagsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogTagsData.fromJson(Map<String, dynamic> json) => BlogTagsData(
    success: json["success"],
    tagsList: json["result"] == null ? [] : List<BlogTag>.from(json["result"]!.map((x) => BlogTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": tagsList == null ? [] : List<dynamic>.from(tagsList!.map((x) => x.toJson())),
  };
}

class BlogTag {
  int? termId;
  String? name;
  String? slug;
  int? termGroup;
  int? termTaxonomyId;
  String? taxonomy;
  String? description;
  int? parent;
  int? count;
  String? filter;

  BlogTag({
    this.termId,
    this.name,
    this.slug,
    this.termGroup,
    this.termTaxonomyId,
    this.taxonomy,
    this.description,
    this.parent,
    this.count,
    this.filter,
  });

  factory BlogTag.fromRawJson(String str) => BlogTag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogTag.fromJson(Map<String, dynamic> json) => BlogTag(
    termId: json["term_id"],
    name: json["name"],
    slug: json["slug"],
    termGroup: json["term_group"],
    termTaxonomyId: json["term_taxonomy_id"],
    taxonomy: json["taxonomy"],
    description: json["description"],
    parent: json["parent"],
    count: json["count"],
    filter: json["filter"],
  );

  Map<String, dynamic> toJson() => {
    "term_id": termId,
    "name": name,
    "slug": slug,
    "term_group": termGroup,
    "term_taxonomy_id": termTaxonomyId,
    "taxonomy": taxonomy,
    "description": description,
    "parent": parent,
    "count": count,
    "filter": filter,
  };
}
