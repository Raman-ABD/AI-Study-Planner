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

@WebServlet("/TaskServlet")
public class TaskServlet extends HttpServlet {

    // ADD NEW TASK
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        String taskName = request.getParameter("taskName");
        int subjectId = Integer.parseInt(
                request.getParameter("subjectId"));

        String deadline = request.getParameter("deadline");
        String priority = request.getParameter("priority");

        String sql =
            "INSERT INTO tasks " +
            "(student_id, subject_id, task_name, deadline, priority) " +
            "VALUES (?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, taskName);
            ps.setString(4, deadline);
            ps.setString(5, priority);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("tasks.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println(
                "Error: " + e.getMessage()
            );
        }
    }


    // MARK TASK AS COMPLETED
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        int taskId = Integer.parseInt(
                request.getParameter("taskId"));

        String sql =
        		"UPDATE tasks SET status = 'Completed' " +
        				"WHERE task_id = ? AND student_id = ?";
        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setInt(1, taskId);
            ps.setInt(2, studentId);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("tasks.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println(
                "Error: " + e.getMessage()
            );
        }
    }
}