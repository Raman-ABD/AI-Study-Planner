<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>AI Study Planner - Dashboard</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            text-align: center;
        }

        .header {
            background: #1e3a8a;
            color: white;
            padding: 25px;
        }

        .container {
            padding: 40px;
        }

        .modules {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 30px;
        }

        .module {
            display: block;
            width: 180px;
            padding: 25px;
            background: white;
            color: #1e3a8a;
            text-decoration: none;
            font-weight: bold;
            border-radius: 12px;
            box-shadow: 0 3px 10px #ddd;
        }

        .module:hover {
            background: #eef2ff;
        }

    </style>

</head>

<body>


<div class="header">

    <h1>🎓 AI Study Planner</h1>

    <h2>Student Dashboard</h2>

</div>


<div class="container">

    <h2>Welcome to AI Study Planner 👋</h2>

    <p>Login Successful!</p>


    <div class="modules">


        <!-- Subjects -->

        <a class="module" href="subjects.jsp">

            📚

            <br><br>

            Subjects

        </a>


        <!-- Tasks -->

        <a class="module" href="tasks.jsp">

            📝

            <br><br>

            Tasks

        </a>


        <!-- Timetable -->

        <a class="module" href="timetable.jsp">

            📅

            <br><br>

            Timetable

        </a>


        <!-- Progress -->

        <a class="module" href="progress.jsp">

            📊

            <br><br>

            Progress

        </a>


        <!-- AI Recommendations -->

        <a class="module" href="recommendation.jsp">

            🤖

            <br><br>

            Smart Recommendations

        </a>


        <!-- AI Daily Plan -->

        <a class="module" href="dailyplan.jsp">

            🧠

            <br><br>

            AI Daily Study Plan

        </a>


        <!-- Logout -->

        <a class="module" href="LogoutServlet">

            🚪

            <br><br>

            Logout

        </a>


    </div>

</div>


</body>

</html>