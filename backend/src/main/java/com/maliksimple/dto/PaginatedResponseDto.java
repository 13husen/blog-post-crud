package com.maliksimple.dto;


import java.util.List;

public class PaginatedResponseDto<T> {
    private long total;
    private int page;
    private int size;
    private List<T> results;

    public PaginatedResponseDto(long total, int page, int size, List<T> results) {
        this.total = total;
        this.page = page;
        this.size = size;
        this.results = results;
    }

    // Getters and setters
    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public List<T> getResults() {
        return results;
    }

    public void setResults(List<T> results) {
        this.results = results;
    }
}