import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cyberpunk_styling.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final tileColor = Theme.of(context).colorScheme.primary;
    const textColor = Colors.white;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: CyberpunkStyling.getCutEdgeBorder(rightBorderOnly: true),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Container(
                  decoration: CyberpunkStyling.getVolumeDecoration(
                    context,
                    bgColor: tileColor,
                  ),
                  child: ListTile(
                    shape: CyberpunkStyling.cutEdgeBorder,
                    textColor: textColor,
                    iconColor: textColor,
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      context.pop(); // Close the drawer
                      context.go('/');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Container(
                  decoration: CyberpunkStyling.getVolumeDecoration(
                    context,
                    bgColor: tileColor,
                  ),
                  child: ListTile(
                    shape: CyberpunkStyling.cutEdgeBorder,
                    textColor: textColor,
                    iconColor: textColor,
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      context.pop(); // Close the drawer
                      context.go('/about');
                    },
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
          // Custom drawn right edge border to complement the cut bevel shape.
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _RightBevelBorderPainter(
                  color: Theme.of(context).colorScheme.secondary,
                  cutSize: 16.0,
                  strokeWidth: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RightBevelBorderPainter extends CustomPainter {
  final Color color;
  final double cutSize;
  final double strokeWidth;

  _RightBevelBorderPainter({
    required this.color,
    required this.cutSize,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    // Start drawing from top right corner inwards
    path.moveTo(size.width, 0);
    // Line down to where the cut starts
    path.lineTo(size.width, size.height - cutSize);
    // Diagonal slope line towards bottom edge
    path.lineTo(size.width - cutSize, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RightBevelBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.cutSize != cutSize ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
