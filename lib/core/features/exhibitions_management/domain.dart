import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/utils/json.dart';

enum ExhibitionStatus {
  visible,
  invisible,
  deleted,
}

class Exhibition extends Equatable {
  final String id;
  final String managerId;
  final String name;
  final String description;
  final DateTimeRange dateRange;

  final ExhibitionStatus status;

  final String? imageURL;
  final String address;

  final List<DateTime> unavailableDates;
  final Map<int, List<String>> workingHours;

  final List<String> artworkIds;

  final String? phone;
  final String? email;
  final int likes;
  final double? price;

  const Exhibition({
    required this.id,
    required this.managerId,
    required this.name,
    required this.description,
    required this.status,
    required this.address,
    required this.dateRange,
    required this.unavailableDates,
    required this.workingHours,
    required this.artworkIds,
    required this.likes,
    this.imageURL,
    this.phone,
    this.email,
    this.price,
  });

  Exhibition copyWith({
    String? managerId,
    String? name,
    String? description,
    DateTimeRange? dateRange,
    ExhibitionStatus? status,
    String? imageURL,
    String? address,
    List<DateTime>? unavailableDates,
    Map<int, List<String>>? workingHours,
    List<String>? artworkIds,
    String? phone,
    String? email,
    double? price,
  }) {
    return Exhibition(
      id: id,
      managerId: managerId ?? this.managerId,
      name: name ?? this.name,
      description: description ?? this.description,
      dateRange: dateRange ?? this.dateRange,
      status: status ?? this.status,
      imageURL: imageURL ?? this.imageURL,
      address: address ?? this.address,
      unavailableDates: unavailableDates ?? this.unavailableDates,
      workingHours: workingHours ?? this.workingHours,
      artworkIds: artworkIds ?? this.artworkIds,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      price: price ?? this.price,
      likes: likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'manager_id': managerId,
      'name': name,
      'description': description,
      'date_range': dateRange.toJson(),
      'status': status.name,
      'address': address,
      if (imageURL != null) 'image_url': imageURL,
      'unavailable_dates': unavailableDates,
      'working_hours': workingHours,
      'artwork_ids': artworkIds,
      'likes': likes,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (price != null) 'price': price,
    };
  }

  factory Exhibition.fromMap(Map<String, dynamic> map) {
    return Exhibition(
      id: map['id'] as String,
      managerId: map['manager_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      dateRange: Json.parseUTCDateRange('date_range', json: map),
      status: ExhibitionStatus.values.byName(map['status']),

      imageURL: map['image_url'] as String?,
      address: map['address'] as String,
      unavailableDates: Json.parseList(
        'unavailable_dates',
        json: map,
        parser: (d) => DateTime.fromMillisecondsSinceEpoch(d),
        defaultValue: [],
      ),
      workingHours: {},
      // map['working_hours'] as Map<int, List<String>>,
      artworkIds: Json.parseList('artwork_ids', json: map, defaultValue: []),
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      price: map['price'] as double?,
      likes: map['likes'] as int? ?? 0,
    );
  }

  static Map<String, dynamic> creationModel({
    required String managerId,
    required String name,
    required String description,
    required List<String> artworkIds,
    required String imageURL,
    required String address,
    required String phone,
    required String email,
    required ExhibitionStatus status,
    required DateTimeRange dateRange,
    required double price,
  }) {
    return {
      'manager_id': managerId,
      'name': name,
      'description': description,
      'image_url': imageURL,
      'address': address,
      'phone': phone,
      'email': email,
      'status': status.name,
      'artwork_ids': artworkIds,
      'date_range': dateRange.toJson(),
      'price': price,
      'likes': 0,
    };
  }

  @override
  List<Object?> get props => [
        id,
        managerId,
        name,
        description,
        dateRange,
        status,
        phone,
        email,
        imageURL,
        address,
        unavailableDates,
        workingHours,
        artworkIds,
        phone,
        email,
        price,
        likes,
      ];
}
