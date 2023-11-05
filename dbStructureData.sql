DROP  SCHEMA  IF EXISTS fitness;
CREATE SCHEMA fitness;
USE fitness;

CREATE TABLE user (
  user_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(254) UNIQUE NOT NULL,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  gender ENUM('Male', 'Female'),
  birth_date DATE,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_credentials (
  user_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  salt VARCHAR(64) NOT NULL,
  hashed_password VARCHAR(64) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE intake_log (
  intake_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  intake_type ENUM ('Water', 'Calorie') NOT NULL,
  amount INTEGER UNSIGNED NOT NULL,
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (intake_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE physical_health_log (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  measure_type ENUM ('Weight', 'Height') NOT NULL,
  amount DECIMAL(5, 2) NOT NULL, -- in kilograms for weight, in centimeters for height (?)
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mental_health_log (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  stress_level ENUM('Low', 'Medium', 'High') NOT NULL,
  sleep_quality ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
  mood ENUM('Happy', 'Neutral', 'Sad') NOT NULL,
  recorded_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE progress_photo (
  photo_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  photo_path VARCHAR(255) NOT NULL,
  description TEXT,
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (photo_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_category (
  category_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_muscle_category (
  category_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_equipment (
  equipment_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (equipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise (
  exercise_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INTEGER UNSIGNED NOT NULL,
  muscle_group_id INTEGER UNSIGNED,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (exercise_id),
  FOREIGN KEY (category_id) REFERENCES exercise_category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE equipment_for_exercise (
  exercise_equipment_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  exercise_id INTEGER UNSIGNED NOT NULL,
  equipment_id INTEGER UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (exercise_equipment_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise (exercise_id),
  FOREIGN KEY (equipment_id) REFERENCES exercise_equipment (equipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach_category (
  category_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(255),
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE state (
  state_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  state_name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (state_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach (
  coach_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  category_id INTEGER UNSIGNED,
  bio TEXT,
  state_id INTEGER UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (coach_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (category_id) REFERENCES coach_category (category_id),
  FOREIGN KEY (state_id) REFERENCES state (state_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE workout_plan (
  plan_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  coach_id INTEGER UNSIGNED,
  plan_name VARCHAR(255) NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (plan_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (coach_id) REFERENCES coach (coach_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_in_workout_plan (
  exercise_in_plan_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  plan_id INTEGER UNSIGNED NOT NULL,
  exercise_id INTEGER UNSIGNED NOT NULL,
  sets INTEGER, -- expected performance
  reps INTEGER, -- expected performance
  duration_minutes INTEGER,    -- expected performance
  calories INTEGER,
  complete_by_date DATE NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (exercise_in_plan_id),
  FOREIGN KEY (plan_id) REFERENCES workout_plan(plan_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE workout_log (
  workout_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  plan_id INTEGER UNSIGNED,
  exercise_in_plan_id INTEGER UNSIGNED,
  user_id INTEGER UNSIGNED NOT NULL,
  coach_id INTEGER UNSIGNED,
  workout_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  sets INTEGER UNSIGNED, -- actual performance
  reps INTEGER UNSIGNED, -- actual performance
  duration_minutes INTEGER, -- actual performance
  notes TEXT,
  PRIMARY KEY (workout_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (plan_id) REFERENCES workout_plan (plan_id),
  FOREIGN KEY (exercise_in_plan_id) REFERENCES exercise_in_workout_plan (exercise_in_plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# There is a table in the drive that shows relation betwen isActive and subscription_start_date inside of the google drive
CREATE TABLE subscription (
  subscription_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  subscriber_id INTEGER UNSIGNED NOT NULL,
  coach_id INTEGER UNSIGNED NOT NULL,
  subscription_start_date DATE,
  subscription_end_date DATE,
  isActive BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (subscription_id),
  FOREIGN KEY (subscriber_id) REFERENCES user(user_id),
  FOREIGN KEY (coach_id) REFERENCES coach(coach_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_media (
  media_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  exercise_id INTEGER UNSIGNED NOT NULL,
  coach_id INTEGER UNSIGNED, -- The coach who uploaded the media (optional)
  user_id INTEGER UNSIGNED, -- The user for whom the media is designated for (optional)
  media_type ENUM ('Image', 'Video', 'Audio') NOT NULL,
  media_url VARCHAR(255) NOT NULL,
  description TEXT,
  upload_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (media_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id),
  FOREIGN KEY (coach_id) REFERENCES coach(coach_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE payment (
  payment_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  subscription_id INTEGER UNSIGNED NOT NULL,
  user_id INTEGER UNSIGNED NOT NULL,
  payment_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  amount DECIMAL(10, 2),
  payment_method VARCHAR(255), -- ie paypal, credit. not actual card numbers
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (subscription_id) REFERENCES subscription(subscription_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE message (
  message_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  sender_id INTEGER UNSIGNED NOT NULL,
  recipient_id INTEGER UNSIGNED NOT NULL,
  message_text TEXT NOT NULL,
  sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (message_id),
  FOREIGN KEY (sender_id) REFERENCES user(user_id),
  FOREIGN KEY (recipient_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach_review (
  review_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  coach_id INTEGER UNSIGNED NOT NULL,
  user_id INTEGER UNSIGNED NOT NULL,
  rating TINYINT UNSIGNED NOT NULL, -- 1-10 scale?
  review_text TEXT NOT NULL, -- users should give rational for rating
  review_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (review_id),
  FOREIGN KEY (coach_id) REFERENCES coach (coach_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE weight_goal (
  goal_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  target_weight INTEGER UNSIGNED NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  date_to_complete DATE NOT NULL,
  achieved BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (goal_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fitness_goal (
  goal_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  exercise_id INTEGER UNSIGNED NOT NULL,
  description TEXT NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  date_to_complete DATE NOT NULL,
  achieved BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (goal_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise (exercise_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO user (email, first_name, last_name, gender, birth_date, creation_date) 
VALUES
  ('user4@example.com', 'Alice', 'Johnson', 'Female', '1992-07-25', '2023-10-27 16:45:00'),
  ('user5@example.com', 'Robert', 'Smith', 'Male', '1980-12-10', '2023-10-26 11:20:00'),
  ('user6@example.com', 'Emily', 'Brown', 'Female', '1998-04-15', '2023-10-25 13:10:00');

INSERT INTO user_credentials (salt, hashed_password) 
VALUES
  ('123abc', '1a1dc91c907325c69271ddf0c944bc72'),
  ('xyz456', '25d55ad283aa400af464c76d713c07ad'),
  ('password123', '5f4dcc3b5aa765d61d8327deb882cf99');

INSERT INTO intake_log (user_id, intake_type, amount, date) 
VALUES
  (1, 'Water', 600, '2023-10-26'),
  (1, 'Calorie', 350, '2023-10-25'),
  (2, 'Water', 800, '2023-10-26'),
  (2, 'Calorie', 500, '2023-10-25'),
  (3, 'Water', 550, '2023-10-26');

INSERT INTO physical_health_log (user_id, measure_type, amount, date)
VALUES
  (1, 'Weight', 75.5, '2023-10-26'),
  (1, 'Height', 175.0, '2023-10-25'),
  (2, 'Weight', 65.0, '2023-10-26'),
  (2, 'Height', 160.0, '2023-10-25'),
  (3, 'Weight', 70.2, '2023-10-26');

INSERT INTO mental_health_log (user_id, stress_level, sleep_quality, mood, recorded_date)
VALUES
  (1, 'Low', 'Good', 'Happy', '2023-10-26'),
  (1, 'Medium', 'Fair', 'Neutral', '2023-10-25'),
  (2, 'High', 'Poor', 'Sad', '2023-10-26'),
  (2, 'Medium', 'Good', 'Neutral', '2023-10-25'),
  (3, 'Low', 'Excellent', 'Happy', '2023-10-26');

INSERT INTO progress_photo (user_id, photo_path, description, date)
VALUES
  (1, 'photos/user1_1.jpg', 'Front view', '2023-10-26'),
  (1, 'photos/user1_2.jpg', 'Side view', '2023-10-25'),
  (2, 'photos/user2_1.jpg', 'Front view', '2023-10-26'),
  (2, 'photos/user2_2.jpg', 'Side view', '2023-10-25'),
  (3, 'photos/user3_1.jpg', 'Front view', '2023-10-26');

INSERT INTO exercise_category (name)
VALUES
  ('Cardio'),
  ('Strength Training'),
  ('Yoga'),
  ('Pilates');

INSERT INTO exercise_muscle_category (name)
VALUES
  ('Legs'),
  ('Arms'),
  ('Chest'),
  ('Back');

INSERT INTO exercise_equipment (name, description)
VALUES
  ('Dumbbells', 'Various weights available.'),
  ('Treadmill', 'Cardio equipment for running or walking.'),
  ('Yoga Mat', 'For practicing yoga and pilates.'),
  ('Resistance Bands', 'Flexible bands for strength training.');

INSERT INTO exercise (name, description, category_id, muscle_group_id)
VALUES
  ('Running', 'Cardio exercise', 1, NULL),
  ('Bicep Curls', 'Strength training for arms', 2, 2),
  ('Yoga Poses', 'Various yoga poses', 3, NULL),
  ('Push-Ups', 'Strength training for chest', 2, 3),
  ('Deadlifts', 'Strength training for back and legs', 2, 1);

INSERT INTO equipment_for_exercise (exercise_id, equipment_id)
VALUES
  (2, 1),
  (4, 3),
  (5, 1);

INSERT INTO coach_category (category_name)
VALUES
  ('Fitness'),
  ('Nutrition'),
  ('Mental Health');

INSERT INTO state (state_name)
VALUES
  ('California'),
  ('New York'),
  ('Texas'),
  ('Florida');

INSERT INTO coach (user_id, category_id, bio, state_id)
VALUES
  (1, 1, 'Certified fitness coach with 10 years of experience', 1),
  (2, 2, 'Nutrition expert helping clients achieve their goals', 2),
  (3, 3, 'Experienced mental health counselor', 3);

INSERT INTO workout_plan (user_id, coach_id, plan_name)
VALUES
  (1, 1, 'Fitness Plan A'),
  (1, 2, 'Nutrition Plan A'),
  (2, 1, 'Fitness Plan B'),
  (2, 3, 'Mental Health Plan A');

INSERT INTO exercise_in_workout_plan (plan_id, exercise_id, sets, reps, duration_minutes, complete_by_date)
VALUES
  (1, 2, 3, 12, 45, '2023-11-15'),
  (1, 4, 4, 15, 60, '2023-11-15'),
  (2, 3, 1, 0, 30, '2023-11-10'),
  (3, 2, 4, 10, 45, '2023-11-20');


INSERT INTO workout_log (plan_id, exercise_in_plan_id, user_id, coach_id, sets, reps, duration_minutes, notes, workout_date)
VALUES
  (1, 1, 1, 1, 3, 12, 45, 'Great workout!', '2023-11-01'),
  (1, 2, 1, 1, 4, 15, 60, 'Feeling strong!', '2023-11-02'),
  (2, 3, 2, 1, 1, 0, 30, 'Slow progress today', '2023-11-03'),
  (3, 4, 2, 3, 4, 10, 45, 'Focused on form', '2023-11-04');

INSERT INTO coach_review (coach_id, user_id, rating, review_text, review_date)
VALUES
  (1, 1, 9, 'Excellent coach, very knowledgeable.', '2023-11-05'),
  (1, 2, 8, 'Great guidance, improved my fitness!', '2023-11-06'),
  (2, 3, 7, 'Nutrition advice was helpful.', '2023-11-07'),
  (3, 1, 9, 'Positive impact on my mental health.', '2023-11-08');

INSERT INTO exercise_media (exercise_id, coach_id, user_id, media_type, media_url, description, upload_date)
VALUES
  (1, 1, 1, 'Image', 'exercise_images/exercise1.jpg', 'Front view of exercise', '2023-11-10'),
  (2, 1, 2, 'Video', 'exercise_videos/exercise2.mp4', 'Tutorial for exercise', '2023-11-11'),
  (3, 2, 1, 'Image', 'exercise_images/exercise3.jpg', 'Side view of exercise', '2023-11-12'),
  (4, 3, 2, 'Image', 'exercise_images/exercise4.jpg', 'Detailed exercise image', '2023-11-13');

INSERT INTO fitness_goal (user_id, exercise_id, description, creation_date, date_to_complete)
VALUES
  (1, 1, 'Improve running stamina', '2023-11-15', '2024-04-15'),
  (1, 4, 'Build stronger chest muscles', '2023-11-16', '2024-05-16'),
  (2, 3, 'Achieve advanced yoga poses', '2023-11-17', '2024-06-17'),
  (2, 2, 'Increase bicep strength', '2023-11-18', '2024-07-18'),
  (3, 5, 'Enhance overall strength and fitness', '2023-11-19', '2024-08-19');

INSERT INTO message (sender_id, recipient_id, message_text, sent_date)
VALUES
  (1, 2, 'Hi Jane, how is your fitness plan going?', '2023-11-20 09:30:00'),
  (2, 1, 'Hi John, Im making good progress with the nutrition plan!', '2023-11-20 10:15:00'),
  (3, 1, 'John, remember to practice mindfulness daily.', '2023-11-21 11:45:00'),
  (1, 3, 'Feeling great after todays workout!', '2023-11-21 13:20:00'),
  (2, 3, 'Keep up the good work!', '2023-11-22 15:10:00');

INSERT INTO subscription (subscriber_id, coach_id, subscription_start_date, subscription_end_date, isActive)
VALUES
  (1, 1, '2023-11-01', '2023-12-01', 1),
  (2, 2, '2023-11-03', '2023-12-03', 1),
  (3, 1, '2023-11-02', '2023-12-02', 1),
  (1, 3, '2023-11-05', '2023-12-05', 1),
  (2, 1, '2023-11-10', '2023-12-10', 1);

INSERT INTO weight_goal (user_id, target_weight, creation_date, date_to_complete)
VALUES
  (1, 70, '2023-11-15', '2024-05-15'),
  (2, 60, '2023-11-16', '2024-06-16'),
  (3, 75, '2023-11-17', '2024-07-17'),
  (1, 68, '2023-11-18', '2024-08-18'),
  (2, 62, '2023-11-19', '2024-09-19');
  