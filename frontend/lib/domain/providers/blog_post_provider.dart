import 'dart:convert';
import 'package:fe_simple/core/constants/constants.dart';
import 'package:fe_simple/data/models/blog_post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogPostProvider with ChangeNotifier {
  List<BlogPost> _posts = [];
  BlogPost? _selectedPost;
  bool _isLoading = false;

  List<BlogPost> get posts => _posts;
  BlogPost? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  bool _isFetchingMore = false;

  Map<String, dynamic>? _stats;
  Map<String, dynamic>? get stats => _stats;

  Future<void> fetchPosts({bool loadMore = false}) async {
    if (_isFetchingMore || (!loadMore && _isLoading)) return;

    if (loadMore && !_hasMore) return;

    if (!loadMore) {
      _posts = [];
      _currentPage = 0;
      _hasMore = true;
      _isLoading = true;
    } else {
      _isFetchingMore = true;
    }

    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          '${Constants.baseUrl}/posts?page=$_currentPage&size=$_pageSize',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> results = decoded['results'];

        final fetched = results.map((e) => BlogPost.fromJson(e)).toList();

        if (fetched.length < _pageSize) _hasMore = false;

        _posts.addAll(fetched);
        _currentPage++;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e, stacktrace) {
      debugPrint('Error fetching posts: $e');
      debugPrintStack(stackTrace: stacktrace);
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchPostDetail(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/posts/$id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _selectedPost = BlogPost.fromJson(data);
      } else {
        _selectedPost = null;
      }
    } catch (e) {
      _selectedPost = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createPost(BlogPost post) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchPosts(); // refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      //
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> searchPosts(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/posts/search?query=$keyword'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> results = decoded['results'];
        _posts = results.map((e) => BlogPost.fromJson(e)).toList();
      } else {
        throw Exception('Failed to search posts');
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/posts/$id'),
      );

      if (response.statusCode == 200) {
        _posts.removeWhere((post) => post.id == id);
      }
    } catch (e) {
      debugPrint('Delete error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePost(BlogPost post) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/posts/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      );

      if (response.statusCode == 200) {
        _selectedPost = BlogPost.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed to update post: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchStats() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/posts/stats'),
    );
    if (response.statusCode == 200) {
      _stats = json.decode(response.body);
      notifyListeners();
    }
  }
}
