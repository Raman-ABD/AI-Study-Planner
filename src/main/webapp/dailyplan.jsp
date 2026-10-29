<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.util.*" %>
<%@ page import="com.studyplanner.DBConnection" %>
<%@ page import="com.studyplanner.AIRecommendation" %>

<%
response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>AI Daily Study Plan</title>

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

        .plan {
            background: white;
            padding: 22px;
            margin-bottom: 18px;
            border-radius: 12px;
            box-shadow: 0 3px 10px #ddd;
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

        .time {
            font-size: 20px;
            font-weight: bold;
            color: #1e3a8a;
        }

        .score {
            font-size: 18px;
            font-weight: bold;
        }

        .back {
            display: inline-block;
            margin-top: 10px;
            margin-right: 8px;
            background: #1e3a8a;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 6px;
        }

        .back:hover {
            background: #172554;
        }

    </style>

</head>

<body>


<div class="header">

    <h2>🤖 AI Daily Study Plan</h2>

    <p>
        Personalized study schedule generated from your study data
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


// Store all subject plans

List<Map<String, Object>> plans =
    new ArrayList<>();


// SQL query

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

        // Subject name

        String subject =
            rs.getString("subject_name");


        // Progress

        int progress =
            rs.getInt("progress_percent");


        // Pending tasks

        int pendingTasks =
            rs.getInt("pending_tasks");


        // Deadline

        java.sql.Date deadline =
            rs.getDate("nearest_deadline");


        // Default days left

        int daysLeft = 30;


        // Calculate days left

        if (deadline != null) {

            daysLeft =
                (int) ChronoUnit.DAYS.between(
                    LocalDate.now(),
                    deadline.toLocalDate()
                );


            if (daysLeft < 0) {
                daysLeft = 0;
            }

        }


        // Get priority level

        int priorityLevel =
            rs.getInt("priority_level");


        String priority = "Low";


        if (priorityLevel == 3) {

            priority = "High";

        }
        else if (priorityLevel == 2) {

            priority = "Medium";

        }


        // Calculate AI score

        int score =
            AIRecommendation.calculateScore(
                progress,
                pendingTasks,
                daysLeft,
                priority
            );


        // Calculate recommended study time

        int minutes =
            AIRecommendation.getStudyMinutes(score);


        // Create map for subject

        Map<String, Object> item =
            new HashMap<>();


        item.put("subject", subject);

        item.put("progress", progress);

        item.put("pending", pendingTasks);

        item.put("priority", priority);

        item.put("score", score);

        item.put("minutes", minutes);


        // Add subject to plan

        plans.add(item);

    }


    rs.close();

    ps.close();

    con.close();

}

catch (Exception e) {

    out.println(
        "<p style='color:red;'>Error: "
        + e.getMessage()
        + "</p>"
    );

}


// Sort subjects by highest AI score

plans.sort(
    (a, b) ->
        Integer.compare(
            (Integer) b.get("score"),
            (Integer) a.get("score")
        )
);

%>


<!-- Study Order Heading -->

<div class="plan">

    <h2>📅 Today's AI Recommended Study Order</h2>

    <p>
        Subjects are arranged according to their AI priority score.
    </p>

</div>


<%

int planNumber = 1;


// Display each subject

for (Map<String, Object> item : plans) {


    String subject =
        (String) item.get("subject");


    int progress =
        (Integer) item.get("progress");


    int pending =
        (Integer) item.get("pending");


    String priority =
        (String) item.get("priority");


    int score =
        (Integer) item.get("score");


    int minutes =
        (Integer) item.get("minutes");


    // Decide card color

    String cssClass = "low";


    if (score >= 70) {

        cssClass = "high";

    }
    else if (score >= 50) {

        cssClass = "medium";

    }

%>


<!-- Subject Plan Card -->

<div class="plan <%= cssClass %>">


    <div class="time">

        #<%= planNumber %>
        — <%= subject %>

    </div>


    <p>

        <b>⏱ Recommended Study Time:</b>

        <%= minutes %> minutes

    </p>


    <p>

        <b>📊 Progress:</b>

        <%= progress %>%

    </p>


    <p>

        <b>📝 Pending Tasks:</b>

        <%= pending %>

    </p>


    <p>

        <b>🔴 Priority:</b>

        <%= priority %>

    </p>


    <p class="score">

        🤖 AI Score: <%= score %>

    </p>


    <p>

        <b>💡 Why study this now?</b>


        <%

        if (score >= 90) {

        %>

            Very high priority because of low progress,
            pending work and/or approaching deadlines.

        <%

        }
        else if (score >= 70) {

        %>

            High priority. Give this subject extra study time.

        <%

        }
        else if (score >= 50) {

        %>

            Medium priority. Include this subject in today's plan.

        <%

        }
        else {

        %>

            Lower priority. Regular revision is sufficient.

        <%

        }

        %>

    </p>


</div>


<%

    planNumber++;

}


// If no subjects exist

if (plans.size() == 0) {

%>


<div class="plan low">

    <h2>🎉 No Study Plan Available</h2>

    <p>

        Add subjects, tasks and progress to generate
        your personalized AI study plan.

    </p>

</div>


<%

}

%>


<!-- Navigation Buttons -->

<a class="back" href="recommendation.jsp">

    ← AI Recommendations

</a>


<a class="back" href="dashboard.jsp">

    ← Dashboard

</a>


</div>


</body>

</html>