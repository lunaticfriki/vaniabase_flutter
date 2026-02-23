import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/main_drawer.dart';
import '../../domain/entities/item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ItemsCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    final readService = sl<IItemsReadService>();
    readService.fetchLatestItems();
    readService.fetchCategories();
    readService.fetchAuthors();
    readService.fetchTopics();
    readService.fetchTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const MainDrawer(),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          if (state.status == ItemsStatus.initial ||
              state.status == ItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ItemsStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(context),
                const SizedBox(height: 32),

                // Stats Section
                _buildStatsSection(context, state),
                const SizedBox(height: 32),

                // Lists Section
                _buildListsSection(context, state),
                const SizedBox(height: 32),

                // Latest Items Section
                Text(
                  'RECENTLY ADDED',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLatestItemsGrid(context, state.latestItems),
                const SizedBox(height: 32), // Bottom padding
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to the Collection',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Overview of all registered resources',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, ItemsState state) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(
          context,
          'CATEGORIES',
          state.categories.length,
          theme.colorScheme.secondary,
        ),
        _buildStatCard(context, 'AUTHORS', state.authors.length, Colors.orange),
        _buildStatCard(
          context,
          'TOPICS',
          state.topics.length,
          Colors.purpleAccent,
        ),
        _buildStatCard(context, 'TAGS', state.tags.length, Colors.cyan),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white60,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListsSection(BuildContext context, ItemsState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildListRow(
          context,
          'Categories',
          state.categories.map((c) => c.name.value).toList(),
          theme.colorScheme.secondary,
        ),
        const SizedBox(height: 16),
        _buildListRow(
          context,
          'Topics',
          state.topics.map((t) => t.value).toList(),
          Colors.purpleAccent,
        ),
        const SizedBox(height: 16),
        _buildListRow(context, 'Tags', state.tags, Colors.cyan),
      ],
    );
  }

  Widget _buildListRow(
    BuildContext context,
    String title,
    List<String> items,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor, width: 4)),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: items.isEmpty
              ? const Text(
                  'No items found',
                  style: TextStyle(color: Colors.white30),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildLatestItemsGrid(BuildContext context, List<Item> items) {
    if (items.isEmpty) {
      return const Text(
        'No items found.',
        style: TextStyle(color: Colors.white30),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Decide cross axis count based on screen width
        int crossAxisCount = constraints.maxWidth > 800
            ? 5
            : constraints.maxWidth > 600
            ? 4
            : 2;

        return GridView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // Managed by SingleChildScrollView
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.46, // Adjusted to fit details without overflow
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemPreviewWidget(item: items[index]);
          },
        );
      },
    );
  }
}
