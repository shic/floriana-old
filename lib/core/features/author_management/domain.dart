import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String id;
  final String name;
  final String managerId;
  final String? url;

  const Author({
    required this.id,
    required this.name,
    required this.managerId,
    this.url,
  });

  static Map<String, dynamic> creationModel({
    required String managerId,
    required String name,
    String? url,
  }) {
    return {
      'manager_id': managerId,
      'name': name,
      if (url != null) 'url': url,
    };
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'manager_id': managerId, 'name': name, 'url': url};
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'] as String,
      managerId: map['manager_id'] as String,
      name: map['name'] as String,
      url: map['url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, url];

  Author copyWith({
    String? name,
    String? url,
  }) {
    return Author(
      id: id,
      managerId: managerId,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}
