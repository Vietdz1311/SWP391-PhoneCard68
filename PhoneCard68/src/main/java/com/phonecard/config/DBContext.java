package com.phonecard.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/phonecard_system";
    private static final String USER = "root";
    private static final String PASS = "123456";  

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        System.out.println("Testing...");
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("=== success ===");
        } else {
            System.out.println("=== faile ===");
        }
    }
}