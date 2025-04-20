import 'package:fe_simple/data/models/blog_post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_simple/domain/providers/blog_post_provider.dart';

class DetailPage extends StatefulWidget {
  final String postId;

  const DetailPage({super.key, required this.postId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogPostProvider>(
        context,
        listen: false,
      ).fetchPostDetail(widget.postId);
    });
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleEdit(BlogPost post, BlogPostProvider provider) async {
    if (isEditing) {
      final updatedPost = BlogPost(
        id: post.id,
        title: _titleController.text,
        content: _contentController.text,
      );

      try {
        await provider.updatePost(updatedPost);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Kembali ke HomePage dan trigger refresh
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update post.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlogPostProvider>(context);
    final post = provider.selectedPost;

    if (post != null && !isEditing) {
      _titleController.text = post.title;
      _contentController.text = post.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(post?.title ?? 'Loading...'),
        actions:
            post == null
                ? []
                : [
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    onPressed: () => _toggleEdit(post, provider),
                  ),
                ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : post == null
              ? const Center(child: Text('Post not found'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    isEditing
                        ? Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _contentController,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                labelText: 'Content',
                              ),
                            ),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(post.content),
                          ],
                        ),
              ),
    );
  }
}
