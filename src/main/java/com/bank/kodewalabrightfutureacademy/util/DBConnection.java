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

        if (host == null || user == null) {
            // Clever Cloud Fallback
            host = "bouarzznou7l6ulpkalj-mysql.services.clever-cloud.com";
            port = "3306";
            dbName = "bouarzznou7l6ulpkalj";
            user = "u2h10knkzlkopvmn";
            password = "DeYz19tQkZvzRHdqthO9";
        }

        String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found!", e);
        }
    }
}
