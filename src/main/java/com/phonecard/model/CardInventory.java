package com.phonecard.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CardInventory {
    private long cardId;
    private int productId;
    private String serialNumber;
    private String cardCode;
    private LocalDate expiryDate;
    private String status; 
    private LocalDateTime importedAt;
    
    private CardProduct cardProduct;
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

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
    
    public String getFormattedExpiryDate() {
        return expiryDate != null ? expiryDate.format(DATE_FORMATTER) : "";
    }
    
    public String getFormattedImportedAt() {
        return importedAt != null ? importedAt.format(DATE_FORMATTER) : "";
    }
    
    public boolean isExpired() {
        return expiryDate != null && expiryDate.isBefore(LocalDate.now());
    }

    public boolean getExpired() {
        return isExpired();
    }
}

