import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PixelIcon extends StatelessWidget {
  final String svgData;
  final double size;
  final Color? color;

  const PixelIcon({
    super.key,
    required this.svgData,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? Colors.white;

    final fullSvg =
        '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="$size" height="$size" shape-rendering="crispEdges">
      <g fill="currentColor">
        $svgData
      </g>
    </svg>
    ''';

    return SvgPicture.string(
      fullSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}

class PixelIcons {
  static const String _homePath = '''
    <path d="M10 2h4v2h-4V2zM6 6h4V4H6v2zm8 0h4v2h-4V6zM4 10h2V6H4v4zm14 0h2V6h-2v4zM2 14h2v-4H2v4zm18 0h2v-4h-2v4zM2 22h8v-8H6v4H4v4zm12 0h8v-8h-2v4h-2v4h-4z" />
    <path d="M10 22h4v-6h-4v6z" />
  ''';

  static const String _collectionPath = '''
    <path d="M4 4h4v2H4V4zm6 0h10v2H10V4zM4 8h4v2H4V8zm6 0h10v2H10V8zM4 12h4v2H4v-2zm6 0h10v2H10v-2zM4 16h4v2H4v-2zm6 0h10v2H10v-2zM4 20h4v2H4v-2zm6 0h10v2H10v-2z" />
  ''';

  static const String _categoriesPath = '''
    <path d="M2 4h8v2H2V4zm0 6h2V8H2v2zm4 0h16V8H6v2zM2 14h2v-2H2v2zm4 0h16v-2H6v2zM2 18h2v-2H2v2zm4 0h16v-2H6v2zM2 22h20v-2H2v2z" />
  ''';

  static const String _tagsPath = '''
    <path d="M12 2h8v8h-2v2h-2v2h-2v2h-2v2h-2v-2H8v-2H6v-2H4V8H2V2h10zm2 6h2V4h-2v4z" />
  ''';

  static const String _topicsPath = '''
    <path d="M8 2h2v4h4V2h2v4h4v2h-4v4h4v2h-4v4h-2v-4h-4v4H8v-4H4v-2h4V8H4V6h4V2zm2 6v4h4V8h-4z" />
  ''';

  static const String _formatsPath = '''
    <path d="M4 2h10v2h2v2h2v2h2v14H4V2zm2 2v16h12V8h-2V6h-2V4H6z" />
  ''';

  static const String _searchPath = '''
    <path d="M10 4h4v2h-4V4zM6 8h2V6H6v2zm10 0h2V6h-2v2zm-2 2h-4v2h4v-2zm-6 0h2V8H8v2zm8 0h2V8h-2v2zm-2 4h-4v-2h4v2zm2 0h-2v-2h2v2zM6 14h2v-2H6v2zm10 0h2v-2h-2v2zm2 4v-2h-2v2h-2v2h2v2h2v-2h2v-2h-4z" />
    <path d="M8 12h2v2H8v-2z" />
  ''';

  static const String _createPath = '''
    <path d="M22 4h-2v4h-4v2h4v4h2v-4h4V8h-4V4zM2 20h14v2H2v-2zm0-4h10v2H2v-2zm0-4h12v2H2v-2zm0-4h8v2H2V8zm0-4h6v2H2V4z" />
  ''';

  static const String _aboutPath = '''
    <path d="M10 2h4v4h-4V2zm0 6h4v12h-4v-2h-2v-2h2V8zm-2 14h8v-2H8v2z" />
  ''';

  static const String _completedPath = '''
    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
  ''';

  static const String _logoutPath = '''
    <path d="M4 4h2v16H4V4zm4 0h8v2H8V4zm8 0h2v4h-2V4zm-2 6h4v2h-4v-2zm-2 8h-2v-2h2v2zm2 0h4v-2h-4v2zm4-4h2v4h-2v-4zm-4-4h2v2h-2v-2zm-2 0h-2v2h2V10z" />
    <path d="M12 14h2v2h-2v-2z" />
  ''';

  static const String _authorsPath = '''
    <path d="M6 2h4v4H6V2zm0 6h4v12H6v-2H4v-2h2V8zm-2 14h8v-2H4v2zM14 6h4v4h-4V6zm0 6h4v8h-4v-8zm2-10h-2v2h2V2z" />
  ''';

  static const String _publishersPath = '''
    <path d="M4 4h16v16H4V4zm2 2v12h12V6H6zm2 2h8v2H8V8zm0 4h8v2H8v-2z" />
  ''';

  static Widget get home => const PixelIcon(svgData: _homePath);
  static Widget get collection => const PixelIcon(svgData: _collectionPath);
  static Widget get categories => const PixelIcon(svgData: _categoriesPath);
  static Widget get tags => const PixelIcon(svgData: _tagsPath);
  static Widget get topics => const PixelIcon(svgData: _topicsPath);
  static Widget get formats => const PixelIcon(svgData: _formatsPath);
  static Widget get search => const PixelIcon(svgData: _searchPath);
  static Widget get create => const PixelIcon(svgData: _createPath);
  static Widget get about => const PixelIcon(svgData: _aboutPath);
  static Widget get completed => const PixelIcon(svgData: _completedPath);
  static Widget get logout => const PixelIcon(svgData: _logoutPath);
  static Widget get authors => const PixelIcon(svgData: _authorsPath);
  static Widget get publishers => const PixelIcon(svgData: _publishersPath);
}
