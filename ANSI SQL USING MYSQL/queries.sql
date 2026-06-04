-- 1. User Upcoming Events
-- Show a list of all upcoming events a user is registered for in their city, sorted by date.
SELECT
  u.full_name AS User,
  e.event_id,
  e.title,
  e.start_date,
  e.end_date
FROM users u
JOIN registrations r ON u.user_id = r.user_id
JOIN events e ON r.event_id = e.event_id
WHERE e.city = u.city
  AND e.status = 'upcoming'
ORDER BY e.start_date ASC;

-- 2. Top Rated Events
-- Identify events with the highest average rating, considering only those that have received at least 10 feedback submissions.
SELECT 
  e.title AS Event,
  AVG(f.rating) AS Average_Rating,
  COUNT(f.feedback_id) AS Feedback_Count
FROM events e
JOIN feedback f ON f.event_id = e.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY AVG(f.rating) DESC;

-- 3. Inactive Users
-- Retrieve users who have not registered for any events in the last 90 days.
SELECT 
  u.user_id,
  u.full_name AS Users,
  u.email,
  MAX(r.registration_date) AS Last_Registration_Date
FROM users u
LEFT JOIN registrations r ON u.user_id = r.user_id
GROUP BY u.user_id, u.full_name, u.email
HAVING MAX(r.registration_date) IS NULL OR MAX(r.registration_date) <= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
ORDER BY u.full_name;

-- 4. Peak Session Hours
-- Count how many sessions are scheduled between 10 AM to 12 PM for each event.
SELECT 
  e.event_id,
  e.title AS Event,
  COUNT(s.session_id) AS Session_Count_10AM_12PM
FROM events e
LEFT JOIN sessions s ON e.event_id = s.event_id
WHERE TIME(s.start_time) >= '10:00:00' 
  AND TIME(s.end_time) <= '12:00:00'
GROUP BY e.event_id, e.title
ORDER BY Session_Count_10AM_12PM DESC;

-- 5. Most Active Cities
-- List the top 5 cities with the highest number of distinct user registrations.
SELECT 
  u.city,
  COUNT(DISTINCT r.user_id) AS Distinct_User_Registrations
FROM users u
JOIN registrations r ON u.user_id = r.user_id
GROUP BY u.city
ORDER BY Distinct_User_Registrations DESC
LIMIT 5;

-- 6. Event Resource Summary
-- Generate a report showing the number of resources (PDFs, images, links) uploaded for each event.
SELECT 
  e.event_id,
  e.title AS Event,
  COUNT(CASE WHEN r.resource_type = 'pdf' THEN 1 END) AS PDF_Count,
  COUNT(CASE WHEN r.resource_type = 'image' THEN 1 END) AS Image_Count,
  COUNT(CASE WHEN r.resource_type = 'link' THEN 1 END) AS Link_Count,
  COUNT(r.resource_id) AS Total_Resources
FROM events e
LEFT JOIN resources r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title
ORDER BY Total_Resources DESC;

-- 7. Low Feedback Alerts
-- List all users who gave feedback with a rating less than 3, along with their comments and associated event names.
SELECT 
  u.user_id,
  u.full_name AS User,
  e.title AS Event,
  f.rating,
  f.comments,
  f.feedback_date
FROM users u
JOIN feedback f ON u.user_id = f.user_id
JOIN events e ON f.event_id = e.event_id
WHERE f.rating < 3
ORDER BY f.feedback_date DESC, u.full_name;

-- 8. Sessions per Upcoming Event
-- Display all upcoming events with the count of sessions scheduled for them.
SELECT 
  e.event_id,
  e.title AS Event,
  e.start_date,
  e.city,
  COUNT(s.session_id) AS Session_Count
FROM events e
LEFT JOIN sessions s ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id, e.title, e.start_date, e.city
ORDER BY e.start_date ASC;

-- 9. Organizer Event Summary
-- For each event organizer, show the number of events created and their current status (upcoming, completed, cancelled).
SELECT 
  u.user_id,
  u.full_name AS Organizer,
  e.status,
  COUNT(e.event_id) AS Event_Count
