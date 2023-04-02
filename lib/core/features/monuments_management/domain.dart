import 'package:equatable/equatable.dart';

class Monument extends Equatable {
  final String id;
  final String name;
  final String address;
  final String imageURL;
  final String description;

  const Monument({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageURL,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        description,
        imageURL,
      ];
}
