<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.studyplanner.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Subjects</title>

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

        input {
            width: 70%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 7px;
            font-size: 15px;
        }

        button {
            padding: 12px 20px;
            background: #1e3a8a;
            color: white;
            border: none;
            border-radius: 7px;
            cursor: pointer;
        }

        button:hover {
            background: #4f46e5;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #1e3a8a;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8fafc;
        }

        .back {
            color: white;
            text-decoration: none;
        }

    </style>

</head>

<body>


<div class="navbar">

    <h2>📚 AI Study Planner</h2>

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


<div class="box">

    <h2>➕ Add New Subject</h2>

    <form action="SubjectServlet" method="post">

        <input
            type="text"
            name="subjectName"
            placeholder="Enter subject name"
            required>

        <button type="submit">
            Add Subject
        </button>

    </form>

</div>


<div class="box">

    <h2>📚 My Subjects</h2>

    <table>

        <tr>

            <th>ID</th>

            <th>Subject Name</th>

        </tr>


<%

    String sql =
        "SELECT subject_id, subject_name " +
        "FROM subjects WHERE student_id = ?";


    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(sql);

        ps.setInt(1, studentId);

        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

%>


        <tr>

            <td>
                <%= rs.getInt("subject_id") %>
            </td>

            <td>
                📖 <%= rs.getString("subject_name") %>
            </td>

        </tr>


<%

        }


        rs.close();
        ps.close();
        con.close();


    }
    catch (Exception e) {

        out.println(
            "<tr><td colspan='2'>" +
            e.getMessage() +
            "</td></tr>"
        );

    }

%>


    </table>

</div>


</div>

</body>

</html>