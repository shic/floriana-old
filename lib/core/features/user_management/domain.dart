import 'package:equatable/equatable.dart';
import 'package:myguide/core/utils/json.dart';

class User extends Equatable {
  final String id;
  final List<String> favorites;
  final String? displayName;
  final String? avatar;
  final String? website;

  const User({
    required this.id,
    this.favorites = const [],
    this.displayName,
    this.avatar,
    this.website,
  });

  @override
  List<Object?> get props => [id, favorites, displayName, avatar];

  Map<String, dynamic> toMap() => {
        'id': id,
        'favorites': favorites,
        'display_name': displayName,
        'avatar': avatar,
        'website': website,
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      favorites: Json.parseList('favorites', json: map, defaultValue: []),
      displayName: map['display_name'] as String?,
      avatar: map['avatar'] as String?,
      website: map['website'] as String?,
    );
  }

  User copyWith({
    String? id,
    List<String>? favorites,
    String? displayName,
    String? avatar,
    String? website,
  }) {
    return User(
      id: id ?? this.id,
      favorites: favorites ?? this.favorites,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      website: website ?? this.website,
    );
  }
}
