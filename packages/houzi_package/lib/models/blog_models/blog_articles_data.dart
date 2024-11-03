import 'dart:convert';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class BlogArticlesData {
    bool? success;
    int? count;
    List<BlogArticle>? articlesList;

    BlogArticlesData({
        this.success,
        this.count,
        this.articlesList,
    });

    factory BlogArticlesData.fromRawJson(String str) => BlogArticlesData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlogArticlesData.fromJson(Map<String, dynamic> json) => BlogArticlesData(
        success: json["success"],
        count: json["count"],
        articlesList: json["result"] == null ? [] : List<BlogArticle>.from(json["result"]!.map((x) => BlogArticle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "result": articlesList == null ? [] : List<dynamic>.from(articlesList!.map((x) => x.toJson())),
    };
}

class BlogArticle {
    int? id;
    String? postAuthor;
    DateTime? postDate;
    DateTime? postDateGmt;
    String? postDateFormatted;
    String? postContent;
    String? postTitle;
    String? postExcerpt;
    String? postStatus;
    String? commentStatus;
    String? pingStatus;
    String? postPassword;
    String? postName;
    String? toPing;
    String? pinged;
    DateTime? postModified;
    DateTime? postModifiedGmt;
    String? postModifiedFormatted;
    String? postContentFiltered;
    int? postParent;
    String? guid;
    int? menuOrder;
    String? postType;
    String? postMimeType;
    CommentCount? commentCount;
    String? filter;
    String? thumbnail;
    String? photo;
    BlogMeta? meta;
    BlogAuthor? author;
    List<BlogArticleCategory>? categories;
    List<BlogArticleCategory>? tags;

    BlogArticle({
        this.id,
        this.postAuthor,
        this.postDate,
        this.postDateGmt,
        this.postDateFormatted,
        this.postContent,
        this.postTitle,
        this.postExcerpt,
        this.postStatus,
        this.commentStatus,
        this.pingStatus,
        this.postPassword,
        this.postName,
        this.toPing,
        this.pinged,
        this.postModified,
        this.postModifiedGmt,
        this.postModifiedFormatted,
        this.postContentFiltered,
        this.postParent,
        this.guid,
        this.menuOrder,
        this.postType,
        this.postMimeType,
        this.commentCount,
        this.filter,
        this.thumbnail,
        this.photo,
        this.meta,
        this.author,
        this.categories,
        this.tags,
    });

    factory BlogArticle.fromRawJson(String str) => BlogArticle.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlogArticle.fromJson(Map<String, dynamic> json) => BlogArticle(
        id: json["ID"],
        postAuthor: json["post_author"],
        postDate: json["post_date"] == null ? null : DateTime.parse(json["post_date"]),
        postDateGmt: json["post_date_gmt"] == null ? null : DateTime.parse(json["post_date_gmt"]),
        postDateFormatted: json["post_date_gmt"] == null ? null: UtilityMethods.getTimeAgoFormat(time: json["post_date_gmt"]),
        postContent: json["post_content"],
        postTitle: json["post_title"],
        postExcerpt: json["post_excerpt"],
        postStatus: json["post_status"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        postPassword: json["post_password"],
        postName: json["post_name"],
        toPing: json["to_ping"],
        pinged: json["pinged"],
        postModified: json["post_modified"] == null ? null : DateTime.parse(json["post_modified"]),
        postModifiedGmt: json["post_modified_gmt"] == null ? null : DateTime.parse(json["post_modified_gmt"]),
        postModifiedFormatted: json["post_modified_gmt"] == null ? null : UtilityMethods.getTimeAgoFormat(time: json["post_modified_gmt"]),
        postContentFiltered: json["post_content_filtered"],
        postParent: json["post_parent"],
        guid: json["guid"],
        menuOrder: json["menu_order"],
        postType: json["post_type"],
        postMimeType: json["post_mime_type"],
        commentCount: json["comment_count"] == null ? null : CommentCount.fromJson(json["comment_count"]),
        filter: json["filter"],
        thumbnail: json["thumbnail"],
        photo: json["photo"],
        meta: json["meta"] == null ? null : BlogMeta.fromJson(json["meta"]),
        author: json["author"] == null ? null : BlogAuthor.fromJson(json["author"]),
        categories: json["categories"] == null ? [] : List<BlogArticleCategory>.from(json["categories"]!.map((x) => BlogArticleCategory.fromJson(x))),
        tags: json["tags"] == null ? [] : List<BlogArticleCategory>.from(json["tags"]!.map((x) => BlogArticleCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "post_author": postAuthor,
        "post_date": postDate?.toIso8601String(),
        "post_date_gmt": postDateGmt?.toIso8601String(),
        "post_date_formatted": postDateFormatted,
        "post_content": postContent,
        "post_title": postTitle,
        "post_excerpt": postExcerpt,
        "post_status": postStatus,
        "comment_status": commentStatus,
        "ping_status": pingStatus,
        "post_password": postPassword,
        "post_name": postName,
        "to_ping": toPing,
        "pinged": pinged,
        "post_modified": postModified?.toIso8601String(),
        "post_modified_gmt": postModifiedGmt?.toIso8601String(),
        "post_modified_formatted": postModifiedFormatted,
        "post_content_filtered": postContentFiltered,
        "post_parent": postParent,
        "guid": guid,
        "menu_order": menuOrder,
        "post_type": postType,
        "post_mime_type": postMimeType,
        "comment_count": commentCount?.toJson(),
        "filter": filter,
        "thumbnail": thumbnail,
        "photo": photo,
        "meta": meta?.toJson(),
        "author": author?.toJson(),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson())),
    };
}

class BlogAuthor {
    String? id;
    String? name;
    String? avatar;

    BlogAuthor({
        this.id,
        this.name,
        this.avatar,
    });

    factory BlogAuthor.fromRawJson(String str) => BlogAuthor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlogAuthor.fromJson(Map<String, dynamic> json) => BlogAuthor(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
    };
}

class BlogArticleCategory {
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

    BlogArticleCategory({
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

    factory BlogArticleCategory.fromRawJson(String str) => BlogArticleCategory.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlogArticleCategory.fromJson(Map<String, dynamic> json) => BlogArticleCategory(
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

class CommentCount {
    int? approved;
    int? awaitingModeration;
    int? spam;
    int? trash;
    int? postTrashed;
    int? all;
    int? totalComments;

    CommentCount({
        this.approved,
        this.awaitingModeration,
        this.spam,
        this.trash,
        this.postTrashed,
        this.all,
        this.totalComments,
    });

    factory CommentCount.fromRawJson(String str) => CommentCount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CommentCount.fromJson(Map<String, dynamic> json) => CommentCount(
        approved: json["approved"],
        awaitingModeration: json["awaiting_moderation"],
        spam: json["spam"],
        trash: json["trash"],
        postTrashed: json["post-trashed"],
        all: json["all"],
        totalComments: json["total_comments"],
    );

    Map<String, dynamic> toJson() => {
        "approved": approved,
        "awaiting_moderation": awaitingModeration,
        "spam": spam,
        "trash": trash,
        "post-trashed": postTrashed,
        "all": all,
        "total_comments": totalComments,
    };
}

class BlogMeta {
    List<String>? dpOriginal;
    List<String>? thumbnailId;
    List<String>? wxrImportHasAttachmentRefs;
    List<String>? editLock;
    List<String>? editLast;
    List<String>? onesignalMetaBoxPresent;
    List<String>? onesignalSendNotification;
    List<String>? onesignalModifyTitleAndContent;
    List<dynamic>? onesignalNotificationCustomHeading;
    List<dynamic>? onesignalNotificationCustomContent;
    List<String>? responseBody;
    List<String>? status;
    List<String>? recipients;
    List<String>? wpPageTemplate;
    List<String>? rsPageBgColor;
    List<String>? pingme;
    List<String>? encloseme;

    BlogMeta({
        this.dpOriginal,
        this.thumbnailId,
        this.wxrImportHasAttachmentRefs,
        this.editLock,
        this.editLast,
        this.onesignalMetaBoxPresent,
        this.onesignalSendNotification,
        this.onesignalModifyTitleAndContent,
        this.onesignalNotificationCustomHeading,
        this.onesignalNotificationCustomContent,
        this.responseBody,
        this.status,
        this.recipients,
        this.wpPageTemplate,
        this.rsPageBgColor,
        this.pingme,
        this.encloseme,
    });

    factory BlogMeta.fromRawJson(String str) => BlogMeta.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BlogMeta.fromJson(Map<String, dynamic> json) => BlogMeta(
        dpOriginal: json["_dp_original"] == null ? [] : List<String>.from(json["_dp_original"]!.map((x) => x)),
        thumbnailId: json["_thumbnail_id"] == null ? [] : List<String>.from(json["_thumbnail_id"]!.map((x) => x)),
        wxrImportHasAttachmentRefs: json["_wxr_import_has_attachment_refs"] == null ? [] : List<String>.from(json["_wxr_import_has_attachment_refs"]!.map((x) => x)),
        editLock: json["_edit_lock"] == null ? [] : List<String>.from(json["_edit_lock"]!.map((x) => x)),
        editLast: json["_edit_last"] == null ? [] : List<String>.from(json["_edit_last"]!.map((x) => x)),
        onesignalMetaBoxPresent: json["onesignal_meta_box_present"] == null ? [] : List<String>.from(json["onesignal_meta_box_present"]!.map((x) => x)),
        onesignalSendNotification: json["onesignal_send_notification"] == null ? [] : List<String>.from(json["onesignal_send_notification"]!.map((x) => x)),
        onesignalModifyTitleAndContent: json["onesignal_modify_title_and_content"] == null ? [] : List<String>.from(json["onesignal_modify_title_and_content"]!.map((x) => x)),
        onesignalNotificationCustomHeading: json["onesignal_notification_custom_heading"] == null ? [] : List<dynamic>.from(json["onesignal_notification_custom_heading"]!.map((x) => x)),
        onesignalNotificationCustomContent: json["onesignal_notification_custom_content"] == null ? [] : List<dynamic>.from(json["onesignal_notification_custom_content"]!.map((x) => x)),
        responseBody: json["response_body"] == null ? [] : List<String>.from(json["response_body"]!.map((x) => x)),
        status: json["status"] == null ? [] : List<String>.from(json["status"]!.map((x) => x)),
        recipients: json["recipients"] == null ? [] : List<String>.from(json["recipients"]!.map((x) => x)),
        wpPageTemplate: json["_wp_page_template"] == null ? [] : List<String>.from(json["_wp_page_template"]!.map((x) => x)),
        rsPageBgColor: json["rs_page_bg_color"] == null ? [] : List<String>.from(json["rs_page_bg_color"]!.map((x) => x)),
        pingme: json["_pingme"] == null ? [] : List<String>.from(json["_pingme"]!.map((x) => x)),
        encloseme: json["_encloseme"] == null ? [] : List<String>.from(json["_encloseme"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_dp_original": dpOriginal == null ? [] : List<dynamic>.from(dpOriginal!.map((x) => x)),
        "_thumbnail_id": thumbnailId == null ? [] : List<dynamic>.from(thumbnailId!.map((x) => x)),
        "_wxr_import_has_attachment_refs": wxrImportHasAttachmentRefs == null ? [] : List<dynamic>.from(wxrImportHasAttachmentRefs!.map((x) => x)),
        "_edit_lock": editLock == null ? [] : List<dynamic>.from(editLock!.map((x) => x)),
        "_edit_last": editLast == null ? [] : List<dynamic>.from(editLast!.map((x) => x)),
        "onesignal_meta_box_present": onesignalMetaBoxPresent == null ? [] : List<dynamic>.from(onesignalMetaBoxPresent!.map((x) => x)),
        "onesignal_send_notification": onesignalSendNotification == null ? [] : List<dynamic>.from(onesignalSendNotification!.map((x) => x)),
        "onesignal_modify_title_and_content": onesignalModifyTitleAndContent == null ? [] : List<dynamic>.from(onesignalModifyTitleAndContent!.map((x) => x)),
        "onesignal_notification_custom_heading": onesignalNotificationCustomHeading == null ? [] : List<dynamic>.from(onesignalNotificationCustomHeading!.map((x) => x)),
        "onesignal_notification_custom_content": onesignalNotificationCustomContent == null ? [] : List<dynamic>.from(onesignalNotificationCustomContent!.map((x) => x)),
        "response_body": responseBody == null ? [] : List<dynamic>.from(responseBody!.map((x) => x)),
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "recipients": recipients == null ? [] : List<dynamic>.from(recipients!.map((x) => x)),
        "_wp_page_template": wpPageTemplate == null ? [] : List<dynamic>.from(wpPageTemplate!.map((x) => x)),
        "rs_page_bg_color": rsPageBgColor == null ? [] : List<dynamic>.from(rsPageBgColor!.map((x) => x)),
        "_pingme": pingme == null ? [] : List<dynamic>.from(pingme!.map((x) => x)),
        "_encloseme": encloseme == null ? [] : List<dynamic>.from(encloseme!.map((x) => x)),
    };
}