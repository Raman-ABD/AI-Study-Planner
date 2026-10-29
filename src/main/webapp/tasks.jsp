<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.studyplanner.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>My Tasks</title>

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
    max-width: 1100px;
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
    font-weight: bold;
    display: block;
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

.priority-high {
    color: #dc2626;
    font-weight: bold;
}

.priority-medium {
    color: #f59e0b;
    font-weight: bold;
}

.priority-low {
    color: #16a34a;
    font-weight: bold;
}

.status-pending {
    color: #dc2626;
    font-weight: bold;
}

.status-completed {
    color: #16a34a;
    font-weight: bold;
}

.complete-btn {
    margin: 0;
    padding: 7px 12px;
    background: #16a34a;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.complete-btn:hover {
    background: #15803d;
}

.completed-text {
    color: #16a34a;
    font-weight: bold;
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

    <h2>📝 AI Study Planner</h2>

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


<!-- Add Task -->

<div class="box">

    <h2>➕ Add New Task</h2>

    <form action="TaskServlet" method="post">

        <div class="form-row">


            <div>

                <label>Task Name</label>

                <input
                    type="text"
                    name="taskName"
                    placeholder="e.g. Python Assignment"
                    required>

            </div>


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


            <div>

                <label>Deadline</label>

                <input
                    type="date"
                    name="deadline"
                    required>

            </div>


            <div>

                <label>Priority</label>

                <select name="priority" required>

                    <option value="High">
                        High
                    </option>

                    <option value="Medium">
                        Medium
                    </option>

                    <option value="Low">
                        Low
                    </option>

                </select>

            </div>


        </div>


        <button type="submit">
            Add Task
        </button>

    </form>

</div>


<!-- Task List -->

<div class="box">

    <h2>📋 My Tasks</h2>

    <table>

        <tr>

            <th>Task</th>

            <th>Subject</th>

            <th>Deadline</th>

            <th>Priority</th>

            <th>Status</th>

            <th>Action</th>

        </tr>


<%

    String taskSql =
        "SELECT t.task_id, t.task_name, s.subject_name, " +
        "t.deadline, t.priority, t.status " +
        "FROM tasks t " +
        "JOIN subjects s " +
        "ON t.subject_id = s.subject_id " +
        "WHERE t.student_id = ? " +
        "ORDER BY t.deadline";


    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(taskSql);

        ps.setInt(1, studentId);

        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            int taskId =
                rs.getInt("task_id");

            String priority =
                rs.getString("priority");

            String status =
                rs.getString("status");

%>


        <tr>


            <!-- Task -->

            <td>

                📝 <%= rs.getString("task_name") %>

            </td>


            <!-- Subject -->

            <td>

                📚 <%= rs.getString("subject_name") %>

            </td>


            <!-- Deadline -->

            <td>

                <%= rs.getDate("deadline") %>

            </td>


            <!-- Priority -->

            <td>

                <span class="priority-<%= priority.toLowerCase() %>">

                    <%= priority %>

                </span>

            </td>


            <!-- Status -->

            <td>

<%

                if ("Completed".equalsIgnoreCase(status)) {

%>

                    <span class="status-completed">
                        ✅ Completed
                    </span>

<%

                } else {

%>

                    <span class="status-pending">
                        ⏳ Pending
                    </span>

<%

                }

%>

            </td>


            <!-- Action -->

            <td>

<%

                if ("Completed".equalsIgnoreCase(status)) {

%>

                    <span class="completed-text">
                        Done ✓
                    </span>

<%

                } else {

%>

                    <form
                        action="TaskServlet"
                        method="get"
                        style="margin:0;">

                        <input
                            type="hidden"
                            name="taskId"
                            value="<%= taskId %>">

                        <button
                            type="submit"
                            class="complete-btn">

                            ✓ Mark Completed

                        </button>

                    </form>

<%

                }

%>

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
            "<tr><td colspan='6'>" +
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