FROM users u
LEFT JOIN events e ON u.user_id = e.organizer_id
GROUP BY u.user_id, u.full_name, e.status
HAVING e.status IS NOT NULL
ORDER BY u.full_name, e.status;

-- 10. Feedback Gap
-- Identify events that had registrations but received no feedback at all.
SELECT 
  e.event_id,
  e.title AS Event,
  COUNT(DISTINCT r.user_id) AS Registration_Count,
  COUNT(f.feedback_id) AS Feedback_Count
FROM events e
JOIN registrations r ON e.event_id = r.event_id
LEFT JOIN feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) = 0
ORDER BY Registration_Count DESC;

-- 11. Daily New User Count
-- Find the number of users who registered each day in the last 7 days.
SELECT 
  u.registration_date AS Date,
  COUNT(u.user_id) AS New_User_Count
FROM users u
WHERE u.registration_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY u.registration_date
ORDER BY u.registration_date DESC;

-- 12. Event with Maximum Sessions
-- List the event(s) with the highest number of sessions.
SELECT 
  e.event_id,
  e.title AS Event,
  COUNT(s.session_id) AS Session_Count
FROM events e
LEFT JOIN sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(s.session_id) = (
  SELECT COUNT(s2.session_id)
  FROM events e2
  LEFT JOIN sessions s2 ON e2.event_id = s2.event_id
  GROUP BY e2.event_id
  ORDER BY COUNT(s2.session_id) DESC
  LIMIT 1
)
ORDER BY e.title;

-- 13. Average Rating per City
-- Calculate the average feedback rating of events conducted in each city.
SELECT 
  e.city,
  AVG(f.rating) AS Average_Rating,
  COUNT(f.feedback_id) AS Feedback_Count,
  COUNT(DISTINCT f.event_id) AS Event_Count
FROM events e
LEFT JOIN feedback f ON e.event_id = f.event_id
GROUP BY e.city
ORDER BY Average_Rating DESC;

-- 14. Most Registered Events
-- List top 3 events based on the total number of user registrations.
SELECT 
  e.event_id,
  e.title AS Event,
  e.start_date,
  e.city,
  COUNT(r.registration_id) AS Registration_Count
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title, e.start_date, e.city
ORDER BY Registration_Count DESC
LIMIT 3;

-- 15. Event Session Time Conflict
-- Identify overlapping sessions within the same event (i.e., session start and end times that conflict).
SELECT 
  e.event_id,
  e.title AS Event,
  s1.session_id AS Session_1_ID,
  s1.title AS Session_1_Title,
  s1.speaker_name AS Speaker_1,
  s1.start_time AS Session_1_Start,
  s1.end_time AS Session_1_End,
  s2.session_id AS Session_2_ID,
  s2.title AS Session_2_Title,
  s2.speaker_name AS Speaker_2,
  s2.start_time AS Session_2_Start,
  s2.end_time AS Session_2_End
FROM events e
JOIN sessions s1 ON e.event_id = s1.event_id
JOIN sessions s2 ON e.event_id = s2.event_id
WHERE s1.session_id < s2.session_id
  AND NOT (s1.end_time <= s2.start_time OR s2.end_time <= s1.start_time)
ORDER BY e.event_id, s1.session_id;

-- 16. Unregistered Active Users
-- Find users who created an account in the last 30 days but haven't registered for any events.
SELECT 
  u.user_id,
  u.full_name AS User,
  u.email,
  u.city,
  u.registration_date
FROM users u
LEFT JOIN registrations r ON u.user_id = r.user_id
WHERE u.registration_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND r.registration_id IS NULL
ORDER BY u.registration_date DESC;

-- 17. Multi-Session Speakers
-- Identify speakers who are handling more than one session across all events.
SELECT 
  s.speaker_name,
  COUNT(s.session_id) AS Session_Count,
  COUNT(DISTINCT s.event_id) AS Event_Count,
  GROUP_CONCAT(DISTINCT e.title ORDER BY e.title SEPARATOR ', ') AS Events
