package com.maliksimple.kafka;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.maliksimple.model.elastic.BlogPost;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class KafkaProducerService {

    private static final String TOPIC = "blog-posts";

    @Autowired
    private KafkaTemplate<String, BlogPost> kafkaTemplate;

    public void sendPost(BlogPost post) throws JsonProcessingException {
        kafkaTemplate.send("blog-posts", post);
        System.out.println("Sent post to Kafka: " + new ObjectMapper().writeValueAsString(post));
    }
}