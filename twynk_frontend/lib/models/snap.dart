enum SnapVisibility {
  public('Pública'),
  private('Privada');

  const SnapVisibility(this.displayName);
  
  final String displayName;
}

class Snap {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String videoUrl;
  final String description;
  final SnapVisibility visibility;
  final DateTime createdAt;
  final int likes;
  final int dislikes;
  final int comments;

  const Snap({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.videoUrl,
    required this.description,
    required this.visibility,
    required this.createdAt,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = 0,
  });

  factory Snap.fromJson(Map<String, dynamic> json) {
    return Snap(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      videoUrl: json['videoUrl'] as String,
      description: json['description'] as String,
      visibility: SnapVisibility.values.firstWhere(
        (v) => v.name == json['visibility'],
        orElse: () => SnapVisibility.public,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'videoUrl': videoUrl,
      'description': description,
      'visibility': visibility.name,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
    };
  }

  Snap copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? videoUrl,
    String? description,
    SnapVisibility? visibility,
    DateTime? createdAt,
    int? likes,
    int? dislikes,
    int? comments,
  }) {
    return Snap(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      comments: comments ?? this.comments,
    );
  }
}
