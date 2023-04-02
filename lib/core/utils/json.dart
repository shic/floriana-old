import 'package:flutter/material.dart';

extension DTRJson on DateTimeRange {
  Map<String, dynamic> toJson() {
    return {
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }
}

class Json {
  Json._();

  static DateTime parseUTCDate(
    String key, {
    required Map<String, dynamic> json,
  }) {
    return DateTime.fromMillisecondsSinceEpoch(json[key]! as int);
  }

  static DateTimeRange parseUTCDateRange(
    String key, {
    required Map<String, dynamic> json,
  }) {
    return DateTimeRange(
      start: parseUTCDate('start', json: json[key]!),
      end: parseUTCDate('end', json: json[key]!),
    );
  }

  static Iterable<T> parseIterable<T>(
    String key, {
    required Map<String, dynamic> json,
    T Function(dynamic)? parser,
    Iterable<T>? defaultValue,
  }) {
    final object = json[key];
    if (object == null && defaultValue != null) return defaultValue;
    return Iterable<T>.generate(
      json[key].length,
      (index) {
        final obj = json[key][index];
        if (parser == null) return obj as T;
        return parser(obj);
      },
    );
  }

  static List<T> parseList<T>(
    String key, {
    required Map<String, dynamic> json,
    T Function(dynamic)? parser,
    List<T>? defaultValue,
  }) {
    return parseIterable(key,
            json: json, parser: parser, defaultValue: defaultValue)
        .toList();
  }

  static T? parseOptional<T>(
    String key, {
    required Map<String, dynamic> json,
    T Function(dynamic)? parser,
  }) {
    final obj = json[key];
    if (obj == null) return null;
    if (parser == null) return obj as T;
    return parser(obj);
  }
}
