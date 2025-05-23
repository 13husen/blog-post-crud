package com.maliksimple.model.elastic;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@Document(indexName = "blog-posts")
public class BlogPost {
    @Id
    private String id;

    private String title;
    private String content;

    public BlogPost() {
    }

    public BlogPost(String id, String title, String content) {
        this.id = id;
        this.title = title;
        this.content = content;
    }

    // Getters & Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
