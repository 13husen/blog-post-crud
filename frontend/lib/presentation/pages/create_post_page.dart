import 'package:fe_simple/data/models/blog_post_model.dart';
import 'package:fe_simple/domain/providers/blog_post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlogPostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator:
                    (value) => value!.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await provider.createPost(
                      BlogPost(
                        title: _titleController.text,
                        content: _contentController.text,
                      ),
                    );
                    if (context.mounted) {
                      Navigator.pop(
                        context,
                        true,
                      ); // return true sebagai sinyal berhasil
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
