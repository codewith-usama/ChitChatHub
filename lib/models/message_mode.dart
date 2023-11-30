class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
    this.messageId,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map['message_id'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdOn = map['createdOn'].toDate();
  }

  Map<String, dynamic> toMap() => {
        'message_id': messageId,
        'sender': sender,
        'text': text,
        'seen': seen,
        'createdOn': createdOn,
      };
}
