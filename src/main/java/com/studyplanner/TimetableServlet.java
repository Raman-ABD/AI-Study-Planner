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

@WebServlet("/TimetableServlet")
public class TimetableServlet extends HttpServlet {

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

        String studyDate =
                request.getParameter("studyDate");

        String startTime =
                request.getParameter("startTime");

        String endTime =
                request.getParameter("endTime");

        String sql =
            "INSERT INTO timetable " +
            "(student_id, subject_id, study_date, start_time, end_time) " +
            "VALUES (?, ?, ?, ?, ?)";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, studyDate);
            ps.setString(4, startTime);
            ps.setString(5, endTime);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("timetable.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(
                "Error: " + e.getMessage()
            );
        }
    }
}