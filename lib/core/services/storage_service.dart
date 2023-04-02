import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static StorageService? _storageService;

  static StorageService get shared => _storageService ??= StorageService();

  StorageService() : _storage = FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadImage({
    required Uint8List bytes,
    required String directory,
    required Function(double) onProgress,
  }) async {
    final uuid = const Uuid().v4();
    final path = '$directory/$uuid';
    final task = _storage.ref(path).putData(
          bytes,
          SettableMetadata(contentType: 'image/png'),
        );
    final completer = Completer<String>();
    task.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.paused:
        case TaskState.canceled:
          break;
        case TaskState.running:
          onProgress(event.bytesTransferred / event.totalBytes);
          break;
        case TaskState.success:
          final url = await event.ref.getDownloadURL();
          completer.complete(url);
          break;
        case TaskState.error:
          completer.completeError(Error());
          break;
      }
    });
    return await completer.future;
  }
}
