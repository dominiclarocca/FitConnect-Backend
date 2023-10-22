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
  PRIMARY KEY  (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_credentials (
  user_credentials_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  salt VARCHAR(64) NOT NULL,
  hashed_password VARCHAR(64) NOT NULL,
  PRIMARY KEY (user_credentials_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE physical_health_current (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  height DECIMAL(5, 2) NOT NULL, -- in centimeters(?)
  weight DECIMAL(5, 2) NOT NULL, -- in kilograms(?)
  recorded_date DATE NOT NULL, # date of insert / update
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE physical_health_log (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  height DECIMAL(5, 2) NOT NULL, -- in centimeters(?)
  weight DECIMAL(5, 2) NOT NULL, -- in kilograms(?)
  recorded_date DATE NOT NULL, # date of when it was inserted to physical_health_current
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE progress_photo (
  photo_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  photo_path VARCHAR(255) NOT NULL,
  recorded_date DATE NOT NULL, # date of insert
  description TEXT,
  PRIMARY KEY (photo_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mental_health_current (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  stress_level ENUM('Low', 'Medium', 'High'),
  sleep_quality ENUM('Poor', 'Fair', 'Good', 'Excellent'),
  mood ENUM('Happy', 'Neutral', 'Sad'),
  recorded_date DATE NOT NULL, # date of insert / update
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mental_health_log (
  health_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  stress_level ENUM('Low', 'Medium', 'High'),
  sleep_quality ENUM('Poor', 'Fair', 'Good', 'Excellent'),
  mood ENUM('Happy', 'Neutral', 'Sad'),
  recorded_date DATE NOT NULL, # date of when it was inserted to mental_health_current
  PRIMARY KEY (health_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise_category (
  category_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE exercise (
  exercise_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (exercise_id),
  FOREIGN KEY (category_id) REFERENCES exercise_category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE workout_log (
  workout_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INTEGER UNSIGNED NOT NULL,
  workout_date DATE NOT NULL,
  duration_minutes INTEGER,
  notes TEXT,
  PRIMARY KEY (workout_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER // 
CREATE TRIGGER after_update_physical_health_current
AFTER UPDATE ON physical_health_current FOR EACH ROW
BEGIN
  INSERT INTO physical_health_log (user_id, height, weight, recorded_date)
  VALUES (NEW.user_id, NEW.height, NEW.weight, NEW.recorded_date);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_update_mental_health_current
AFTER UPDATE ON mental_health_current FOR EACH ROW
BEGIN
  INSERT INTO mental_health_log (user_id, stress_level, sleep_quality, mood, recorded_date)
  VALUES (NEW.user_id, NEW.stress_level, NEW.sleep_quality, NEW.mood, NEW.recorded_date);
END;
//
DELIMITER ;
INSERT INTO user (email, first_name, last_name, gender, birth_date) VALUES 
('michael.miller@example.com', 'Michael', 'Miller', 'Female', '2003-10-12'),
('robert.jones@example.com', 'Robert', 'Jones', 'Female', '1990-07-05'),
('linda.thomas@example.com', 'Linda', 'Thomas', 'Male', '1985-01-03'),
('david.brown@example.com', 'David', 'Brown', 'Female', '1984-07-16'),
('william.thompson@example.com', 'William', 'Thompson', 'Male', '1986-08-31'),
('barbara.taylor@example.com', 'Barbara', 'Taylor', 'Female', '1999-09-22'),
('susan.jackson@example.com', 'Susan', 'Jackson', 'Male', '2004-04-03'),
('elizabeth.wilson@example.com', 'Elizabeth', 'Wilson', 'Female', '2005-03-13'),
('jessica.smith@example.com', 'Jessica', 'Smith', 'Female', '1992-04-24'),
('richard.anderson@example.com', 'Richard', 'Anderson', 'Male', '1997-12-17'),
('charles.davis@example.com', 'Charles', 'Davis', 'Female', '1995-04-02'),
('thomas.garcia@example.com', 'Thomas', 'Garcia', 'Female', '1997-05-24'),
('john.williams@example.com', 'John', 'Williams', 'Female', '1985-05-07'),
('joseph.robinson@example.com', 'Joseph', 'Robinson', 'Male', '2003-07-03'),
('karen.martin@example.com', 'Karen', 'Martin', 'Female', '2001-07-09'),
('jennifer.harris@example.com', 'Jennifer', 'Harris', 'Male', '2003-09-14'),
('patricia.johnson@example.com', 'Patricia', 'Johnson', 'Male', '1985-09-11'),
('james.moore@example.com', 'James', 'Moore', 'Male', '1994-12-28'),
('sarah.white@example.com', 'Sarah', 'White', 'Female', '1996-12-31'),
('mary.martinez@example.com', 'Mary', 'Martinez', 'Male', '1994-12-17');
INSERT INTO user_credentials (user_id, salt, hashed_password) VALUES 
(1, '876d54051b379db9', '54d326b26f65021491ecaa29ccfc662bb9720ba0fa615ed0627379b96fb729bc'),
(2, '007fd10eb1d9e5c9', '27b9b8c4a9324b71148e5b50f0ec4a776193ebc87ce740c54c432fbff4a2a0cf'),
(3, '143b94993162efa3', 'a0575ae7c9222101f0a97be8841ad78db9eff604b94c77972d98bf6afbc7812a'),
(4, 'f7e7628f01aa1a7d', '9cd48162fabd51a765c3809fed22501884afabc4bb04e23320d9fe8d8a085103'),
(5, '9b79011469da46a4', 'b6229f1a0f7f97888fdbd31b212e6feb3bccc1a1409b71763e498b754b762ecc'),
(6, 'a471c1c353b9b591', 'e69d25b68086a595bad8cdc986f87b35fdf7cd94eb9c062169300456a7d52d90'),
(7, '63f01fcb7264bffc', 'a0f098ab97901fb388e09851349910f076bdb3799d83e1c57b654756439b5971'),
(8, '8ef98d04368af5b2', '82cb558325832c6e0fb7dccd3b5b8bf0f4a3592289a8b504eafb1eda3d9e84e0'),
(9, '0e12d302bde9b0dc', 'c9612ec4756a6e68d72781e0c8592f6ec36b3bf0fa149e78b46fc9bec7b34063'),
(10, '7dbafa2b5b7678ee', 'fc41f549c26b155433eed325a1b6948856363624581a8d35839e9cdc55b9be6c'),
(11, '5d3ce887e326c1ba', '874f6f29eb5e4f87f37678a100245519e44d5202b037b68da3e5bf1c8fa36a41'),
(12, 'cc15dc14e5d5de46', 'db63626b2e28672c62966418fdf8092d535c6600d298fdbd9536c9b2706d1ef0'),
(13, '5d11148d3c4900b5', '6faf0829d87272faf246d246f8b0a99dab20ec4261dff63b28f80dd1d531f3ab'),
(14, 'cc5002e3ce9f2fb4', '7d8e45d8dee17464c378a3644072d20d1eac9bdd82c48af5cf3c77476be09081'),
(15, 'd234659ca9e217e4', '6cbe99a9c9d0155d44674bc698c179f2007ce2076773769c56afd0ab48f34fb1'),
(16, 'e017734ab5c42e9e', 'e0d63d08e029cc01350f0fe4fc8a6507fffcef76e7f1a1aac4fd5014a4f10a1d'),
(17, '8fa4cf52c7d55ff6', 'ff52a8a9310725419c57c694cec344f134d941090b6cf1a3098fc6c6ce4da259'),
(18, '6154929fc7668e33', '7ee60c9443adeeb8740c8450722a660f81cb59a736d9361318c102f03d864cb4'),
(19, '989b7b7835762842', '5e8b876acdf101ef595bf48935e0d5f779ba16e204524634fbcdf854eea262b0'),
(20, '3e89caf6ef5adb87', '2f022b192c0c5606db5000f9c63e140f01d0f6d1559f8329c6a12fbf5179c659');
INSERT INTO physical_health_current (user_id, height, weight, recorded_date) VALUES 
(1, 65.49, 163.16, '2023-10-22'), 
(2, 63.45, 182.59, '2023-10-22'), 
(3, 64.61, 155.04, '2023-10-22'), 
(4, 63.38, 179.80, '2023-10-22'), 
(5, 63.91, 156.66, '2023-10-22'), 
(6, 72.63, 177.05, '2023-10-22'), 
(7, 60.56, 183.65, '2023-10-22'), 
(8, 61.52, 153.27, '2023-10-22'), 
(9, 76.60, 150.07, '2023-10-22'), 
(10, 76.39, 159.51, '2023-10-22'), 
(11, 62.51, 150.55, '2023-10-22'), 
(12, 63.51, 151.19, '2023-10-22'), 
(13, 64.53, 152.07, '2023-10-22'), 
(14, 60.20, 184.85, '2023-10-22'), 
(15, 78.30, 162.14, '2023-10-22'), 
(16, 71.97, 152.93, '2023-10-22'), 
(17, 63.52, 156.87, '2023-10-22'), 
(18, 76.62, 171.91, '2023-10-22'), 
(19, 76.34, 154.48, '2023-10-22'), 
(20, 71.24, 166.16, '2023-10-22');
INSERT INTO physical_health_log (user_id, height, weight, recorded_date) VALUES 
(1, 65.49, 167.88, '2023-06-18'), 
(2, 63.45, 183.57, '2023-09-17'), 
(3, 64.61, 154.63, '2023-06-27'), 
(4, 63.38, 183.79, '2023-07-11'), 
(5, 63.91, 159.36, '2023-06-29'), 
(6, 72.63, 177.74, '2023-07-29'), 
(7, 60.56, 182.37, '2023-09-15'), 
(8, 61.52, 154.66, '2023-06-12'), 
(9, 76.60, 153.91, '2023-06-11'), 
(10, 76.39, 164.03, '2023-09-01'), 
(11, 62.51, 150.74, '2023-08-03'), 
(12, 63.51, 150.82, '2023-07-01'), 
(13, 64.53, 154.25, '2023-08-11'), 
(14, 60.20, 183.04, '2023-08-16'), 
(15, 78.30, 157.89, '2023-08-13'), 
(16, 71.97, 157.53, '2023-09-13'), 
(17, 63.52, 157.88, '2023-09-19'), 
(18, 76.62, 176.56, '2023-05-18'), 
(19, 76.34, 150.27, '2023-08-29'), 
(20, 71.24, 168.25, '2023-06-13');
INSERT INTO progress_photo (user_id, photo_path, recorded_date, description) VALUES 
(1, '/user_1/photos/c17370642e63405e.jpg', '2023-03-06', 'End of 3 month challenge'), 
(2, '/user_2/photos/0687cf4463f54e73.jpg', '2023-04-05', 'New personal record'), 
(3, '/user_3/photos/46d8cbccb9e88242.jpg', '2022-11-15', 'One year transformation'), 
(4, '/user_4/photos/3b5e8a3e5cff923e.jpg', '2023-04-23', 'Back on track'), 
(5, '/user_5/photos/aec838f86ea309b6.jpg', '2023-06-15', 'End of 3 month challenge'), 
(6, '/user_6/photos/6fd6591e4bdf7f7a.jpg', '2023-09-04', 'Consistency is key'), 
(7, '/user_7/photos/a2aa27f74ff076c1.jpg', '2022-11-22', 'New personal record'), 
(8, '/user_8/photos/bf9790e2fa8ea361.jpg', '2022-11-19', 'Consistency is key'), 
(9, '/user_9/photos/af3aca638a0d0a92.jpg', '2022-11-26', 'Seeing muscle definition'), 
(10, '/user_10/photos/aeb4e2db2979b981.jpg', '2022-12-24', 'Progress after 1 month'), 
(11, '/user_11/photos/f9e6f62ffc23f6df.jpg', '2023-07-25', 'Seeing muscle definition'), 
(12, '/user_12/photos/4470662ee6c18079.jpg', '2023-07-27', 'Summer body ready'), 
(13, '/user_13/photos/accdd8301b54d821.jpg', '2023-08-30', 'Post workout pic'), 
(14, '/user_14/photos/fad4732dca5d8c23.jpg', '2023-02-28', 'One year transformation'), 
(15, '/user_15/photos/bc87f1068f6405d0.jpg', '2023-07-19', 'One year transformation'), 
(16, '/user_16/photos/823312e12c4f93a5.jpg', '2023-01-19', 'Reached my goal weight'), 
(17, '/user_17/photos/75c5fda44e31fae6.jpg', '2022-10-27', 'Flexing'), 
(18, '/user_18/photos/ab0a082ae63c00e5.jpg', '2023-08-05', 'Reached my goal weight'), 
(19, '/user_19/photos/ca52171a05e205e4.jpg', '2023-09-13', 'Feeling confident'), 
(20, '/user_20/photos/e67c676e5b1ab18f.jpg', '2023-03-08', 'Progress after 1 month');
INSERT INTO mental_health_current (user_id, stress_level, sleep_quality, mood, recorded_date) VALUES 
(1, 'Low', 'Fair', 'Neutral', '2023-10-22'), 
(2, 'Medium', 'Poor', 'Neutral', '2023-10-22'), 
(3, 'Low', 'Fair', 'Sad', '2023-10-22'), 
(4, 'Medium', 'Good', 'Sad', '2023-10-22'), 
(5, 'Medium', 'Fair', 'Sad', '2023-10-22'), 
(6, 'High', 'Poor', 'Neutral', '2023-10-22'), 
(7, 'High', 'Fair', 'Neutral', '2023-10-22'), 
(8, 'Low', 'Excellent', 'Sad', '2023-10-22'), 
(9, 'Medium', 'Excellent', 'Sad', '2023-10-22'), 
(10, 'Low', 'Good', 'Happy', '2023-10-22'), 
(11, 'Low', 'Poor', 'Sad', '2023-10-22'), 
(12, 'Medium', 'Poor', 'Sad', '2023-10-22'), 
(13, 'Medium', 'Poor', 'Happy', '2023-10-22'), 
(14, 'Low', 'Fair', 'Happy', '2023-10-22'), 
(15, 'Medium', 'Fair', 'Happy', '2023-10-22'), 
(16, 'Medium', 'Excellent', 'Sad', '2023-10-22'), 
(17, 'Medium', 'Excellent', 'Neutral', '2023-10-22'), 
(18, 'High', 'Excellent', 'Happy', '2023-10-22'), 
(19, 'High', 'Poor', 'Sad', '2023-10-22'), 
(20, 'Medium', 'Poor', 'Neutral', '2023-10-22');
INSERT INTO mental_health_log (user_id, stress_level, sleep_quality, mood, recorded_date) VALUES 
(1, 'Medium', 'Fair', 'Neutral', '2023-07-18'), 
(2, 'Low', 'Fair', 'Sad', '2023-07-07'), 
(3, 'High', 'Good', 'Happy', '2023-05-07'), 
(4, 'High', 'Poor', 'Happy', '2023-09-12'), 
(5, 'Medium', 'Fair', 'Sad', '2023-08-30'), 
(6, 'Low', 'Poor', 'Neutral', '2023-08-25'), 
(7, 'High', 'Poor', 'Sad', '2023-08-18'), 
(8, 'Low', 'Poor', 'Sad', '2023-08-24'), 
(9, 'Medium', 'Poor', 'Neutral', '2023-05-27'), 
(10, 'Medium', 'Fair', 'Sad', '2023-07-07'), 
(11, 'Medium', 'Good', 'Sad', '2023-09-13'), 
(12, 'Medium', 'Good', 'Sad', '2023-05-11'), 
(13, 'High', 'Good', 'Happy', '2023-08-02'), 
(14, 'High', 'Excellent', 'Sad', '2023-08-12'), 
(15, 'Low', 'Good', 'Neutral', '2023-09-19'), 
(16, 'Low', 'Poor', 'Neutral', '2023-09-11'), 
(17, 'Low', 'Fair', 'Sad', '2023-05-04'), 
(18, 'Low', 'Poor', 'Happy', '2023-07-24'), 
(19, 'Medium', 'Poor', 'Sad', '2023-09-03'), 
(20, 'Low', 'Poor', 'Happy', '2023-05-02');
INSERT INTO exercise_category (name) VALUES 
('Cardio'), 
('Strength'), 
('Flexibility'), 
('Balance'), 
('Aerobic'), 
('Anaerobic'), 
('Endurance'), 
('Core'), 
('Upper Body'), 
('Lower Body'), 
('Interval Training'), 
('Circuit Training'), 
('Functional Fitness'), 
('CrossFit'), 
('Pilates'), 
('Yoga'), 
('HIIT'), 
('Calisthenics'), 
('Powerlifting'), 
('Olympic Weightlifting');
INSERT INTO exercise (name, description, category_id) VALUES 
('Cardio', 'A high-intensity workout that boosts metabolism', 1), 
('Strength', 'A low-impact exercise for endurance', 2), 
('Flexibility', 'Strength training using weights', 3), 
('Balance', 'Yoga poses for flexibility and relaxation', 4), 
('Aerobic', 'A series of bodyweight exercises', 5), 
('Anaerobic', 'Intense training with short rest periods', 6), 
('Endurance', 'Lifting heavy weights for fewer repetitions', 7), 
('Core', 'Dynamic movements using bodyweight', 8), 
('Upper Body', 'Functional movements with weights', 9), 
('Lower Body', 'Stretching exercises to improve flexibility', 10), 
('Interval Training', 'Balancing poses for core strength', 11), 
('Circuit Training', 'Aerobic exercises for cardiovascular health', 12), 
('Functional Fitness', 'Anaerobic exercises for muscle strength', 13), 
('CrossFit', 'Interval training for fat burn', 14), 
('Pilates', 'Circuit training for full-body workout', 15), 
('Yoga', 'Pilates exercises for core strength', 16), 
('HIIT', 'Yoga flow for flexibility and balance', 17), 
('Calisthenics', 'High-intensity interval training', 18), 
('Powerlifting', 'Bodyweight exercises for strength and flexibility', 19), 
('Olympic Weightlifting', 'Olympic lifts for power and strength', 20);
INSERT INTO workout_log (user_id, workout_date, duration_minutes, notes) VALUES 
(1, '2023-08-19', 72, 'Achieved a new personal best!'), 
(2, '2023-06-20', 41, 'Great workout!'), 
(3, '2023-09-19', 75, 'Pushed myself hard.'), 
(4, '2023-05-12', 88, 'Incorporated flexibility exercises.'), 
(5, '2023-09-20', 112, 'Moderate workout.'), 
(6, '2023-04-30', 87, 'Felt a bit tired today.'), 
(7, '2023-07-13', 79, 'Moderate workout.'), 
(8, '2023-07-17', 45, 'Great workout!'), 
(9, '2023-05-07', 19, 'Focused on strength training.'), 
(10, '2023-08-06', 102, 'Pushed myself hard.'), 
(11, '2023-06-08', 79, 'Focused on strength training.'), 
(12, '2023-05-18', 112, 'Short but intense workout!'), 
(13, '2023-08-04', 50, 'Incorporated flexibility exercises.'), 
(14, '2023-05-08', 29, 'Incorporated flexibility exercises.'), 
(15, '2023-09-01', 82, 'Short but intense workout!'), 
(16, '2023-09-07', 82, 'Great workout!'), 
(17, '2023-09-30', 97, 'Moderate workout.'), 
(18, '2023-08-28', 32, 'Cardio day!'), 
(19, '2023-06-23', 86, 'Focused on strength training.'), 
(20, '2023-10-16', 74, 'Cardio day!');

