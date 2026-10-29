package com.studyplanner;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Current session ko get karo
        HttpSession session = request.getSession(false);

        // Agar session exist karta hai to logout karo
        if (session != null) {
            session.invalidate();
        }

        // Logout ke baad login page par bhejo
        response.sendRedirect("login.jsp");
    }
}