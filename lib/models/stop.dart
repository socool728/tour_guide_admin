class Stop {
  String id, tour_id, name, description;
  int time_stamp, stop_number;
  double latitude, longitude;
  List<String> stopImagesUrl;
  List<String> stopAudiosUrl;
  List<String> stopVideosUrl;

//<editor-fold desc="Data Methods">

  Stop({
    required this.id,
    required this.tour_id,
    required this.name,
    required this.description,
    required this.time_stamp,
    required this.stop_number,
    required this.latitude,
    required this.longitude,
    required this.stopImagesUrl,
    required this.stopAudiosUrl,
    required this.stopVideosUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stop &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tour_id == other.tour_id &&
          name == other.name &&
          description == other.description &&
          time_stamp == other.time_stamp &&
          stop_number == other.stop_number &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          stopImagesUrl == other.stopImagesUrl &&
          stopAudiosUrl == other.stopAudiosUrl &&
          stopVideosUrl == other.stopVideosUrl);

  @override
  int get hashCode =>
      id.hashCode ^
      tour_id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      time_stamp.hashCode ^
      stop_number.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      stopImagesUrl.hashCode ^
      stopAudiosUrl.hashCode ^
      stopVideosUrl.hashCode;

  @override
  String toString() {
    return 'Stop{' +
        ' id: $id,' +
        ' tour_id: $tour_id,' +
        ' name: $name,' +
        ' description: $description,' +
        ' time_stamp: $time_stamp,' +
        ' stop_number: $stop_number,' +
        ' latitude: $latitude,' +
        ' longitude: $longitude,' +
        ' stopImagesUrl: $stopImagesUrl,' +
        ' stopAudiosUrl: $stopAudiosUrl,' +
        ' stopVideosUrl: $stopVideosUrl,' +
        '}';
  }

  Stop copyWith({
    String? id,
    String? tour_id,
    String? name,
    String? description,
    int? time_stamp,
    int? stop_number,
    double? latitude,
    double? longitude,
    List<String>? stopImagesUrl,
    List<String>? stopAudiosUrl,
    List<String>? stopVideosUrl,
  }) {
    return Stop(
      id: id ?? this.id,
      tour_id: tour_id ?? this.tour_id,
      name: name ?? this.name,
      description: description ?? this.description,
      time_stamp: time_stamp ?? this.time_stamp,
      stop_number: stop_number ?? this.stop_number,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      stopImagesUrl: stopImagesUrl ?? this.stopImagesUrl,
      stopAudiosUrl: stopAudiosUrl ?? this.stopAudiosUrl,
      stopVideosUrl: stopVideosUrl ?? this.stopVideosUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'tour_id': this.tour_id,
      'name': this.name,
      'description': this.description,
      'time_stamp': this.time_stamp,
      'stop_number': this.stop_number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'stopImagesUrl': this.stopImagesUrl,
      'stopAudiosUrl': this.stopAudiosUrl,
      'stopVideosUrl': this.stopVideosUrl,
    };
  }

  factory Stop.fromMap(Map<String, dynamic> map) {
    return Stop(
      id: map['id'] as String,
      tour_id: map['tour_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      time_stamp: map['time_stamp'] as int,
      stop_number: map['stop_number'] as int,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      stopImagesUrl: (map['stopImagesUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      stopAudiosUrl: (map['stopAudiosUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      stopVideosUrl: (map['stopVideosUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }

//</editor-fold>
}
