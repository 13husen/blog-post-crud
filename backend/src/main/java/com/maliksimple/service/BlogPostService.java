package com.maliksimple.service;

import com.maliksimple.dto.PaginatedResponseDto;
import com.maliksimple.elasticsearch.BlogPostRepository;
import com.maliksimple.jparepo.PostJpaRepository;
import com.maliksimple.model.elastic.BlogPost;
import com.maliksimple.model.jpa.BlogPostEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;
import co.elastic.clients.elasticsearch._types.query_dsl.MultiMatchQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BlogPostService {

    @Autowired
    private ElasticsearchOperations elasticsearchOperations;

    @Autowired
    private BlogPostRepository blogPostRepository;

    @Autowired
    private PostJpaRepository postJpaRepository;

    public PaginatedResponseDto<BlogPost> search(String query, int page, int size) {
        MultiMatchQuery multiMatchQuery = MultiMatchQuery.of(mmq -> mmq
                .query(query)
                .fields("title", "content"));

        Query searchQuery = Query.of(q -> q.multiMatch(multiMatchQuery));

        NativeQuery nativeQuery = NativeQuery.builder()
                .withQuery(searchQuery)
                .withPageable(PageRequest.of(page, size))
                .build();

        SearchHits<BlogPost> hits = elasticsearchOperations.search(nativeQuery, BlogPost.class);

        List<BlogPost> results = elasticsearchOperations.search(nativeQuery, BlogPost.class)
                .getSearchHits()
                .stream()
                .map(SearchHit::getContent)
                .collect(Collectors.toList());

        return new PaginatedResponseDto<>(
                hits.getTotalHits(),
                page,
                size,
                results
        );
    }

    public PaginatedResponseDto<BlogPost> getAllPosts(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<BlogPost> blogPage = blogPostRepository.findAll(pageable);

        return new PaginatedResponseDto<>(
                blogPage.getTotalElements(),
                blogPage.getNumber(),
                blogPage.getSize(),
                blogPage.getContent()
        );
    }

    public BlogPostEntity getPostById(String id) {
        Optional<BlogPostEntity> post = postJpaRepository.findById(id);
        return post.orElseGet(BlogPostEntity::new);
    }

    public void deletePostById(String id) {
        postJpaRepository.deleteById(id);
        blogPostRepository.deleteById(id);
    }

    public BlogPostEntity updatePostById(String id, BlogPostEntity updatedPost){
        Optional<BlogPostEntity> existingPostOpt = postJpaRepository.findById(id);
        if (existingPostOpt.isEmpty()) {
            return null; // If not found, return 404
        }
        // 2. Update the database entity with the new values
        BlogPostEntity existingPost = existingPostOpt.get();
        existingPost.setTitle(updatedPost.getTitle());
        existingPost.setContent(updatedPost.getContent());

        BlogPostEntity entiPost = postJpaRepository.save(existingPost);

        BlogPost elasticPost = new BlogPost();
        elasticPost.setId(id);
        elasticPost.setTitle(updatedPost.getTitle());
        elasticPost.setContent(updatedPost.getContent());

        // Save the updated document to Elasticsearch
        blogPostRepository.save(elasticPost);
        return entiPost;
    }

    public Map<String, Long> getPostStats() {
        long totalPosts = postJpaRepository.count();
        long totalWords = postJpaRepository.findAll().stream()
                .mapToLong(p -> p.getContent().split("\\s+").length)
                .sum();

        return Map.of(
                "totalPosts", totalPosts,
                "totalWords", totalWords
        );
    }
}