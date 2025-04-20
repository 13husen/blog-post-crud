import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_simple/domain/providers/blog_post_provider.dart';
import 'package:fe_simple/presentation/widgets/post_card.dart';
import 'package:fe_simple/presentation/widgets/stats_card.dart';
import 'create_post_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BlogPostProvider>(context, listen: false);
      await provider.fetchPosts();
      await provider.fetchStats();
    });
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<BlogPostProvider>(
        context,
        listen: false,
      ).fetchPosts(loadMore: true);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      final provider = Provider.of<BlogPostProvider>(context, listen: false);
      if (query.isEmpty) {
        provider.fetchPosts();
      } else {
        provider.searchPosts(query);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlogPostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Blog Posts')),
      body: Column(
        children: [
          if (provider.stats != null)
            StatsCard(
              totalPosts: provider.stats!['totalPosts'],
              totalWords: provider.stats!['totalWords'],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _searchController.clear();
                await provider.fetchPosts();
                await provider.fetchStats();
              },
              child:
                  _isRefreshing || provider.isLoading || provider.posts.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            provider.posts.length + (provider.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < provider.posts.length) {
                            final post = provider.posts[index];
                            return BlogPostCard(
                              post: post,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(postId: post.id),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );

          if (result == true && context.mounted) {
            setState(() {
              _isRefreshing = true;
            });

            await Future.delayed(const Duration(seconds: 1));
            final provider = Provider.of<BlogPostProvider>(
              context,
              listen: false,
            );
            await provider.fetchPosts();
            await provider.fetchStats();

            if (mounted) {
              setState(() {
                _isRefreshing = false;
              });
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
