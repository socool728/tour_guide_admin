class Notification {
  String id;
  String title;
  String? subtitle, url;
  String type, refId;
  bool read;
  int timestamp;
  String? trailing_image_url, leading_image_url;
  Map<String, dynamic> data;

//<editor-fold desc="Data Methods">

  Notification({
    required this.id,
    required this.title,
    this.subtitle,
    this.url,
    required this.type,
    required this.refId,
    required this.read,
    required this.timestamp,
    this.trailing_image_url,
    this.leading_image_url,
    required this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Notification &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              subtitle == other.subtitle &&
              url == other.url &&
              type == other.type &&
              refId == other.refId &&
              read == other.read &&
              timestamp == other.timestamp &&
              trailing_image_url == other.trailing_image_url &&
              leading_image_url == other.leading_image_url &&
              data == other.data);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      url.hashCode ^
      type.hashCode ^
      refId.hashCode ^
      read.hashCode ^
      timestamp.hashCode ^
      trailing_image_url.hashCode ^
      leading_image_url.hashCode ^
      data.hashCode;

  @override
  String toString() {
    return 'Notification{' +
        ' id: $id,' +
        ' title: $title,' +
        ' subtitle: $subtitle,' +
        ' url: $url,' +
        ' type: $type,' +
        ' refId: $refId,' +
        ' read: $read,' +
        ' timestamp: $timestamp,' +
        ' trailing_image_url: $trailing_image_url,' +
        ' leading_image_url: $leading_image_url,' +
        ' data: $data,' +
        '}';
  }

  Notification copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? url,
    String? type,
    String? refId,
    bool? read,
    int? timestamp,
    String? trailing_image_url,
    String? leading_image_url,
    Map<String, dynamic>? data,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      url: url ?? this.url,
      type: type ?? this.type,
      refId: refId ?? this.refId,
      read: read ?? this.read,
      timestamp: timestamp ?? this.timestamp,
      trailing_image_url: trailing_image_url ?? this.trailing_image_url,
      leading_image_url: leading_image_url ?? this.leading_image_url,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'subtitle': this.subtitle,
      'url': this.url,
      'type': this.type,
      'refId': this.refId,
      'read': this.read,
      'timestamp': this.timestamp,
      'trailing_image_url': this.trailing_image_url,
      'leading_image_url': this.leading_image_url,
      'data': this.data,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      type: map['type'] as String,
      refId: map['refId'] as String,
      read: map['read'] as bool,
      timestamp: map['timestamp'] as int,
      trailing_image_url: map['trailing_image_url'] as String?,
      leading_image_url: map['leading_image_url'] as String?,
      data: map['data'] as Map<String, dynamic>,
      url: map['url'] as String?,
    );
  }

//</editor-fold>
}