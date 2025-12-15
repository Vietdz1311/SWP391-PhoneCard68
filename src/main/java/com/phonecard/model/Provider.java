package com.phonecard.model;

public class Provider {
    private int providerId;
    private String providerName;
    private String logoUrl;
    private boolean isActive;

    public Provider() {}

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getProviderName() { return providerName; }
    public void setProviderName(String providerName) { this.providerName = providerName; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }

    public boolean isActive() { return isActive; }
public void setIsActive(boolean isActive) { this.isActive = isActive; }
}