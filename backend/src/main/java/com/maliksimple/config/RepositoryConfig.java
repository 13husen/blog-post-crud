package com.maliksimple.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@Configuration
@EnableJpaRepositories(basePackages = "com.maliksimple.jparepo")
@EnableElasticsearchRepositories(basePackages = "com.maliksimple.elasticsearch")
public class RepositoryConfig {
    // Any additional configuration for repositories
}