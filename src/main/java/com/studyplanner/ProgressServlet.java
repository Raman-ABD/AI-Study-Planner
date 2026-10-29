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

@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        int studentId =
                (Integer) session.getAttribute("studentId");

        int subjectId =
                Integer.parseInt(request.getParameter("subjectId"));

        int progress =
                Integer.parseInt(request.getParameter("progress"));
        
        String sql =
            "INSERT INTO study_progress " +
            "(student_id, subject_id, progress_percent) " +
            "VALUES (?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "progress_percent = ?";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setInt(3, progress);
            ps.setInt(4, progress);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("progress.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(
                "Error: " + e.getMessage()
            );
        }
    }
}