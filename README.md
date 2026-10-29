# AI Study Planner

## Project Overview

AI Study Planner is a Java-based web application designed to help students organize their academic activities. It allows users to manage subjects, tasks, timetables, and study progress through a web interface.

## Features

* **User Registration and Login:** Allows users to register and log in.
* **Subject Management:** Organizes academic subjects.
* **Task Management:** Helps students manage their study tasks.
* **Timetable Management:** Helps students organize their study schedules.
* **Progress Tracking:** Tracks study progress.
* **Study Recommendations:** Provides study recommendations based on task priorities.
* **Daily Study Plan:** Helps students plan their daily study activities.

## Technologies Used

* Java
* Java Servlets
* JSP (JavaServer Pages)
* JDBC
* MySQL
* HTML
* Apache Tomcat
* Eclipse IDE

## Project Structure

```text
AI_StudyPlanner/
├── src/
│   └── main/
│       ├── java/com/studyplanner/
│       │   ├── AIRecommendation.java
│       │   ├── DBConnection.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── ProgressServlet.java
│       │   ├── RecommendationServlet.java
│       │   ├── RegisterServlet.java
│       │   ├── SubjectServlet.java
│       │   ├── TaskServlet.java
│       │   └── TimetableServlet.java
│       └── webapp/
│           ├── dashboard.jsp
│           ├── dailyplan.jsp
│           ├── login.jsp
│           ├── progress.jsp
│           ├── recommendation.jsp
│           ├── register.jsp
│           ├── subjects.jsp
│           ├── tasks.jsp
│           └── timetable.jsp
└── README.md
```

## Database

The application uses MySQL to store application data.

Create a database named `studyplanner` and configure the database connection in `DBConnection.java`.

**Security Note:** Do not upload real database passwords or other sensitive credentials to a public repository.

## How to Run

1. Clone or download this repository.
2. Import the project into Eclipse.
3. Configure Apache Tomcat and the MySQL database.
4. Update the database connection settings.
5. Run the application on the configured server.

## Purpose

This project was developed as an academic project to practice Java web development, database connectivity, and study-planning functionality.

## Author

Raman-ABD
