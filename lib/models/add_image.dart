class AddImage{
  String id,url;
  int timestamp;

//<editor-fold desc="Data Methods">

  AddImage({
    required this.id,
    required this.url,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddImage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          timestamp == other.timestamp);

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'AddImage{' +
        ' id: $id,' +
        ' url: $url,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  AddImage copyWith({
    String? id,
    String? url,
    int? timestamp,
  }) {
    return AddImage(
      id: id ?? this.id,
      url: url ?? this.url,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'timestamp': this.timestamp,
    };
  }

  factory AddImage.fromMap(Map<String, dynamic> map) {
    return AddImage(
      id: map['id'] as String,
      url: map['url'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

//</editor-fold>
}