package com.maliksimple.jparepo;

import com.maliksimple.model.elastic.BlogPost;
import com.maliksimple.model.jpa.BlogPostEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("postJpaRepository")
public interface PostJpaRepository extends JpaRepository<BlogPostEntity, String> {
}