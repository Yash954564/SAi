import 'dart:convert';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class BlogCommentsData {
  bool? success;
  int? count;
  List<BlogComment>? commentsList;

  BlogCommentsData({
    this.success,
    this.count,
    this.commentsList,
  });

  factory BlogCommentsData.fromRawJson(String str) => BlogCommentsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogCommentsData.fromJson(Map<String, dynamic> json) => BlogCommentsData(
    success: json["success"],
    count: json["count"],
    commentsList: json["result"] == null ? [] : List<BlogComment>.from(json["result"]!.map((x) => BlogComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "result": commentsList == null ? [] : List<dynamic>.from(commentsList!.map((x) => x.toJson())),
  };
}

class BlogComment {
  String? commentId;
  String? commentPostId;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorUrl;
  String? commentAuthorIp;
  DateTime? commentDate;
  DateTime? commentDateGmt;
  String? commentDateFormatted;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? commentAuthorAvatar;

  BlogComment({
    this.commentId,
    this.commentPostId,
    this.commentAuthor,
    this.commentAuthorEmail,
    this.commentAuthorUrl,
    this.commentAuthorIp,
    this.commentDate,
    this.commentDateGmt,
    this.commentDateFormatted,
    this.commentContent,
    this.commentKarma,
    this.commentApproved,
    this.commentAgent,
    this.commentType,
    this.commentParent,
    this.userId,
    this.commentAuthorAvatar,
  });

  factory BlogComment.fromRawJson(String str) => BlogComment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlogComment.fromJson(Map<String, dynamic> json) => BlogComment(
    commentId: json["comment_ID"],
    commentPostId: json["comment_post_ID"],
    commentAuthor: json["comment_author"],
    commentAuthorEmail: json["comment_author_email"],
    commentAuthorUrl: json["comment_author_url"],
    commentAuthorIp: json["comment_author_IP"],
    commentDate: json["comment_date"] == null ? null : DateTime.parse(json["comment_date"]),
    commentDateGmt: json["comment_date_gmt"] == null ? null : DateTime.parse(json["comment_date_gmt"]),
    commentDateFormatted: json["comment_date_gmt"] == null ? null : UtilityMethods.getTimeAgoFormat(time: json["comment_date_gmt"]),
    commentContent: json["comment_content"],
    commentKarma: json["comment_karma"],
    commentApproved: json["comment_approved"],
    commentAgent: json["comment_agent"],
    commentType: json["comment_type"],
    commentParent: json["comment_parent"],
    userId: json["user_id"],
    commentAuthorAvatar: json["comment_author_avatar"],
  );

  Map<String, dynamic> toJson() => {
    "comment_ID": commentId,
    "comment_post_ID": commentPostId,
    "comment_author": commentAuthor,
    "comment_author_email": commentAuthorEmail,
    "comment_author_url": commentAuthorUrl,
    "comment_author_IP": commentAuthorIp,
    "comment_date": commentDate?.toIso8601String(),
    "comment_date_gmt": commentDateGmt?.toIso8601String(),
    "comment_date_formatted": commentDateFormatted,
    "comment_content": commentContent,
    "comment_karma": commentKarma,
    "comment_approved": commentApproved,
    "comment_agent": commentAgent,
    "comment_type": commentType,
    "comment_parent": commentParent,
    "user_id": userId,
    "comment_author_avatar": commentAuthorAvatar,
  };
}
