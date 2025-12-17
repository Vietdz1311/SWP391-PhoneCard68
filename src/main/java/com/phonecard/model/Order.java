package com.phonecard.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {
    private long orderId;
    private int userId;
    private Integer promotionId;
    private long cardId;
    private BigDecimal price;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private String status;
    private LocalDateTime orderDate;
    
    private User user;
    private CardInventory cardInventory;
    private CardProduct cardProduct;

    public Order() {
        this.discountAmount = BigDecimal.ZERO;
    }

    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getPromotionId() { return promotionId; }
    public void setPromotionId(Integer promotionId) { this.promotionId = promotionId; }

    public long getCardId() { return cardId; }
    public void setCardId(long cardId) { this.cardId = cardId; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public BigDecimal getFinalAmount() { return finalAmount; }
    public void setFinalAmount(BigDecimal finalAmount) { this.finalAmount = finalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public CardInventory getCardInventory() { return cardInventory; }
    public void setCardInventory(CardInventory cardInventory) { this.cardInventory = cardInventory; }

    public CardProduct getCardProduct() { return cardProduct; }
    public void setCardProduct(CardProduct cardProduct) { this.cardProduct = cardProduct; }
}

