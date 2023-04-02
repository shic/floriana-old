import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

export 'package:cloud_firestore/cloud_firestore.dart';

typedef DbConverter<T> = T Function(String id, Map<String, dynamic>? map);

class Where<T> {
  final Object field;
  final String op;
  final Object? target;

  const Where(this.field, this.op, this.target);

  const Where.equals({
    required this.field,
    this.target,
  }) : op = '==';

  const Where.lessThan({
    required this.field,
    this.target,
  }) : op = '<';

  const Where.greaterThan({
    required this.field,
    this.target,
  }) : op = '>';

  const Where.lessThanOrEqual({
    required this.field,
    this.target,
  }) : op = '<=';

  const Where.greaterThanOrEqual({
    required this.field,
    this.target,
  }) : op = '>=';

  Where.documentIdWhereIn({
    required List<String> this.target,
  })  : op = 'where-in',
        field = FieldPath.documentId;

  Query<V> apply<V>(Query<V> query) {
    switch (op) {
      case '==':
        return query.where(field, isEqualTo: target);
      case 'where-in':
        return query.where(field, whereIn: target as List<String>);
      case '>':
        return query.where(field, isGreaterThan: target);
      case '<':
        return query.where(field, isLessThan: target);
      case '>=':
        return query.where(field, isGreaterThanOrEqualTo: target);
      case '<=':
        return query.where(field, isLessThanOrEqualTo: target);
      default:
        throw UnsupportedError('$op is not supported');
    }
  }
}

class DBService {
  static DBService? _dbService;

  static DBService get shared => _dbService ??= DBService();

  DBService() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<T> doc$<T>({
    required String path,
    required DbConverter<T> converter,
  }) {
    return _firestore.doc(path).snapshots().map((event) {
      return converter(event.id, event.data());
    });
  }

  Future<T> doc<T>({
    required String path,
    required DbConverter<T> converter,
  }) async {
    final doc = await _firestore.doc(path).get();
    return converter(doc.id, doc.data());
  }

  Stream<Iterable<T>> collection$<T>({
    required String path,
    required DbConverter<T> converter,
    Iterable<Where> where = const [],
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    for (final where in where) {
      query = where.apply(query);
    }
    return query.snapshots().map((event) {
      return event.docs.map((e) => converter(e.id, e.data()));
    });
  }

  Future<Iterable<T>> collection<T>({
    required String path,
    required DbConverter<T> converter,
    Iterable<Where> where = const [],
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    for (final where in where) {
      query = where.apply(query);
    }
    final collection = await query.get();
    return List.generate(
      collection.size,
      (index) {
        final object = collection.docs.elementAt(index);
        return converter(object.id, object.data());
      },
    );
  }

  Future<void> batch({
    required Iterable<Operation> operations,
  }) async {
    final batch = _firestore.batch();
    for (final operation in operations) {
      switch (operation.type) {
        case OperationType.create:
          break;
        case OperationType.update:
          final op = operation as UpdateOperation;
          batch.update(_firestore.doc(op.path), op.data);
          break;
        case OperationType.delete:
          break;
      }
    }
    await batch.commit();
  }

  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.doc(path).set(data, SetOptions(merge: true));
  }

  Future<void> delete({required String path}) async {
    await _firestore.doc(path).delete();
  }

  Future<void> create({
    required String prefix,
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final id = _firestore.collection(collectionPath).doc().id;
    final resultingId = '$prefix-$id';
    return await _firestore.collection(collectionPath).doc(resultingId).set(
      {'id': resultingId, ...data},
    );
  }
}

enum OperationType { create, update, delete }

abstract class Operation {
  const Operation({
    required this.type,
  });

  final OperationType type;
}

class UpdateOperation extends Operation {
  UpdateOperation({
    required this.path,
    required this.data,
  }) : super(type: OperationType.update);
  final String path;
  final Map<String, dynamic> data;
}
