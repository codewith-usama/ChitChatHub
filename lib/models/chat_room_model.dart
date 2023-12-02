class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? createdOn;

  ChatRoomModel({
    this.chatRoomId,
    this.participants,
    this.lastMessage,
    this.createdOn,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chat_room_id'];
    participants = map['participants'];
    lastMessage = map['last_message'];
    createdOn = map['created_on'];
  }

  Map<String, dynamic> toMap() => {
        'chat_room_id': chatRoomId,
        'participants': participants,
        'last_message': lastMessage,
        'created_on': createdOn,
      };
}
