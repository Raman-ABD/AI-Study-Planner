<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>AI Study Planner - Register</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3a8a, #4f46e5);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-box {
            background: white;
            width: 400px;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .logo {
            text-align: center;
            font-size: 45px;
        }

        h2 {
            text-align: center;
            color: #1e3a8a;
            margin-bottom: 8px;
        }

        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            color: #444;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-top: 7px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 7px;
            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #4f46e5;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #1e3a8a;
            color: white;
            border: none;
            border-radius: 7px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #4f46e5;
        }

        .login {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }

        .login a {
            color: #1e3a8a;
            font-weight: bold;
            text-decoration: none;
        }

    </style>

</head>

<body>

<div class="register-box">

    <div class="logo">🎓</div>

    <h2>Create Account</h2>

    <p class="subtitle">
        Start planning your studies smarter
    </p>

    <form action="RegisterServlet" method="post">

        <label>Name</label>

        <input type="text"
               name="name"
               placeholder="Enter your name"
               required>

        <label>Email</label>

        <input type="email"
               name="email"
               placeholder="Enter your email"
               required>

        <label>Password</label>

        <input type="password"
               name="password"
               placeholder="Create a password"
               required>

        <button type="submit">
            Create Account
        </button>

    </form>

    <div class="login">

        Already have an account?

        <a href="login.jsp">
            Login
        </a>

    </div>

</div>

</body>

</html>