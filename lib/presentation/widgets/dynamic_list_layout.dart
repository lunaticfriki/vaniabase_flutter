import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';
import 'item_preview_widget.dart';
import 'cyberpunk_styling.dart';

class DynamicListLayout extends StatelessWidget {
  final String title;
  final List<String> availableOptions;
  final Map<String, int> optionCounts;
  final String? selectedOption;
  final ValueChanged<String?> onOptionSelected;
  final List<Item> filteredItems;

  const DynamicListLayout({
    super.key,
    required this.title,
    required this.availableOptions,
    required this.optionCounts,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.filteredItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFFF00FF),
              Color(0xFFFFFF00),
            ], // brand-magenta to brand-yellow
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white, // Color is masked by ShaderMask
              height: 1.1,
              letterSpacing: -2.0, // tracking-tighter
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Layout
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildTagsSidebar(context)),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: _buildItemsGrid(
                      context,
                      constraints.maxWidth * 0.75,
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTagsSidebar(context),
                const SizedBox(height: 32),
                _buildItemsGrid(context, constraints.maxWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTagsSidebar(BuildContext context) {
    final maxCount = optionCounts.values.isEmpty
        ? 1
        : optionCounts.values.reduce((a, b) => a > b ? a : b);
    final minCount = optionCounts.values.isEmpty
        ? 0
        : optionCounts.values.reduce((a, b) => a < b ? a : b);

    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      decoration: CyberpunkStyling.getVolumeDecoration(
        context,
        bgColor: const Color(0xFF18181B),
      ),
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: availableOptions.map((option) {
          final count = optionCounts[option] ?? 0;
          final fontSize = _getFontSize(count, minCount, maxCount);
          final isSelected = selectedOption == option;

          return InkWell(
            onTap: () {
              if (isSelected) {
                onOptionSelected(null);
              } else {
                onOptionSelected(option);
              }
            },
            child: isSelected
                ? ClipPath(
                    clipper: const CyberpunkPillClipper(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.5),
                      child: Text(
                        option.toUpperCase(),
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontSize > 24
                              ? FontWeight.w900
                              : FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      option.toUpperCase(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontSize > 24
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }

  double _getFontSize(int count, int minCount, int maxCount) {
    if (minCount == maxCount) return 18.0;

    final normalized = (count - minCount) / (maxCount - minCount);

    if (normalized < 0.1) return 14.0;
    if (normalized < 0.25) return 16.0;
    if (normalized < 0.4) return 18.0;
    if (normalized < 0.6) return 20.0;
    if (normalized < 0.8) return 24.0;
    return 30.0;
  }

  Widget _buildItemsGrid(BuildContext context, double availableWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                selectedOption != null
                    ? '#${selectedOption!.toUpperCase()}'
                    : 'ALL ITEMS',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFF00FF), Color(0xFFFFFF00)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Text(
                '[${filteredItems.length}]',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Grid
        if (filteredItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 64),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'No items found.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800
                  ? 4
                  : constraints.maxWidth > 600
                  ? 3
                  : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.46,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ItemPreviewWidget(item: filteredItems[index]);
                },
              );
            },
          ),
      ],
    );
  }
}
