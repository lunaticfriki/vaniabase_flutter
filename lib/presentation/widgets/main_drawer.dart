import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../application/services/auth_cubit.dart';
import '../../application/services/auth_state.dart';
import 'cyberpunk_styling.dart';
import 'pixel_icons.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final tileColor = Theme.of(context).colorScheme.primary;
    const textColor = Colors.white;

    return Drawer(
      backgroundColor: const Color(0xFF18181B),
      shape: CyberpunkStyling.getCutEdgeBorder(rightBorderOnly: true),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final user = authState is Authenticated ? authState.user : null;

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'VANIABASE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        if (user != null) ...[
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(user.avatar),
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.none,
                                    ),
                                    color: Colors.white10,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'HELLO, ${user.name.toUpperCase()}!',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.home,
                    'Home',
                    '/',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.collection,
                    'All Items',
                    '/all-items',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.search,
                    'Search',
                    '/search',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.categories,
                    'Categories',
                    '/categories',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.authors,
                    'Authors',
                    '/authors',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.topics,
                    'Topics',
                    '/topics',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.tags,
                    'Tags',
                    '/tags',
                    tileColor,
                    textColor,
                  ),
                  _buildDrawerItem(
                    context,
                    PixelIcons.about,
                    'About',
                    '/about',
                    tileColor,
                    textColor,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      context.pop();
                      context.read<AuthCubit>().signOut();
                    },
                  ),
                ],
              ),
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
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    Widget icon,
    String title,
    String route,
    Color tileColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        decoration: CyberpunkStyling.getVolumeDecoration(
          context,
          bgColor: tileColor,
        ),
        child: ListTile(
          dense: true,
          shape: CyberpunkStyling.cutEdgeBorder,
          textColor: textColor,
          iconColor: textColor,
          leading: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ).createShader(bounds),

            child: IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: icon,
            ),
          ),
          title: Text(title),
          onTap: () {
            context.pop();
            context.go(route);
          },
        ),
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
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);
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
