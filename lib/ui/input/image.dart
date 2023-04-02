import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myguide/core/services/storage_service.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/tappable.dart';
import 'package:myguide/ui/theme.dart';

class AppImageFormField extends FormField<String> {
  AppImageFormField({
    super.key,
    String? initialValue,
    ValueChanged<String?>? onChanged,
  }) : super(
          initialValue: initialValue,
          builder: (state) {
            return _AppImageField(
              data: state.value,
              onChanged: (data) async {
                state.didChange(data);
                onChanged?.call(data);
              },
            );
          },
        );
}

class _ImageFieldState extends Equatable {
  final bool isHovered;
  final double? uploadProgress;

  const _ImageFieldState({this.isHovered = false, this.uploadProgress});

  _ImageFieldState setHovered(bool hovered) {
    if (uploadProgress != null) return this;
    return _ImageFieldState(isHovered: hovered);
  }

  _ImageFieldState setUploading(double? progress) {
    return _ImageFieldState(uploadProgress: progress);
  }

  @override
  List<Object?> get props => [isHovered, uploadProgress];
}

class _AppImageField extends StatefulWidget {
  const _AppImageField({
    Key? key,
    this.data,
    this.onChanged,
  }) : super(key: key);

  final String? data;
  final ValueChanged<String?>? onChanged;

  @override
  State<_AppImageField> createState() => _AppImageFieldState();
}

class _AppImageFieldState extends State<_AppImageField> {
  late final ValueNotifier<_ImageFieldState> stateN;

  @override
  void initState() {
    super.initState();
    stateN = ValueNotifier(const _ImageFieldState());
  }

  @override
  void dispose() {
    stateN.dispose();
    super.dispose();
  }

  void onEnter(_) {
    stateN.value = stateN.value.setHovered(true);
  }

  void onExit(_) => stateN.value = stateN.value.setHovered(false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final child = LayoutBuilder(
      builder: (_, constraints) {
        return widget.data == null
            ? Center(
                child: FractionallySizedBox(
                  widthFactor: .5,
                  child: LayoutBuilder(builder: (_, constraints) {
                    return Icon(
                      Icons.image_search,
                      color: colorScheme.grey,
                      size: constraints.maxWidth,
                    );
                  }),
                ),
              )
            : Image.network(
                widget.data!,
                fit: BoxFit.scaleDown,
                width: double.infinity,
                height: double.infinity,
              );
      },
    );

    final deleteButton = widget.data == null
        ? const SizedBox()
        : SizedBox(
            height: 56,
            width: 56,
            child: Material(
              color: colorScheme.surface,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: widget.onChanged == null
                    ? null
                    : () => widget.onChanged!.call(null),
                child: Center(
                  child: Icon(Icons.delete, color: colorScheme.error),
                ),
              ),
            ),
          );

    return FractionallySizedBox(
      widthFactor: .3,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: colorScheme.surface,
          ),
          child: MouseRegion(
            onEnter: onEnter,
            onExit: onExit,
            child: Stack(
              children: [
                child,
                ValueListenableBuilder<_ImageFieldState>(
                  valueListenable: stateN,
                  builder: (_, state, child) {
                    if (state.uploadProgress != null) {
                      return AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: colorScheme.grey,
                          width: double.infinity,
                          height: double.infinity,
                          padding: AppInsets.s,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Text('Uploading...'),
                              Text('${(state.uploadProgress! * 100).toInt()}'),
                            ],
                          ),
                        ),
                      );
                    }
                    if (!state.isHovered) return const SizedBox();
                    return AnimatedOpacity(
                      opacity: state.isHovered ? 1 : 0,
                      duration: const Duration(milliseconds: 1000),
                      child: child!,
                    );
                  },
                  child: Container(
                    color: Colors.black54,
                    width: double.infinity,
                    height: double.infinity,
                    padding: AppInsets.s,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: deleteButton,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Tappable(
                                onTap: widget.onChanged == null
                                    ? null
                                    : () async {
                                  final file =
                                  await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (file == null) return;
                                  final newData =
                                  await file.readAsBytes();
                                  final url = await StorageService.shared
                                      .uploadImage(
                                    bytes: newData,
                                    directory: '/content/images',
                                    onProgress: (progress) {
                                      stateN.value = stateN.value
                                          .setUploading(progress);
                                    },
                                  );
                                  stateN.value =
                                      stateN.value.setUploading(null);
                                  widget.onChanged!(url);
                                },
                                child: const Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                  size: 56,
                                ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------------
///                             EXPLICIT FIELDS
/// ----------------------------------------------------------------------------
