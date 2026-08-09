package com.bank.kodewalabrightfutureacademy.listener;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.dao.UserDAO;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application context is being initialized.");
        try {
            // Test the database connection on startup
            java.sql.Connection conn = com.bank.kodewalabrightfutureacademy.util.DBConnection.getConnection();
            if (conn != null) {
                conn.close();
                System.out.println("Database connection successful. DAOs created and set in context.");
            }
            
            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
        } catch (Exception e) {
            System.err.println("WARNING: Database connection failed on startup. DAOs might not work.");
            e.printStackTrace();
            // Don't throw RuntimeException, let the app start so we can see other pages
            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application context is being destroyed.");
    }
}