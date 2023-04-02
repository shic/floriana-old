import 'package:equatable/equatable.dart';
import 'package:myguide/core/utils/json.dart';

enum ArtworkStatus {
  visible,
  invisible,
  deleted,
}

class Artwork extends Equatable {
  final String id;
  final String name;
  final String managerId;
  final String? description;
  final List<String> images;
  final String? authorId;
  final ArtworkStatus status;
  final ArtworkSize size;
  final String? material;
  final String? place;
  final String? year;
  final String? openSeaURL;
  final int likes;

  const Artwork({
    required this.id,
    required this.name,
    required this.managerId,
    required this.images,
    required this.size,
    required this.status,
    required this.likes,
    this.description,
    this.material,
    this.authorId,
    this.place,
    this.year,
    this.openSeaURL,
  });

  static Map<String, dynamic> creationModel({
    required String managerId,
    required String name,
    required List<String> images,
    required ArtworkSize artworkSize,
    required ArtworkStatus status,
    String? description,
    String? material,
    String? openSeaURL,
    String? authorId,
    String? place,
    String? year,
  }) {
    return {
      'manager_id': managerId,
      'name': name,
      'description': description,
      'image_urls': images,
      'material': material,
      'size': artworkSize.toMap(),
      'status': status.name,
      'open_sea_url': openSeaURL,
      'author_id': authorId,
      'place': place,
      'year': year,
      'likes': 0,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'manager_id': managerId,
      'description': description,
      'image_urls': images,
      'material': material,
      'size': size.toMap(),
      'status': status.name,
      'author_id': authorId,
      'place': place,
      'year': year,
      'open_sea_url': openSeaURL,
      'likes': likes,
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'] as String,
      name: map['name'] as String,
      managerId: map['manager_id'] as String,
      description: map['description'] as String?,
      images: Json.parseList('image_urls', json: map),
      material: map['material'] as String?,
      size: ArtworkSize.fromMap(map['size']),
      status: ArtworkStatus.values.byName(map['status']),
      authorId: map['author_id'] as String?,
      place: map['place'] as String?,
      year: map['year'] as String?,
      likes: map['likes'] as int? ?? 0,
      openSeaURL: map['open_sea_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        material,
        size,
        status,
        authorId,
        place,
        openSeaURL,
        likes,
      ];
}

class ArtworkSize extends Equatable {
  final double? width;
  final double? height;
  final double? depth;

  const ArtworkSize({
    this.width,
    this.height,
    this.depth,
  });

  Map<String, dynamic> toMap() =>
      {'width': width, 'height': height, 'depth': depth};

  factory ArtworkSize.fromMap(Map<String, dynamic> map) {
    return ArtworkSize(
      width: map['width'] as double?,
      height: map['height'] as double?,
      depth: map['depth'] as double?,
    );
  }

  @override
  String toString() {
    final components = [
      if (width != null) width.toString(),
      if (height != null) height.toString(),
      if (depth != null) depth.toString(),
    ];
    if (components.isEmpty) return '';
    final partial = components.join(' x ');
    return '$partial cm';
  }

  @override
  List<Object?> get props => [width, height, depth];
}
