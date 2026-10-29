package com.studyplanner;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // MySQL database ka URL
    private static final String URL =
            "jdbc:mysql://localhost:3306/studyplanner";

    // MySQL username
    private static final String USER = "root";

    // Apna MySQL password yahan likho
    private static final String PASSWORD =
            System.getenv("DB_PASSWORD");
    public static Connection getConnection() {

        Connection con = null;

        try {
            // MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database se connection
            con = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Database Connected Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}