class AddAudio{
  String id,url;
  int timestamp;
  int duration;

//<editor-fold desc="Data Methods">

  AddAudio({
    required this.id,
    required this.url,
    required this.timestamp,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddAudio &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          timestamp == other.timestamp &&
          duration == other.duration);

  @override
  int get hashCode =>
      id.hashCode ^ url.hashCode ^ timestamp.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'AddAudio{' +
        ' id: $id,' +
        ' url: $url,' +
        ' timestamp: $timestamp,' +
        ' duration: $duration,' +
        '}';
  }

  AddAudio copyWith({
    String? id,
    String? url,
    int? timestamp,
    int? duration,
  }) {
    return AddAudio(
      id: id ?? this.id,
      url: url ?? this.url,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'timestamp': this.timestamp,
      'duration': this.duration,
    };
  }

  factory AddAudio.fromMap(Map<String, dynamic> map) {
    return AddAudio(
      id: map['id'] as String,
      url: map['url'] as String,
      timestamp: map['timestamp'] as int,
      duration: map['duration'] as int,
    );
  }

//</editor-fold>
}