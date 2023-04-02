import 'package:flutter/material.dart';

class PageLoader extends StatefulWidget {
  const PageLoader({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static PageLoaderState of(BuildContext context) {
    return context.findAncestorStateOfType()!;
  }

  @override
  State<PageLoader> createState() => PageLoaderState();
}

class PageLoaderState extends State<PageLoader> {

  late final ValueNotifier<bool> _isLoadingN;

  @override
  void initState() {
    super.initState();
    _isLoadingN = ValueNotifier(false);
  }

  @override
  void dispose() {
    _isLoadingN.dispose();
    super.dispose();
  }

  void setLoading(bool loading) => _isLoadingN.value = loading;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          ValueListenableBuilder<bool>(
            valueListenable: _isLoadingN,
            builder: (_, isLoading, child) {
              return IgnorePointer(
                ignoring: !isLoading,
                child: AnimatedOpacity(
                  opacity: isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 100),
                  child: child!,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

