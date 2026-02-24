import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cyberpunk_styling.dart';

class CyberpunkFab extends StatefulWidget {
  final ScrollController scrollController;

  const CyberpunkFab({super.key, required this.scrollController});

  @override
  State<CyberpunkFab> createState() => _CyberpunkFabState();
}

class _CyberpunkFabState extends State<CyberpunkFab> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CyberpunkFab oldWidget) {
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final isTop = widget.scrollController.offset <= 10;
    if (isTop != _isVisible) {
      setState(() {
        _isVisible = isTop;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      offset: _isVisible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isVisible ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !_isVisible,
          child: Container(
            decoration: CyberpunkStyling.getVolumeDecoration(
              context,
              bgColor: Theme.of(context).colorScheme.secondary,
            ),
            child: FloatingActionButton.extended(
              onPressed: () => GoRouter.of(context).push('/item/new'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              shape: CyberpunkStyling.cutEdgeBorder,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'ADD NEW ITEM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
