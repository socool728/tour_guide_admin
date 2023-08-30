import 'package:tour_guide_admin/models/stop.dart';

class Tour{
  String id,title,starting_point,ending_point,source,description;
  int total_stop,total_time,time_stamp;
  double total_distance,startLat,startLng,endLat,endLng;
  List<String> imagesUrl;
  List<String> audiosUrl;
  List<String> videosUrl;

//<editor-fold desc="Data Methods">

  Tour({
    required this.id,
    required this.title,
    required this.starting_point,
    required this.ending_point,
    required this.source,
    required this.description,
    required this.total_stop,
    required this.total_time,
    required this.time_stamp,
    required this.total_distance,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.imagesUrl,
    required this.audiosUrl,
    required this.videosUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tour &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          starting_point == other.starting_point &&
          ending_point == other.ending_point &&
          source == other.source &&
          description == other.description &&
          total_stop == other.total_stop &&
          total_time == other.total_time &&
          time_stamp == other.time_stamp &&
          total_distance == other.total_distance &&
          startLat == other.startLat &&
          startLng == other.startLng &&
          endLat == other.endLat &&
          endLng == other.endLng &&
          imagesUrl == other.imagesUrl &&
          audiosUrl == other.audiosUrl &&
          videosUrl == other.videosUrl);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      starting_point.hashCode ^
      ending_point.hashCode ^
      source.hashCode ^
      description.hashCode ^
      total_stop.hashCode ^
      total_time.hashCode ^
      time_stamp.hashCode ^
      total_distance.hashCode ^
      startLat.hashCode ^
      startLng.hashCode ^
      endLat.hashCode ^
      endLng.hashCode ^
      imagesUrl.hashCode ^
      audiosUrl.hashCode ^
      videosUrl.hashCode;

  @override
  String toString() {
    return 'Tour{' +
        ' id: $id,' +
        ' title: $title,' +
        ' starting_point: $starting_point,' +
        ' ending_point: $ending_point,' +
        ' source: $source,' +
        ' description: $description,' +
        ' total_stop: $total_stop,' +
        ' total_time: $total_time,' +
        ' time_stamp: $time_stamp,' +
        ' total_distance: $total_distance,' +
        ' startLat: $startLat,' +
        ' startLng: $startLng,' +
        ' endLat: $endLat,' +
        ' endLng: $endLng,' +
        ' imagesUrl: $imagesUrl,' +
        ' audiosUrl: $audiosUrl,' +
        ' videosUrl: $videosUrl,' +
        '}';
  }

  Tour copyWith({
    String? id,
    String? title,
    String? starting_point,
    String? ending_point,
    String? source,
    String? description,
    int? total_stop,
    int? total_time,
    int? time_stamp,
    double? total_distance,
    double? startLat,
    double? startLng,
    double? endLat,
    double? endLng,
    List<String>? imagesUrl,
    List<String>? audiosUrl,
    List<String>? videosUrl,
  }) {
    return Tour(
      id: id ?? this.id,
      title: title ?? this.title,
      starting_point: starting_point ?? this.starting_point,
      ending_point: ending_point ?? this.ending_point,
      source: source ?? this.source,
      description: description ?? this.description,
      total_stop: total_stop ?? this.total_stop,
      total_time: total_time ?? this.total_time,
      time_stamp: time_stamp ?? this.time_stamp,
      total_distance: total_distance ?? this.total_distance,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      endLat: endLat ?? this.endLat,
      endLng: endLng ?? this.endLng,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      audiosUrl: audiosUrl ?? this.audiosUrl,
      videosUrl: videosUrl ?? this.videosUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'starting_point': this.starting_point,
      'ending_point': this.ending_point,
      'source': this.source,
      'description': this.description,
      'total_stop': this.total_stop,
      'total_time': this.total_time,
      'time_stamp': this.time_stamp,
      'total_distance': this.total_distance,
      'startLat': this.startLat,
      'startLng': this.startLng,
      'endLat': this.endLat,
      'endLng': this.endLng,
      'imagesUrl': this.imagesUrl,
      'audiosUrl': this.audiosUrl,
      'videosUrl': this.videosUrl,
    };
  }

  factory Tour.fromMap(Map<String, dynamic> map) {
    return Tour(
      id: map['id'] as String,
      title: map['title'] as String,
      starting_point: map['starting_point'] as String,
      ending_point: map['ending_point'] as String,
      source: map['source'] as String,
      description: map['description'] as String,
      total_stop: map['total_stop'] as int,
      total_time: map['total_time'] as int,
      time_stamp: map['time_stamp'] as int,
      total_distance: map['total_distance'] as double,
      startLat: map['startLat'] as double,
      startLng: map['startLng'] as double,
      endLat: map['endLat'] as double,
      endLng: map['endLng'] as double,
      imagesUrl: (map['imagesUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      audiosUrl: (map['audiosUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      videosUrl: (map['videosUrl'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),

    );
  }

//</editor-fold>
}