import 'package:flutter/cupertino.dart';

typedef SeparatorBuilder = Widget Function();

extension Separated on List<Widget> {
  List<Widget> separated({
    required SeparatorBuilder separatorBuilder,
  }) {
    return List.generate(
      length * 2 - 1,
      (index) {
        if (index.isOdd) return separatorBuilder();
        return elementAt(index ~/ 2);
      },
    );
  }
}

class SeparatedColumn extends Column {
  SeparatedColumn({
    super.key,
    required SeparatorBuilder separatorBuilder,
    required List<Widget> children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
          children: children.separated(separatorBuilder: separatorBuilder),
        );
}

class SeparatedRow extends Row {
  SeparatedRow({
    super.key,
    required SeparatorBuilder separatorBuilder,
    required List<Widget> children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(
          children: children.separated(separatorBuilder: separatorBuilder),
        );
}
