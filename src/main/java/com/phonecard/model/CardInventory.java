package com.phonecard.model;

import com.phonecard.model.CardProduct;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class CardInventory {
    private long cardId;
    private int productId;
    private String serialNumber;
    private String cardCode;
    private LocalDate expiryDate;
    private String status; // Available, Sold, Error
    private LocalDateTime importedAt;
    
    // Related objects
    private CardProduct cardProduct;

    public CardInventory() {}

    public long getCardId() { return cardId; }
    public void setCardId(long cardId) { this.cardId = cardId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getCardCode() { return cardCode; }
    public void setCardCode(String cardCode) { this.cardCode = cardCode; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getImportedAt() { return importedAt; }
    public void setImportedAt(LocalDateTime importedAt) { this.importedAt = importedAt; }

    public CardProduct getCardProduct() { return cardProduct; }
    public void setCardProduct(CardProduct cardProduct) { this.cardProduct = cardProduct; }
}

