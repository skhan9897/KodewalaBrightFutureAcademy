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
            com.bank.kodewalabrightfutureacademy.util.DBConnection.getConnection().close();
            
            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
            System.out.println("Database connection successful. DAOs created and set in context.");
        } catch (Exception e) {
            System.err.println("FATAL: Database connection failed on startup. Application will not start.");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize database connection.", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application context is being destroyed.");
    }
}