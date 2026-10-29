<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.studyplanner.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Smart Timetable</title>

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
            max-width: 1000px;
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        input,
        select {
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

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #1e3a8a;
            color: white;
            padding: 13px;
            text-align: left;
        }

        td {
            padding: 13px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8fafc;
        }

        .time {
            font-weight: bold;
            color: #1e3a8a;
        }

        @media(max-width: 700px) {

            .form-row {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 13px;
            }

        }

    </style>

</head>

<body>


<div class="navbar">

    <h2>📅 AI Study Planner</h2>

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


<!-- Add Study Plan -->

<div class="box">

    <h2>➕ Create Study Plan</h2>

    <form action="TimetableServlet" method="post">

        <div class="form-row">


            <!-- Subject -->

            <div>

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

            </div>


            <!-- Study Date -->

            <div>

                <label>Study Date</label>

                <input
                    type="date"
                    name="studyDate"
                    required>

            </div>


            <!-- Start Time -->

            <div>

                <label>Start Time</label>

                <select name="startTime" required>

                    <option value="">
                        Select Start Time
                    </option>

                    <option value="08:00">08:00 AM</option>
                    <option value="09:00">09:00 AM</option>
                    <option value="10:00">10:00 AM</option>
                    <option value="11:00">11:00 AM</option>
                    <option value="12:00">12:00 PM</option>
                    <option value="13:00">01:00 PM</option>
                    <option value="14:00">02:00 PM</option>
                    <option value="15:00">03:00 PM</option>
                    <option value="16:00">04:00 PM</option>
                    <option value="17:00">05:00 PM</option>
                    <option value="18:00">06:00 PM</option>
                    <option value="19:00">07:00 PM</option>
                    <option value="20:00">08:00 PM</option>
                    <option value="21:00">09:00 PM</option>
                    <option value="22:00">10:00 PM</option>

                </select>

            </div>


            <!-- End Time -->

            <div>

                <label>End Time</label>

                <select name="endTime" required>

                    <option value="">
                        Select End Time
                    </option>

                    <option value="08:00">08:00 AM</option>
                    <option value="09:00">09:00 AM</option>
                    <option value="10:00">10:00 AM</option>
                    <option value="11:00">11:00 AM</option>
                    <option value="12:00">12:00 PM</option>
                    <option value="13:00">01:00 PM</option>
                    <option value="14:00">02:00 PM</option>
                    <option value="15:00">03:00 PM</option>
                    <option value="16:00">04:00 PM</option>
                    <option value="17:00">05:00 PM</option>
                    <option value="18:00">06:00 PM</option>
                    <option value="19:00">07:00 PM</option>
                    <option value="20:00">08:00 PM</option>
                    <option value="21:00">09:00 PM</option>
                    <option value="22:00">10:00 PM</option>

                </select>

            </div>


        </div>


        <button type="submit">
            Add Study Plan
        </button>

    </form>

</div>


<!-- Timetable -->

<div class="box">

    <h2>📅 My Study Timetable</h2>

    <table>

        <tr>

            <th>Subject</th>

            <th>Study Date</th>

            <th>Start Time</th>

            <th>End Time</th>

        </tr>


<%

    String timetableSql =
        "SELECT s.subject_name, t.study_date, " +
        "t.start_time, t.end_time " +

        "FROM timetable t " +

        "JOIN subjects s " +
        "ON t.subject_id = s.subject_id " +

        "WHERE t.student_id = ? " +

        "ORDER BY t.study_date, t.start_time";


    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(timetableSql);

        ps.setInt(1, studentId);

        ResultSet rs =
            ps.executeQuery();


        // Format time as AM/PM

        SimpleDateFormat timeFormat =
            new SimpleDateFormat("hh:mm a");


        while (rs.next()) {

%>


        <tr>


            <td>

                📚 <%= rs.getString("subject_name") %>

            </td>


            <td>

                📅 <%= rs.getDate("study_date") %>

            </td>


            <td class="time">

                <%= timeFormat.format(
                    rs.getTime("start_time")
                ) %>

            </td>


            <td class="time">

                <%= timeFormat.format(
                    rs.getTime("end_time")
                ) %>

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
            "<tr><td colspan='4'>" +
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