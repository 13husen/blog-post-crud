package com.maliksimple.kafka;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.maliksimple.jparepo.PostJpaRepository;
import com.maliksimple.model.elastic.BlogPost;
import com.maliksimple.elasticsearch.BlogPostRepository;
import com.maliksimple.model.jpa.BlogPostEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumerService {

    @Autowired
    private BlogPostRepository blogPostRepository;

    @Autowired
    private PostJpaRepository postJpaRepository;

    @KafkaListener(topics = "blog-posts", groupId = "blog-group")
    public void consume(String message) {
        System.out.println(">> Received JSON: " + message);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            BlogPost post = objectMapper.readValue(message, BlogPost.class);
            BlogPost savingData = blogPostRepository.save(post);
            // Simpan ke PostgreSQL
            BlogPostEntity entity = new BlogPostEntity();
            entity.setId(savingData.getId());
            entity.setTitle(post.getTitle());
            entity.setContent(post.getContent());
            postJpaRepository.save(entity);

            // Simpan ke Elasticsearch
            System.out.println(">> Saved to both Elasticsearch and PostgreSQL");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}