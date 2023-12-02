class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({
    this.chatRoomId,
    this.participants,
    this.lastMessage,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chat_room_id'];
    participants = map['participants'];
    lastMessage = map['last_message'];
  }

  Map<String, dynamic> toMap() => {
        'chat_room_id': chatRoomId,
        'participants': participants,
        'last_message': lastMessage,
      };
}
