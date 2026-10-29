<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="com.studyplanner.DBConnection" %>
<%@ page import="com.studyplanner.AIRecommendation" %>

<%
    response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>AI Study Recommendations</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #1e3a8a;
            color: white;
            padding: 20px 40px;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .ai-box {
            background: white;
            padding: 25px;
            margin-bottom: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px #ddd;
        }

        .score {
            font-size: 28px;
            font-weight: bold;
            color: #1e3a8a;
        }

        .high {
            border-left: 6px solid #dc2626;
        }

        .medium {
            border-left: 6px solid #f59e0b;
        }

        .low {
            border-left: 6px solid #16a34a;
        }

        .study-time {
            background: #eef2ff;
            padding: 12px;
            border-radius: 8px;
            font-weight: bold;
            color: #1e3a8a;
        }

        .back {
            display: inline-block;
            margin-top: 10px;
            background: #1e3a8a;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 6px;
        }

    </style>

</head>

<body>


<div class="header">

    <h2>🤖 AI Study Recommendations</h2>

    <p>
        Personalized recommendations based on your study data
    </p>

</div>


<div class="container">


<%

    // Check login session

    HttpSession sessionObj = request.getSession(false);

    if (sessionObj == null ||
        sessionObj.getAttribute("studentId") == null) {

        response.sendRedirect("login.jsp");
        return;
    }


    // Get logged-in student ID

    int studentId =
        (Integer) sessionObj.getAttribute("studentId");


    boolean found = false;


    // Get subject, progress, pending tasks and deadline

    String sql =
        "SELECT s.subject_name, " +
        "p.progress_percent, " +

        "COUNT(t.task_id) AS pending_tasks, " +

        "MIN(t.deadline) AS nearest_deadline, " +

        "MAX(CASE " +
        "WHEN t.priority='High' THEN 3 " +
        "WHEN t.priority='Medium' THEN 2 " +
        "ELSE 1 END) AS priority_level " +

        "FROM subjects s " +

        "LEFT JOIN study_progress p " +
        "ON s.subject_id = p.subject_id " +
        "AND p.student_id = ? " +

        "LEFT JOIN tasks t " +
        "ON s.subject_id = t.subject_id " +
        "AND t.student_id = ? " +
        "AND t.status = 'Pending' " +

        "WHERE s.student_id = ? " +

        "GROUP BY s.subject_id, " +
        "s.subject_name, " +
        "p.progress_percent";


    try {

        Connection con =
            DBConnection.getConnection();


        PreparedStatement ps =
            con.prepareStatement(sql);


        ps.setInt(1, studentId);
        ps.setInt(2, studentId);
        ps.setInt(3, studentId);


        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            found = true;


            String subject =
                rs.getString("subject_name");


            int progress =
                rs.getInt("progress_percent");


            int pendingTasks =
                rs.getInt("pending_tasks");


            Date deadline =
                rs.getDate("nearest_deadline");


            // If there is no deadline,
            // assume 30 days remaining

            int daysLeft = 30;


            if (deadline != null) {

                daysLeft =
                    (int) ChronoUnit.DAYS.between(
                        LocalDate.now(),
                        deadline.toLocalDate()
                    );


                // If deadline has already passed,
                // keep daysLeft as 0

                if (daysLeft < 0)
                    daysLeft = 0;

            }


            // Convert priority level into text

            int priorityLevel =
                rs.getInt("priority_level");


            String priority = "Low";


            if (priorityLevel == 3)

                priority = "High";


            else if (priorityLevel == 2)

                priority = "Medium";


            // Calculate AI score

            int score =
                AIRecommendation.calculateScore(
                    progress,
                    pendingTasks,
                    daysLeft,
                    priority
                );


            // Generate recommendation

            String recommendation =
                AIRecommendation.getRecommendation(score);


            // Calculate study time

            int studyMinutes =
                AIRecommendation.getStudyMinutes(score);


            // Select CSS according to score

            String cssClass = "low";


            if (score >= 70)

                cssClass = "high";


            else if (score >= 50)

                cssClass = "medium";

%>


<div class="ai-box <%= cssClass %>">


    <h2>

        📚 <%= subject %>

    </h2>


    <p>

        <b>Progress:</b>

        <%= progress %>%

    </p>


    <p>

        <b>Pending Tasks:</b>

        <%= pendingTasks %>

    </p>


    <p>

        <b>Nearest Deadline:</b>

        <%= deadline == null
            ? "No pending deadline"
            : deadline %>

    </p>


    <p>

        <b>Priority:</b>

        <%= priority %>

    </p>


    <p class="score">

        AI Score: <%= score %>

    </p>


    <p>

        <b>🤖 AI Recommendation:</b>

        <%= recommendation %>

    </p>


    <div class="study-time">

        ⏱ Recommended Study Time:

        <%= studyMinutes %> minutes

    </div>


</div>


<%

        }


        // If no subjects/data found

        if (!found) {

%>


<div class="ai-box low">

    <h2>

        🎉 No Study Data Available

    </h2>

    <p>

        Add subjects, tasks and progress to generate
        AI-based study recommendations.

    </p>

</div>


<%

        }


        rs.close();
        ps.close();
        con.close();


    }

    catch (Exception e) {

        out.println(
            "<p>Error: " +
            e.getMessage() +
            "</p>"
        );

    }

%>


<a class="back" href="dashboard.jsp">

    ← Back to Dashboard

</a>


</div>

</body>

</html>