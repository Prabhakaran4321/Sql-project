CREATE DATABASE STUDENT_MANAGEMENT_SYSTEM;

USE STUDENT_MANAGEMENT_SYSTEM;

-- (TABLES)

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    credits INT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    grade CHAR(2),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollment(enrollment_id)
);



-- (INSERT VALUES)

INSERT INTO Students (first_name, last_name, dob, gender, email, phone) VALUES
('Arun', 'Kumar', '2002-03-15', 'Male', 'arun.kumar@gmail.com', '9876543210'),
('Priya', 'Ramesh', '2001-07-22', 'Female', 'priya.ramesh@gmail.com', '9988776655'),
('Vignesh', 'Murali', '2003-01-10', 'Male', 'vignesh.murali@gmail.com', '9845123476'),
('Divya', 'Raj', '2002-10-25', 'Female', 'divya.raj@gmail.com', '9798654321'),
('Karthik', 'Suresh', '2001-12-30', 'Male', 'karthik.suresh@gmail.com', '9954123658');

INSERT INTO Instructors (first_name, last_name, email) VALUES
('Anitha', 'Devi', 'anitha.devi@college.edu'),
('Suresh', 'Kumar', 'suresh.kumar@college.edu'),
('Ravi', 'Narayan', 'ravi.narayan@college.edu'),
('Lakshmi', 'Priya', 'lakshmi.priya@college.edu'),
('Vijay', 'Krishnan', 'vijay.krishnan@college.edu');

INSERT INTO Courses (course_name, credits, instructor_id) VALUES
('Database Management Systems', 4, 1),
('Web Technologies', 3, 2),
('Operating Systems', 4, 3),
('Computer Networks', 3, 4),
('Java Programming', 4, 5);

INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-07-01'),
(2, 2, '2024-07-02'),
(3, 3, '2024-07-03'),
(4, 4, '2024-07-04'),
(5, 5, '2024-07-05');

INSERT INTO Grades (enrollment_id, grade) VALUES
(1, 'A'),
(2, 'B'),
(3, 'A'),
(4, 'C'),
(5, 'B');


-- (USING JOINS)

SELECT 
    s.first_name AS Student,
    c.course_name AS Course,
    i.first_name AS Instructor,
    g.grade AS Grade
FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Instructors i ON c.instructor_id = i.instructor_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;


-- (USING VIEW)

CREATE VIEW StudentCourseGrades AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS StudentName,
    c.course_name,
    g.grade
FROM Students s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id;

SELECT * FROM StudentCourseGrades;


-- (USING TRIGGER)

DELIMITER //
CREATE TRIGGER after_enroll_insert
AFTER INSERT ON Enrollment
FOR EACH ROW
BEGIN
    INSERT INTO Grades (enrollment_id, grade)
    VALUES (NEW.enrollment_id, 'NA');
END;
//
DELIMITER ;


-- (USING STORE PROCEDURE)

DELIMITER //
CREATE PROCEDURE GetCourseStudentCount()
BEGIN
    SELECT 
        c.course_name,
        COUNT(e.student_id) AS Total_Students
    FROM Courses c
    LEFT JOIN Enrollment e ON c.course_id = e.course_id
    GROUP BY c.course_name
    HAVING COUNT(e.student_id) > 0;
END //
DELIMITER ;

-- Execute
CALL GetCourseStudentCount();


-- (USING VIEW)

CREATE INDEX idx_student_name ON Students(first_name, last_name);
CREATE INDEX idx_student_email ON Students(email);


-- (USING SUB QUERY)

SELECT first_name, last_name
FROM Students
WHERE student_id IN (
    SELECT e.student_id
    FROM Enrollment e
    JOIN Grades g ON e.enrollment_id = g.enrollment_id
    WHERE g.grade = 'A'
);


-- (USING LIKE OPERATOR)

SELECT * FROM Students
WHERE first_name LIKE 'P%';


-- (USING GROUP_BY & HAVING)
SELECT 
    g.grade,
    COUNT(g.grade) AS grade_count
FROM Grades g
GROUP BY g.grade
HAVING COUNT(g.grade) > 1;







