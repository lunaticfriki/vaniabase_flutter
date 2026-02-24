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
          color: colorScheme.secondary.withValues(alpha: 0.5),
          offset: const Offset(4, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }
}

class CyberpunkPillClipper extends CustomClipper<Path> {
  const CyberpunkPillClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    const cut = 8.0;

    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
