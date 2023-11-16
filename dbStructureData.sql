DROP  SCHEMA  IF EXISTS fitness;
CREATE SCHEMA fitness;
USE fitness;

CREATE TABLE user (
  user_id INTEGER  NOT NULL AUTO_INCREMENT,
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
  user_id INTEGER  NOT NULL AUTO_INCREMENT,
  hashed_password VARCHAR(120) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE intake_log (
  intake_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  intake_type ENUM ('Water', 'Calorie') NOT NULL,
  amount INTEGER  NOT NULL,
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (intake_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE physical_health_log (
  health_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  measure_type ENUM ('Weight', 'Height') NOT NULL,
  amount DECIMAL(5, 2) NOT NULL, -- in kilograms for weight, in centimeters for height (?)
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mental_health_log (
  health_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  stress_level ENUM('Low', 'Medium', 'High') NOT NULL,
  sleep_quality ENUM('Poor', 'Fair', 'Good', 'Excellent') NOT NULL,
  mood ENUM('Happy', 'Neutral', 'Sad') NOT NULL,
  recorded_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE progress_photo (
  photo_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  photo_path VARCHAR(255) NOT NULL,
  description TEXT,
  date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (photo_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_category (
  category_id INTEGER  NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_muscle_category (
  category_id INTEGER  NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_equipment (
  equipment_id INTEGER  NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (equipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise (
  exercise_id INTEGER  NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INTEGER  NOT NULL,
  muscle_group_id INTEGER ,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (exercise_id),
  FOREIGN KEY (category_id) REFERENCES exercise_category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE equipment_for_exercise (
  exercise_equipment_id INTEGER  NOT NULL AUTO_INCREMENT,
  exercise_id INTEGER  NOT NULL,
  equipment_id INTEGER  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (exercise_equipment_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise (exercise_id),
  FOREIGN KEY (equipment_id) REFERENCES exercise_equipment (equipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach_category (
  category_id INTEGER  NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(255),
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE state (
  state_id INTEGER  NOT NULL AUTO_INCREMENT,
  state_name VARCHAR(255) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (state_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach (
  coach_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  category_id INTEGER ,
  bio TEXT,
  state_id INTEGER  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (coach_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (category_id) REFERENCES coach_category (category_id),
  FOREIGN KEY (state_id) REFERENCES state (state_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE workout_plan (
  plan_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  coach_id INTEGER ,
  plan_name VARCHAR(255) NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (plan_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (coach_id) REFERENCES coach (coach_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_in_workout_plan (
  exercise_in_plan_id INTEGER  NOT NULL AUTO_INCREMENT,
  plan_id INTEGER  NOT NULL,
  exercise_id INTEGER  NOT NULL,
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
  workout_id INTEGER  NOT NULL AUTO_INCREMENT,
  plan_id INTEGER ,
  exercise_in_plan_id INTEGER ,
  user_id INTEGER  NOT NULL,
  coach_id INTEGER ,
  workout_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  sets INTEGER , -- actual performance
  reps INTEGER , -- actual performance
  duration_minutes INTEGER, -- actual performance
  notes TEXT,
  PRIMARY KEY (workout_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (plan_id) REFERENCES workout_plan (plan_id),
  FOREIGN KEY (exercise_in_plan_id) REFERENCES exercise_in_workout_plan (exercise_in_plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# There is a table in the drive that shows relation betwen isActive and subscription_start_date inside of the google drive
CREATE TABLE subscription (
  subscription_id INTEGER  NOT NULL AUTO_INCREMENT,
  subscriber_id INTEGER  NOT NULL,
  coach_id INTEGER  NOT NULL,
  subscription_start_date DATE,
  subscription_end_date DATE,
  isActive BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (subscription_id),
  FOREIGN KEY (subscriber_id) REFERENCES user(user_id),
  FOREIGN KEY (coach_id) REFERENCES coach(coach_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_media (
  media_id INTEGER  NOT NULL AUTO_INCREMENT,
  exercise_id INTEGER  NOT NULL,
  coach_id INTEGER , -- The coach who uploaded the media (optional)
  user_id INTEGER , -- The user for whom the media is designated for (optional)
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
  payment_id INTEGER  NOT NULL AUTO_INCREMENT,
  subscription_id INTEGER  NOT NULL,
  user_id INTEGER  NOT NULL,
  payment_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  amount DECIMAL(10, 2),
  payment_method VARCHAR(255), -- ie paypal, credit. not actual card numbers
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (subscription_id) REFERENCES subscription(subscription_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE message (
  message_id INTEGER  NOT NULL AUTO_INCREMENT,
  sender_id INTEGER  NOT NULL,
  recipient_id INTEGER  NOT NULL,
  message_text TEXT NOT NULL,
  sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (message_id),
  FOREIGN KEY (sender_id) REFERENCES user(user_id),
  FOREIGN KEY (recipient_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE coach_review (
  review_id INTEGER  NOT NULL AUTO_INCREMENT,
  coach_id INTEGER  NOT NULL,
  user_id INTEGER  NOT NULL,
  rating TINYINT  NOT NULL, -- 1-10 scale?
  review_text TEXT NOT NULL, -- users should give rational for rating
  review_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  PRIMARY KEY (review_id),
  FOREIGN KEY (coach_id) REFERENCES coach (coach_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE weight_goal (
  goal_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  target_weight INTEGER  NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  date_to_complete DATE NOT NULL,
  achieved BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (goal_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fitness_goal (
  goal_id INTEGER  NOT NULL AUTO_INCREMENT,
  user_id INTEGER  NOT NULL,
  exercise_id INTEGER  NOT NULL,
  description TEXT NOT NULL,
  creation_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
  date_to_complete DATE NOT NULL,
  achieved BOOL DEFAULT FALSE,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (goal_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (exercise_id) REFERENCES exercise (exercise_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
