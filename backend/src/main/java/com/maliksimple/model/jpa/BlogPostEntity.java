package com.maliksimple.model.jpa;

import jakarta.persistence.*;

@Entity
@Table(name = "blog_posts")
public class BlogPostEntity {

    @Id
    @Column(name = "id")
    private String id;

    private String title;

    private String content;


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