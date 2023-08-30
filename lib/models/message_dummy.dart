class MessageDummy {
  String receiver_id;
  String last_message;
  int timestamp;

  MessageDummy({
    required this.receiver_id,
    required this.last_message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiver_id': this.receiver_id,
      'last_message': this.last_message,
      'timestamp': this.timestamp,
    };
  }

  factory MessageDummy.fromMap(Map<String, dynamic> map) {
    return MessageDummy(
      receiver_id: map['receiver_id'] as String,
      last_message: map['last_message'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}
