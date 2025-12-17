package com.phonecard.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class BlogPost {
    private int postId;
    private int userId;
    private String title;
    private String slug;
    private String content;
    private String thumbnailUrl;
    private boolean isActive;
    private LocalDateTime publishedAt;
    private User author; 
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public BlogPost() {}

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public LocalDateTime getPublishedAt() { return publishedAt; }
    public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }
    public User getAuthor() { return author; }
    public void setAuthor(User author) { this.author = author; }
    
    public String getFormattedDate() {
        return publishedAt != null ? publishedAt.format(DATE_FORMATTER) : "";
    }
    
    public String getFormattedDateTime() {
        return publishedAt != null ? publishedAt.format(DATETIME_FORMATTER) : "";
    }
}