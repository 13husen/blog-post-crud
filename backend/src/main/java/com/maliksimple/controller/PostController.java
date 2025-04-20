package com.maliksimple.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.maliksimple.dto.PaginatedResponseDto;
import com.maliksimple.elasticsearch.BlogPostRepository;
import com.maliksimple.kafka.KafkaProducerService;
import com.maliksimple.model.elastic.BlogPost;
import com.maliksimple.model.jpa.BlogPostEntity;
import com.maliksimple.service.BlogPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/posts")
@CrossOrigin // supaya bisa diakses dari frontend Flutter
public class PostController {

    @Autowired
    private KafkaProducerService producerService;

    @Autowired
    private BlogPostRepository blogPostRepository;

    @Autowired
    private BlogPostService searchService;

    @PostMapping
    public String createPost(@RequestBody BlogPost post) throws JsonProcessingException {
        producerService.sendPost(post);
        return "Post sent to Kafka!";
    }

    @GetMapping
    public ResponseEntity<PaginatedResponseDto<BlogPost>> getAllPosts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {

        PaginatedResponseDto<BlogPost> response = searchService.getAllPosts(page,size);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/search")
    public PaginatedResponseDto<BlogPost> searchPosts(
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        return searchService.search(query, page, size);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPostById(@PathVariable String id) {
        return ResponseEntity.ok(searchService.getPostById(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(@PathVariable String id) {
        try {
            searchService.deletePostById(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete post: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePost(@PathVariable String id, @RequestBody BlogPostEntity updatedPost) {
        return ResponseEntity.ok(searchService.updatePostById(id, updatedPost));
    }

    @GetMapping("/stats")
    public ResponseEntity<?> getStats() {
        return ResponseEntity.ok(searchService.getPostStats());
    }

}