enum MediaType {
  profile('profile'),
  image('image'),
  video('video'),
  chat('chat');

  const MediaType(this.value);
  final String value;

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MediaType.image,
    );
  }
}

class Media {
  final String id;
  final String userUid;
  final MediaType type;
  final String filename;
  final String path;
  final String url;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Media({
    required this.id,
    required this.userUid,
    required this.type,
    required this.filename,
    required this.path,
    required this.url,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id']?.toString() ?? '',
      userUid: json['user_uid']?.toString() ?? '',
      type: MediaType.fromString(json['type']?.toString() ?? 'image'),
      filename: json['filename']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_uid': userUid,
      'type': type.value,
      'filename': filename,
      'path': path,
      'url': url,
      'size': size,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Media copyWith({
    String? id,
    String? userUid,
    MediaType? type,
    String? filename,
    String? path,
    String? url,
    int? size,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Media(
      id: id ?? this.id,
      userUid: userUid ?? this.userUid,
      type: type ?? this.type,
      filename: filename ?? this.filename,
      path: path ?? this.path,
      url: url ?? this.url,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Media && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Media(id: $id, type: $type, filename: $filename)';
  }
}
