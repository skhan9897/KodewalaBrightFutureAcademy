package com.bank.kodewalabrightfutureacademy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        String host = System.getenv("MYSQL_HOST");
        String port = System.getenv("MYSQL_PORT");
        String dbName = System.getenv("MYSQL_DATABASE");
        String user = System.getenv("MYSQL_USER");
        String password = System.getenv("MYSQL_PASSWORD");

        if (host == null || host.isEmpty()) {
            System.out.println("[DBConnection] Render environment variables not found. Using local fallback credentials.");
            host = "bouarzznou7l6ulpkalj-mysql.services.clever-cloud.com";
            port = "3306";
            dbName = "bouarzznou7l6ulpkalj";
            user = "u2h10knkzlkopvmn";
            password = "DeYz19tQkZvzRHdqthO9";
        } else {
            System.out.println("[DBConnection] Render environment variables found. Connecting with Render credentials.");
        }

        String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        System.out.println("[DBConnection] Attempting to connect to: " + host);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("[DBConnection] Database connection successful.");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] FATAL: MySQL JDBC Driver not found.");
            throw new SQLException("MySQL JDBC Driver not found.", e);
        } catch (SQLException e) {
            System.err.println("[DBConnection] FATAL: Database connection failed. Check credentials, firewall, and network settings.");
            throw e;
        }
    }
}