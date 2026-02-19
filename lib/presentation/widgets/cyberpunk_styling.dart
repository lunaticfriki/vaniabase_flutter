import 'package:flutter/material.dart';

class CyberpunkStyling {
  static const double _cutSize = 16.0;

  static ShapeBorder getCutEdgeBorder({
    Color? borderColor,
    double borderWidth = 1.0,
    bool rightBorderOnly = false,
  }) {
    return BeveledRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_cutSize),
        bottomRight: Radius.circular(_cutSize),
      ),
      side: (borderColor != null && !rightBorderOnly)
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
    );
  }

  static ShapeBorder get cutEdgeBorder => getCutEdgeBorder();

  static BorderRadius get imageClipRadius => const BorderRadius.only(
    topLeft: Radius.circular(_cutSize),
    bottomRight: Radius.circular(_cutSize),
  );

  static Decoration getVolumeDecoration(
    BuildContext context, {
    Color? bgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShapeDecoration(
      color: bgColor ?? Theme.of(context).cardColor,
      shape: getCutEdgeBorder(borderWidth: 1.5),
      shadows: [
        BoxShadow(
          color: colorScheme.tertiary,
          offset: const Offset(4, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
