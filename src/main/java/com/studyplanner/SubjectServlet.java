package com.studyplanner;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SubjectServlet")
public class SubjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Login student ki session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Student ID session se
        int studentId = (Integer) session.getAttribute("studentId");

        // Form se subject name
        String subjectName = request.getParameter("subjectName");

        String sql =
            "INSERT INTO subjects (student_id, subject_name) VALUES (?, ?)";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setString(2, subjectName);

            ps.executeUpdate();

            ps.close();
            con.close();

            // Wapas subjects page
            response.sendRedirect("subjects.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}