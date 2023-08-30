class Message {
  String id;
  int timestamp;
  String text, sender_id, receiver_id;
  String message_type;
  String? fileUrl;
  String? fileExt;
  String? imageUrl;
  String? post_id;
  Map<String, dynamic>? optionalData;

//<editor-fold desc="Data Methods">

  Message({
    required this.id,
    required this.timestamp,
    required this.text,
    required this.sender_id,
    required this.receiver_id,
    required this.message_type,
    this.fileUrl,
    this.fileExt,
    this.imageUrl,
    this.post_id,
    this.optionalData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          text == other.text &&
          sender_id == other.sender_id &&
          receiver_id == other.receiver_id &&
          message_type == other.message_type &&
          fileUrl == other.fileUrl &&
          fileExt == other.fileExt &&
          imageUrl == other.imageUrl &&
          post_id == other.post_id &&
          optionalData == other.optionalData);

  @override
  int get hashCode =>
      id.hashCode ^
      timestamp.hashCode ^
      text.hashCode ^
      sender_id.hashCode ^
      receiver_id.hashCode ^
      message_type.hashCode ^
      fileUrl.hashCode ^
      fileExt.hashCode ^
      imageUrl.hashCode ^
      post_id.hashCode ^
      optionalData.hashCode;

  @override
  String toString() {
    return 'Message{' +
        ' id: $id,' +
        ' timestamp: $timestamp,' +
        ' text: $text,' +
        ' sender_id: $sender_id,' +
        ' receiver_id: $receiver_id,' +
        ' message_type: $message_type,' +
        ' fileUrl: $fileUrl,' +
        ' fileExt: $fileExt,' +
        ' imageUrl: $imageUrl,' +
        ' post_id: $post_id,' +
        ' optionalData: $optionalData,' +
        '}';
  }

  Message copyWith({
    String? id,
    int? timestamp,
    String? text,
    String? sender_id,
    String? receiver_id,
    String? message_type,
    String? fileUrl,
    String? fileExt,
    String? imageUrl,
    String? post_id,
    Map<String, dynamic>? optionalData,
  }) {
    return Message(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      text: text ?? this.text,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      message_type: message_type ?? this.message_type,
      fileUrl: fileUrl ?? this.fileUrl,
      fileExt: fileExt ?? this.fileExt,
      imageUrl: imageUrl ?? this.imageUrl,
      post_id: post_id ?? this.post_id,
      optionalData: optionalData ?? this.optionalData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'timestamp': this.timestamp,
      'text': this.text,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'message_type': this.message_type,
      'fileUrl': this.fileUrl,
      'fileExt': this.fileExt,
      'imageUrl': this.imageUrl,
      'post_id': this.post_id,
      'optionalData': this.optionalData,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      timestamp: map['timestamp'] as int,
      text: map['text'] as String,
      sender_id: map['sender_id'] as String,
      receiver_id: map['receiver_id'] as String,
      message_type: map['message_type'] as String,
      fileUrl: map['fileUrl'] as String?,
      fileExt: map['fileExt'] as String?,
      imageUrl: map['imageUrl'] as String?,
      post_id: map['post_id'] as String?,
      optionalData: map['optionalData'] as Map<String, dynamic>?,
    );
  }

//</editor-fold>
}
