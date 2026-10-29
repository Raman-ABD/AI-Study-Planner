<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.studyplanner.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Progress Tracking</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .navbar {
            background: #1e3a8a;
            color: white;
            padding: 18px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h2 {
            margin: 0;
        }

        .back {
            color: white;
            text-decoration: none;
        }

        .container {
            max-width: 900px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #ddd;
            margin-bottom: 25px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        select,
        input {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 7px;
            font-size: 15px;
        }

        button {
            margin-top: 20px;
            padding: 12px 22px;
            background: #1e3a8a;
            color: white;
            border: none;
            border-radius: 7px;
            cursor: pointer;
        }

        button:hover {
            background: #4f46e5;
        }

        .progress-row {
            margin-bottom: 22px;
        }

        .subject {
            font-weight: bold;
            margin-bottom: 7px;
        }

        .progress-bar {
            width: 100%;
            height: 22px;
            background: #e5e7eb;
            border-radius: 20px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: #4f46e5;
            color: white;
            text-align: center;
            line-height: 22px;
            font-size: 13px;
        }

    </style>

</head>

<body>


<div class="navbar">

    <h2>📊 AI Study Planner</h2>

    <a class="back" href="dashboard.jsp">
        ← Dashboard
    </a>

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

%>


<!-- Update Progress -->

<div class="box">

    <h2>📈 Update Subject Progress</h2>

    <form action="ProgressServlet" method="post">


        <label>Subject</label>

        <select name="subjectId" required>

            <option value="">
                Select Subject
            </option>


<%

    String subjectSql =
        "SELECT subject_id, subject_name " +
        "FROM subjects WHERE student_id = ?";


    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(subjectSql);

        ps.setInt(1, studentId);

        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

%>


            <option value="<%= rs.getInt("subject_id") %>">

                <%= rs.getString("subject_name") %>

            </option>


<%

        }


        rs.close();
        ps.close();
        con.close();


    }
    catch (Exception e) {

        out.println(e.getMessage());

    }

%>


        </select>


        <br><br>


        <label>Progress (%)</label>

        <input
            type="number"
            name="progress"
            min="0"
            max="100"
            placeholder="Enter progress from 0 to 100"
            required>


        <button type="submit">
            Update Progress
        </button>

    </form>

</div>


<!-- Subject Progress -->

<div class="box">

    <h2>📊 My Subject Progress</h2>


<%

    String progressSql =
        "SELECT s.subject_name, " +
        "COALESCE(p.progress_percent, 0) AS progress " +

        "FROM subjects s " +

        "LEFT JOIN study_progress p " +
        "ON s.subject_id = p.subject_id " +
        "AND p.student_id = ? " +

        "WHERE s.student_id = ?";


    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(progressSql);

        ps.setInt(1, studentId);
        ps.setInt(2, studentId);

        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            String subject =
                rs.getString("subject_name");

            int progress =
                rs.getInt("progress");

%>


    <div class="progress-row">


        <div class="subject">

            📚 <%= subject %>

        </div>


        <div class="progress-bar">

            <div
                class="progress-fill"
                style="width:<%= progress %>%">

                <%= progress %>%

            </div>

        </div>


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


</div>


</div>

</body>

</html>