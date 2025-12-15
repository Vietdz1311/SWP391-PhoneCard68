package com.phonecard.model;

import com.phonecard.model.User;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {
    private long transId;
    private int userId;
    private Long orderId;
    private String type; // DEPOSIT, PAYMENT
    private BigDecimal amount;
    private String description;
    private String status; // Pending, Success, Failed
    private LocalDateTime createdAt;
    
    // For VNPay
    private String vnpTxnRef;
    
    // Related objects
    private User user;
    private Order order;

    public Transaction() {}

    public long getTransId() { return transId; }
    public void setTransId(long transId) { this.transId = transId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getVnpTxnRef() { return vnpTxnRef; }
    public void setVnpTxnRef(String vnpTxnRef) { this.vnpTxnRef = vnpTxnRef; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
}

