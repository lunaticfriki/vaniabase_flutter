import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../application/services/items_cubit.dart';
import '../../application/services/items_state.dart';
import '../../application/services/items_read_service.dart';
import '../../config/injection.dart';
import '../widgets/item_preview_widget.dart';
import '../widgets/cyberpunk_styling.dart';
import '../widgets/main_drawer.dart';
import '../widgets/cyberpunk_fab.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final readService = sl<IItemsReadService>();
    readService.fetchLatestItems();
    readService.fetchCategories();
    readService.fetchAuthors();
    readService.fetchTopics();
    readService.fetchTags();
    readService.fetchPublishers();
    readService.fetchStats();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const MainDrawer(),
      floatingActionButton: CyberpunkFab(scrollController: _scrollController),
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
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                const SizedBox(height: 32),

                _buildStatsSection(context, state),
                const SizedBox(height: 32),

                _buildListsSection(context, state),
                const SizedBox(height: 32),

                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFF00FF), Color(0xFFFFFF00)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'RECENTLY ADDED',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLatestItemsGrid(context, state.latestItems),
                const SizedBox(height: 32),
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
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF00FF), Color(0xFFFFFF00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            'Welcome to the Collection',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
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
        _buildStatCard(context, 'TOTAL', state.totalItems, Colors.white),
        _buildStatCard(
          context,
          'COMPLETED',
          state.completedItems,
          Colors.greenAccent,
        ),
        _buildStatCard(
          context,
          'CATEGORIES',
          state.categories.length,
          theme.colorScheme.secondary,
        ),
        _buildStatCard(context, 'AUTHORS', state.authors.length, Colors.orange),
        _buildStatCard(
          context,
          'EDITORS',
          state.publishers.length,
          Colors.pinkAccent,
        ),
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

    // Compute frequencies from state.items for all pills
    Map<String, int> catCounts = {};
    Map<String, int> topicCounts = {};
    Map<String, int> tagCounts = {};
    Map<String, int> pubCounts = {};

    for (var item in state.items) {
      // Categories
      final cat = item.category.name.value;
      if (cat.isNotEmpty && cat.toLowerCase() != 'unknown') {
        catCounts[cat] = (catCounts[cat] ?? 0) + 1;
      }

      // Topics
      final topic = item.topic.value;
      if (topic.isNotEmpty) {
        topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
      }

      // Tags
      for (var tag in item.tags) {
        if (tag.isNotEmpty) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }

      // Publishers (Editors)
      final pub = item.publisher.value;
      if (pub.isNotEmpty && pub.toLowerCase() != 'unknown') {
        pubCounts[pub] = (pubCounts[pub] ?? 0) + 1;
      }
    }

    // Convert frequency maps to formatted MapEntries "Name" -> "Name (Count)" and sort them
    final categoriesList =
        state.categories
            .map((c) => c.name.value)
            .where((name) => catCounts.containsKey(name))
            .map((name) => MapEntry(name, '$name (${catCounts[name]})'))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final topicsList =
        state.topics
            .map((t) => t.value)
            .where((val) => topicCounts.containsKey(val))
            .map((val) => MapEntry(val, '$val (${topicCounts[val]})'))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final tagsList =
        state.tags
            .where((tag) => tagCounts.containsKey(tag))
            .map((tag) => MapEntry(tag, '$tag (${tagCounts[tag]})'))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final publishersList =
        state.publishers
            .where((pub) => pubCounts.containsKey(pub))
            .map((pub) => MapEntry(pub, '$pub (${pubCounts[pub]})'))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    // Get the last 5 completed items
    final completedItems = state.items.where((i) => i.completed.value).toList();
    // Sort by timestamp (newest first)
    completedItems.sort(
      (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
    );
    final last5CompletedNames = completedItems
        .take(5)
        .map((i) => MapEntry(i.title.value, i.title.value))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildListRow(
          context,
          'Categories',
          categoriesList.isNotEmpty
              ? categoriesList
              : state.categories
                    .map((c) => MapEntry(c.name.value, c.name.value))
                    .toList(),
          theme.colorScheme.secondary,
          '/categories',
        ),
        const SizedBox(height: 16),
        _buildListRow(
          context,
          'Topics',
          topicsList.isNotEmpty
              ? topicsList
              : state.topics.map((t) => MapEntry(t.value, t.value)).toList(),
          Colors.purpleAccent,
          '/topics',
        ),
        const SizedBox(height: 16),
        _buildListRow(
          context,
          'Tags',
          tagsList.isNotEmpty
              ? tagsList
              : state.tags.map((t) => MapEntry(t, t)).toList(),
          Colors.cyan,
          '/tags',
        ),
        const SizedBox(height: 16),
        _buildListRow(
          context,
          'Editors',
          publishersList.isNotEmpty
              ? publishersList
              : state.publishers.map((p) => MapEntry(p, p)).toList(),
          Colors.pinkAccent,
          '/', // Placeholder: No '/editors' screen currently exists
        ),
        const SizedBox(height: 16),
        _buildListRow(
          context,
          'Completed (${state.completedItems})',
          last5CompletedNames.isNotEmpty
              ? last5CompletedNames
              : [const MapEntry('No items completed', 'No items completed')],
          Colors.greenAccent,
          '/', // Placeholder
        ),
      ],
    );
  }

  Widget _buildListRow(
    BuildContext context,
    String title,
    List<MapEntry<String, String>> items,
    Color accentColor,
    String routeName,
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
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context).push(routeName, extra: item.key);
                      },
                      child: ClipPath(
                        clipper: const CyberpunkPillClipper(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border(
                              left: BorderSide(color: accentColor, width: 2),
                            ),
                          ),
                          child: Text(
                            item.value,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
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
        int crossAxisCount = constraints.maxWidth > 800
            ? 5
            : constraints.maxWidth > 600
            ? 4
            : 2;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.46,
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
