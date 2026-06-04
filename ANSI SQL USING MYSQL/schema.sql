-- 1.Users Table
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  registration_date DATE NOT NULL
);

-- 2.Events Table
CREATE TABLE events (
  event_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  city VARCHAR(100) NOT NULL,
  start_date DATETIME NOT NULL,
  end_date DATETIME NOT NULL,
  status ENUM('upcoming', 'completed', 'cancelled'),
  organizer_id INT,
  -- Add constraints here
  CONSTRAINT fk_user_id FOREIGN KEY (organizer_id) REFERENCES users(user_id)
);

-- 3.Sessions Table
CREATE TABLE sessions (
  session_id INT PRIMARY KEY AUTO_INCREMENT,
  event_id INT,
  title VARCHAR(200) NOT NULL,
  speaker_name VARCHAR(100) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  -- Add constraints here
  CONSTRAINT fk_event_id FOREIGN KEY (event_id) REFERENCES events(event_id)
);

-- 4.Registrations Table
CREATE TABLE registrations (
  registration_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  event_id INT,
  registration_date DATE NOT NULL,
  -- ADD CONSTRAINTS HERE
  CONSTRAINT fk_registration_user FOREIGN KEY(user_id) REFERENCES users(user_id),
  CONSTRAINT fk_registration_event FOREIGN KEY(event_id) REFERENCES events(event_id)
);

-- 5.Feedback Table
CREATE TABLE feedback (
  feedback_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  event_id INT,
  rating INT,
  comments TEXT,
  feedback_date DATE NOT NULL,
  -- ADD CONSTRAINTS HERE
  CONSTRAINT chk_feedback_rating CHECK(rating BETWEEN 1 AND 5),
  CONSTRAINT fk_feedback_user FOREIGN KEY(user_id) REFERENCES users(user_id),
  CONSTRAINT fk_feedback_event FOREIGN KEY(event_id) REFERENCES events(event_id) 
);

-- 6. Resources Table
CREATE TABLE resources (
  resource_id INT PRIMARY KEY AUTO_INCREMENT,
  event_id INT,
  resource_type ENUM('pdf', 'image', 'link'),
  resource_url VARCHAR(255) NOT NULL,
  uploaded_at DATETIME NOT NULL,
  -- ADD CONSTRAINTS HERE
  CONSTRAINT fk_resource_event FOREIGN KEY(event_id) REFERENCES events(event_id)
);