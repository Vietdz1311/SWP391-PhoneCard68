package com.phonecard.model;

import java.math.BigDecimal;

public class CardProduct {
    private int productId;
    private int providerId;
    private String productName;
    private BigDecimal faceValue;    
    private BigDecimal sellingPrice; 
    private String description;
    
    private Provider provider; 
    
    private int availableCount; 

    public CardProduct() {}

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getFaceValue() { return faceValue; }
    public void setFaceValue(BigDecimal faceValue) { this.faceValue = faceValue; }

    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal sellingPrice) { this.sellingPrice = sellingPrice; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Provider getProvider() { return provider; }
    public void setProvider(Provider provider) { this.provider = provider; }

    public int getAvailableCount() { return availableCount; }
    public void setAvailableCount(int availableCount) { this.availableCount = availableCount; }
}