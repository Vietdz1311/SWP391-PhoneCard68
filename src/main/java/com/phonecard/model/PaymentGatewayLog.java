package com.phonecard.model;

import java.time.LocalDateTime;

public class PaymentGatewayLog {
    private long logId;
    private long transId;
    private String gatewayName;
    private String gatewayTransId;
    private String responseCode;
    private LocalDateTime createdAt;

    public PaymentGatewayLog() {}

    public long getLogId() { return logId; }
    public void setLogId(long logId) { this.logId = logId; }

    public long getTransId() { return transId; }
    public void setTransId(long transId) { this.transId = transId; }

    public String getGatewayName() { return gatewayName; }
    public void setGatewayName(String gatewayName) { this.gatewayName = gatewayName; }

    public String getGatewayTransId() { return gatewayTransId; }
    public void setGatewayTransId(String gatewayTransId) { this.gatewayTransId = gatewayTransId; }

    public String getResponseCode() { return responseCode; }
    public void setResponseCode(String responseCode) { this.responseCode = responseCode; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

