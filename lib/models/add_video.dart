class AddVideo{
  String id,url,thumbnail;
  int timestamp;
  int video_sec;

//<editor-fold desc="Data Methods">


  AddVideo({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.timestamp,
    required this.video_sec,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AddVideo &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              url == other.url &&
              thumbnail == other.thumbnail &&
              timestamp == other.timestamp &&
              video_sec == other.video_sec
          );


  @override
  int get hashCode =>
      id.hashCode ^
      url.hashCode ^
      thumbnail.hashCode ^
      timestamp.hashCode ^
      video_sec.hashCode;


  @override
  String toString() {
    return 'AddVideo{' +
        ' id: $id,' +
        ' url: $url,' +
        ' thumbnail: $thumbnail,' +
        ' timestamp: $timestamp,' +
        ' video_sec: $video_sec,' +
        '}';
  }


  AddVideo copyWith({
    String? id,
    String? url,
    String? thumbnail,
    int? timestamp,
    int? video_sec,
  }) {
    return AddVideo(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      timestamp: timestamp ?? this.timestamp,
      video_sec: video_sec ?? this.video_sec,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'thumbnail': this.thumbnail,
      'timestamp': this.timestamp,
      'video_sec': this.video_sec,
    };
  }

  factory AddVideo.fromMap(Map<String, dynamic> map) {
    return AddVideo(
      id: map['id'] as String,
      url: map['url'] as String,
      thumbnail: map['thumbnail'] as String,
      timestamp: map['timestamp'] as int,
      video_sec: map['video_sec'] as int,
    );
  }


//</editor-fold>
}