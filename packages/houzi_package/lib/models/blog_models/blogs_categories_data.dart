import 'dart:convert';

class BlogCategoriesData {
  bool? success;
  List<BlogCategory>? categoriesList;

  BlogCategoriesData({
    this.success,
    this.categoriesList,
  });

  factory BlogCategoriesData.fromRawJson(String str) => BlogCategoriesData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogCategoriesData.fromJson(Map<String, dynamic> json) => BlogCategoriesData(
    success: json["success"],
    categoriesList: json["result"] == null ? [] : List<BlogCategory>.from(json["result"]!.map((x) => BlogCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": categoriesList == null ? [] : List<dynamic>.from(categoriesList!.map((x) => x.toJson())),
  };
}

class BlogCategory {
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
  int? catId;
  int? categoryCount;
  String? categoryDescription;
  String? catName;
  String? categoryNicename;
  int? categoryParent;

  BlogCategory({
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
    this.catId,
    this.categoryCount,
    this.categoryDescription,
    this.catName,
    this.categoryNicename,
    this.categoryParent,
  });

  factory BlogCategory.fromRawJson(String str) => BlogCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogCategory.fromJson(Map<String, dynamic> json) => BlogCategory(
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
    catId: json["cat_ID"],
    categoryCount: json["category_count"],
    categoryDescription: json["category_description"],
    catName: json["cat_name"],
    categoryNicename: json["category_nicename"],
    categoryParent: json["category_parent"],
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
    "cat_ID": catId,
    "category_count": categoryCount,
    "category_description": categoryDescription,
    "cat_name": catName,
    "category_nicename": categoryNicename,
    "category_parent": categoryParent,
  };
}
