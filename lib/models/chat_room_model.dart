class ChatRoomModel {
  String? chatRoomId;
  List<String>? participants;

  ChatRoomModel({
    this.chatRoomId,
    this.participants,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chat_room_id'];
    participants = map['participants'];
  }

  Map<String, dynamic> toMap() => {
        'chat_room_id': chatRoomId,
        'participants': participants,
      };
}
