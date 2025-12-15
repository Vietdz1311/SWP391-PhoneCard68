package com.phonecard.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Promotion {
    private int promotionId;
    private String code;
    private String discountType; // 'PERCENTAGE' hoặc 'FIXED_AMOUNT'
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private int usageLimit;
    private int usagePerUser;
    private String status; // 'Active' hoặc 'Ended'

    // Constructor mặc định
    public Promotion() {
    }

    // Constructor đầy đủ
    public Promotion(int promotionId, String code, String discountType, BigDecimal discountValue, 
                     BigDecimal minOrderValue, LocalDateTime startDate, LocalDateTime endDate, 
                     int usageLimit, int usagePerUser, String status) {
        this.promotionId = promotionId;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderValue = minOrderValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.usagePerUser = usagePerUser;
        this.status = status;
    }

    // --- GETTERS AND SETTERS ---

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsagePerUser() {
        return usagePerUser;
    }

    public void setUsagePerUser(int usagePerUser) {
        this.usagePerUser = usagePerUser;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isActive() {
        return "Active".equals(this.status);
    }
}