FROM sessions s
JOIN events e ON s.event_id = e.event_id
GROUP BY s.speaker_name
HAVING COUNT(s.session_id) > 1
ORDER BY Session_Count DESC;

-- 18. Resource Availability Check
-- List all events that do not have any resources uploaded.
SELECT 
  e.event_id,
  e.title AS Event,
  e.start_date,
  e.city,
  COUNT(r.resource_id) AS Resource_Count
FROM events e
LEFT JOIN resources r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title, e.start_date, e.city
HAVING COUNT(r.resource_id) = 0
ORDER BY e.start_date DESC;

-- 19. Completed Events with Feedback Summary
-- For completed events, show total registrations and average feedback rating.
SELECT 
  e.event_id,
  e.title AS Event,
  e.start_date,
  e.city,
  COUNT(DISTINCT r.registration_id) AS Total_Registrations,
  COUNT(f.feedback_id) AS Feedback_Count,
  ROUND(AVG(f.rating), 2) AS Average_Rating
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
LEFT JOIN feedback f ON e.event_id = f.event_id
WHERE e.status = 'completed'
GROUP BY e.event_id, e.title, e.start_date, e.city
ORDER BY Average_Rating DESC;

-- 20. User Engagement Index
-- For each user, calculate how many events they attended and how many feedbacks they submitted.
SELECT 
  u.user_id,
  u.full_name AS User,
  u.email,
  COUNT(DISTINCT r.event_id) AS Events_Registered,
  COUNT(DISTINCT f.feedback_id) AS Feedbacks_Submitted
FROM users u
LEFT JOIN registrations r ON u.user_id = r.user_id
LEFT JOIN feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name, u.email
ORDER BY Events_Registered DESC, Feedbacks_Submitted DESC;

-- 21. Top Feedback Providers
-- List top 5 users who have submitted the most feedback entries.
SELECT 
  u.user_id,
  u.full_name AS User,
  u.email,
  COUNT(f.feedback_id) AS Feedback_Count,
  ROUND(AVG(f.rating), 2) AS Average_Rating_Given
FROM users u
JOIN feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name, u.email
ORDER BY Feedback_Count DESC
LIMIT 5;

-- 22. Duplicate Registrations Check
-- Detect if a user has been registered more than once for the same event.
SELECT 
  u.user_id,
  u.full_name AS User,
  e.event_id,
  e.title AS Event,
  COUNT(r.registration_id) AS Registration_Count
FROM users u
JOIN registrations r ON u.user_id = r.user_id
JOIN events e ON r.event_id = e.event_id
GROUP BY u.user_id, u.full_name, e.event_id, e.title
HAVING COUNT(r.registration_id) > 1
ORDER BY u.full_name, e.title;

-- 23. Registration Trends
-- Show a month-wise registration count trend over the past 12 months.
SELECT 
  DATE_FORMAT(r.registration_date, '%Y-%m') AS Month,
  COUNT(r.registration_id) AS Registration_Count
FROM registrations r
WHERE r.registration_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(r.registration_date, '%Y-%m')
ORDER BY DATE_FORMAT(r.registration_date, '%Y-%m') DESC;

-- 24. Average Session Duration per Event
-- Compute the average duration (in minutes) of sessions in each event.
SELECT 
  e.event_id,
  e.title AS Event,
  COUNT(s.session_id) AS Session_Count,
  ROUND(AVG(TIMESTAMPDIFF(MINUTE, s.start_time, s.end_time)), 2) AS Average_Duration_Minutes
FROM events e
LEFT JOIN sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
ORDER BY Average_Duration_Minutes DESC;

-- 25. Events Without Sessions
-- List all events that currently have no sessions scheduled under them.
SELECT 
  e.event_id,
  e.title AS Event,
  e.start_date,
  e.city,
  e.status,
  COUNT(s.session_id) AS Session_Count
FROM events e
LEFT JOIN sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title, e.start_date, e.city, e.status
HAVING COUNT(s.session_id) = 0
ORDER BY e.start_date DESC;