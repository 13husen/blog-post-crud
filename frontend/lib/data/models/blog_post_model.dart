class BlogPost {
  final String id;
  final String title;
  final String content;

  BlogPost({
    this.id = "",
    required this.title,
    required this.content,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] ?? '',
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}