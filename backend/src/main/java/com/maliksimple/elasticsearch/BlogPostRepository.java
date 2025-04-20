package com.maliksimple.elasticsearch;

import com.maliksimple.model.elastic.BlogPost;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository()
public interface BlogPostRepository extends ElasticsearchRepository<BlogPost, String> {

}