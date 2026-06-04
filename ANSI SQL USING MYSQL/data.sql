-- Users data
INSERT INTO users(user_id, full_name, email, city, registration_date) 
VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York', '2024-12-01'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles', '2024-12-05'),
(3, 'Charlie Lee', 'charlie@example.com', 'Chicago', '2024-12-10'),
(4, 'Diana King', 'diana@example.com', 'New York', '2025-01-15'),
(5, 'Ethan Hunt', 'ehtan@example.com', 'Los Angeles', '2025-02-01');

-- Events data
INSERT INTO events(event_id, title, description, city, start_date, end_date, status, organizer_id)
VALUES
(1, 'Tech Innovators Meetup', 'A meetup for tech enthusiasts.', 'New York', '2025-06-10 10:00:00', '2025-06-10 16:00:00', 'upcoming', 1),
(2, 'AI & ML Conference', 'Conference on AI and ML advancements.', 'Chicago', '2025-05-15 09:00:00', '2025-05-15 17:00:00', 'completed', 3),
(3, 'Frontend Developement Bootcamp', 'Hands-on training on frontend tech.', 'Los Angeles', '2025-07-01 10:00:00', '2025-07-03 16:00:00', 'upcoming', 2);

-- Sessions data
INSERT INTO sessions(session_id, event_id, title, speaker_name, start_time, end_time)
VALUES
(1, 1, 'Opening Keynote', 'Dr. Tech', '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(2, 1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(3, 2, 'AI in Healthcare', 'Charlie Lee', '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(4, 3, 'Intro to HTML5', 'Bob Smith', '2025-07-01 10:00:00', '2025-07-01 12:00:00');

-- Registrations data
INSERT INTO registrations (registration_id, user_id, event_id, registration_date)
VALUES
(1, 1, 1, '2025-05-01'),
(2, 2, 1, '2025-05-02'),
(3, 3, 2, '2025-04-30'),
(4, 4, 2, '2025-04-28'),
(5, 5, 3, '2025-06-15');

-- Feedback data
INSERT INTO feedback(feedback_id, user_id, event_id, rating, comments, feedback_date) 
VALUES
(1, 3, 2, 4, 'Great Insights!', '2025-05-16'),
(2, 4, 2, 5, 'Very informative.', '2025-05-16'),
(3, 2, 1, 3, 'Could be better.', '2025-06-11'),
(4, 1, 1, 4, 'Good sessions.', '2025-06-11'),
(5, 3, 1, 5, 'Excellent event.', '2025-06-11'),
(6, 4, 1, 4, 'Learned a lot.', '2025-06-11'),
(7, 5, 1, 5, 'Amazing speakers.', '2025-06-11'),
(8, 1, 1, 4, 'Well organized.', '2025-06-11'),
(9, 2, 1, 5, 'Worth attending.', '2025-06-11'),
(10, 3, 1, 4, 'Nice networking.', '2025-06-11'),
(11, 4, 1, 5, 'Great venue.', '2025-06-11'),
(12, 5, 1, 4, 'Helpful content.', '2025-06-11'),
(13, 1, 2, 5, 'Outstanding.', '2025-05-16'),
(14, 2, 2, 4, 'Very useful.', '2025-05-16'),
(15, 5, 2, 5, 'Fantastic talks.', '2025-05-16'),
(16, 1, 2, 5, 'Loved it.', '2025-05-16'),
(17, 2, 2, 4, 'Nice conference.', '2025-05-16'),
(18, 3, 2, 5, 'Excellent content.', '2025-05-16'),
(19, 4, 2, 5, 'Highly recommended.', '2025-05-16'),
(20, 5, 2, 4, 'Great experience.', '2025-05-16'),
(21, 1, 2, 5, 'Superb.', '2025-05-16'),
(22, 2, 2, 5, 'Very engaging.', '2025-05-16'),
(23, 3, 2, 4, 'Nice event.', '2025-05-16'),
(24, 4, 2, 5, 'Well managed.', '2025-05-16'),
(25, 1, 3, 4, 'Good bootcamp.', '2025-07-04'),
(26, 2, 3, 3, 'Average.', '2025-07-04'),
(27, 3, 3, 4, 'Helpful.', '2025-07-04'),
(28, 4, 3, 5, 'Excellent trainer.', '2025-07-04'),
(29, 5, 3, 4, 'Nice examples.', '2025-07-04'),
(30, 1, 3, 4, 'Practical sessions.', '2025-07-04'),
(31, 2, 3, 5, 'Very good.', '2025-07-04'),
(32, 3, 3, 4, 'Informative.', '2025-07-04');

-- Resources data
INSERT INTO resources(resource_id, event_id, resource_type, resource_url, uploaded_at)
VALUES
(1, 1, 'pdf', 'https://portal.com/resources/tech_meetup_agen', '2025-05-01 10:00:00'),
(2, 2, 'image', 'https://portal.com/resources/ai_poster.jpg', '2025-04-20 09:00:00'),
(3, 3, 'link', 'https://portal.com/resources/html5_docs', '2025-06-25 15:00:00');