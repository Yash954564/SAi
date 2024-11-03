class AllMessageThreads {
  bool? success;
  List<MessageThread>? threadsList;

  AllMessageThreads({
    this.success,
    this.threadsList,
  });
}

class MessageThread {
  String? threadId;
  String? lastMessage;
  String? lastMessageAuthorId;
  String? lastMessageAuthorFirstName;
  String? lastMessageAuthorLastName;
  String? lastMessageAuthorDisplayName;
  String? lastMessageTime;
  DateTime? lastMessageTimeInDateTimeFormat;
  String? lastMessageTimeInTimeAgoFormat;
  String? seen;
  String? time;
  DateTime? timeInDateTimeFormat;
  String? timeInTimeAgoFormat;
  String? propertyId;
  String? propertyTitle;
  String? senderId;
  String? senderFirstName;
  String? senderLastName;
  String? senderDisplayName;
  String? senderPicture;
  String? senderStatus;
  String? receiverId;
  String? receiverFirstName;
  String? receiverLastName;
  String? receiverDisplayName;
  String? receiverPicture;
  String? receiverStatus;
  String? senderDelete;
  String? receiverDelete;

  MessageThread({
    this.threadId,
    this.lastMessage,
    this.lastMessageAuthorId,
    this.lastMessageAuthorFirstName,
    this.lastMessageAuthorLastName,
    this.lastMessageAuthorDisplayName,
    this.lastMessageTime,
    this.lastMessageTimeInDateTimeFormat,
    this.lastMessageTimeInTimeAgoFormat,
    this.seen,
    this.time,
    this.timeInDateTimeFormat,
    this.timeInTimeAgoFormat,
    this.propertyId,
    this.propertyTitle,
    this.senderId,
    this.senderFirstName,
    this.senderLastName,
    this.senderDisplayName,
    this.senderPicture,
    this.senderStatus,
    this.receiverId,
    this.receiverFirstName,
    this.receiverLastName,
    this.receiverDisplayName,
    this.receiverPicture,
    this.receiverStatus,
    this.senderDelete,
    this.receiverDelete,
  });
}