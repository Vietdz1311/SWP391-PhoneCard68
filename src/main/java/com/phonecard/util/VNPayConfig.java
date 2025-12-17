package com.phonecard.util;

public class VNPayConfig {
    public static final String VNP_TMN_CODE = "ZMMPO81J";
    public static final String VNP_HASH_SECRET = "4IQMHZIVX77MH1TMCW3W57B3MVQV7DMW";
    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_API_URL = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_CURRENCY_CODE = "VND";
    public static final String VNP_LOCALE = "vn";
    public static final String VNP_ORDER_TYPE = "other";
    
    public static String getReturnUrl(String contextPath, String baseUrl) {
        return baseUrl + contextPath + "/vnpay-return";
    }
    
    public static String getIpnUrl(String contextPath, String baseUrl) {
        return baseUrl + contextPath + "/vnpay-ipn";
    }
}

