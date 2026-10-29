package com.studyplanner;

public class AIRecommendation {

    // AI score calculate karta hai
    public static int calculateScore(
            int progress,
            int pendingTasks,
            int daysLeft,
            String priority) {

        int score = 0;

        // Progress kam hai to study priority badhegi
        if (progress < 40)
            score += 40;
        else if (progress < 70)
            score += 25;
        else
            score += 10;

        // Pending tasks zyada hain to priority badhegi
        if (pendingTasks >= 3)
            score += 30;
        else if (pendingTasks >= 1)
            score += 20;
        else
            score += 5;

        // Deadline paas hai to priority badhegi
        if (daysLeft <= 2)
            score += 30;
        else if (daysLeft <= 5)
            score += 20;
        else
            score += 5;

        // Task priority
        if (priority.equalsIgnoreCase("High"))
            score += 20;
        else if (priority.equalsIgnoreCase("Medium"))
            score += 10;
        else
            score += 5;

        return score;
    }


    // Score ke basis par recommendation
    public static String getRecommendation(int score) {

        if (score >= 90)
            return "Very High Priority - Study this subject first.";

        else if (score >= 70)
            return "High Priority - Give extra study time.";

        else if (score >= 50)
            return "Medium Priority - Include it in today's study plan.";

        else
            return "Low Priority - Continue regular revision.";
    }


    // AI score ke basis par study time decide karta hai
    public static int getStudyMinutes(int score) {

        if (score >= 90)
            return 90;

        else if (score >= 70)
            return 60;

        else if (score >= 50)
            return 45;

        else
            return 30;
    }
}