create database StudentManagement;
use StudentManagement;

create table Students (
student_id int auto_increment primary key,
full_name varchar(100) not null,
date_of_birth date not null,
email varchar(100) not null unique
);

create table Classes (
class_id int auto_increment primary key,
class_name varchar(50) unique
);

create table Teachers (
teacher_id int auto_increment primary key,
full_name varchar(50) not null,
email varchar(100) not null
);

CREATE TABLE ClassAssignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    class_id INT,
    teacher_id INT,
    FOREIGN KEY (student_id)
        REFERENCES Students (student_id)
        ON DELETE CASCADE,
    FOREIGN KEY (class_id)
        REFERENCES Classes (class_id)
        ON DELETE CASCADE,
    FOREIGN KEY (teacher_id)
        REFERENCES Teachers (teacher_id)
        ON DELETE CASCADE
);

INSERT INTO Students (full_name, date_of_birth, email) VALUES
('Nguyễn Hoàng Anh', '2002-01-15', 'nguyenvana1@student.edu.vn'),
('Trần Thị B', '2001-05-20', 'bngtrang@student.edu.vn'),
('Lê Văn C', '2002-09-01', 'le.vanc@student.edu.vn'),
('Phạm Thị D', '2003-03-12', 'phamthid@student.edu.vn'),
('Đặng Văn E', '2001-11-23', 'dangvane@student.edu.vn'),
('Hoàng Thị F', '2002-07-30', 'hoangf@student.edu.vn'),
('Vũ Văn G', '2003-02-25', 'vug@student.edu.vn');

INSERT INTO students (full_name, date_of_birth, email) VALUES
('Nguyen Thi Mai Anh',     '2001-08-11', 'maianh.nguyen@example.com'),
('Pham Van Binh',          '2002-06-20', 'binh.pham@example.com'),
('Tran Ngoc Chau',         '2000-03-29', 'chau.tran@example.com'),
('Le Thi Anh Dao',         '2003-01-17', 'anhdao.le@example.com'),
('Do Quang Duy',           '2001-04-12', 'duy.do@example.com'),
( 'Hoang Minh Anh',         '2002-09-05', 'minhanh.hoang@example.com'),
( 'Nguyen Thanh Hien',      '2000-11-30', 'hien.nguyen@example.com'),
( 'Vo Van An',              '2003-07-07', 'an.vo@example.com'),
( 'Dang Thi Kim Ngan',      '2001-10-15', 'kimngan.dang@example.com'),
( 'Bui Anh Tuan',           '2002-12-01', 'anhtuan.bui@example.com');

INSERT INTO Classes (class_name) VALUES
('Web Development'),
('Data Science'),
('Python Basics'),
('Java Programming'),
('UI/UX Design'),
('Machine Learning'),
('Mobile App');

INSERT INTO Teachers (full_name, email) VALUES
('Thầy Trần Hữu Nhân', 'nhan@school.edu.vn'),
('Cô Nguyễn Hồng Yến', 'yen@school.edu.vn'),
('Thầy Lê Văn Quang', 'quang@school.edu.vn'),
('Cô Phạm Thị Mai', 'mai@school.edu.vn'),
('Thầy Hoàng Quốc Việt', 'viet@school.edu.vn'),
('Cô Trần Thị Tuyết', 'tuyet@school.edu.vn'),
('Thầy Bùi Xuân Thành', 'thanh@school.edu.vn');

INSERT INTO ClassAssignments (student_id, class_id, teacher_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 1, 1),
(5, 4, 4),
(6, 5, 5),
(7, 6, 6);


SELECT * FROM Students;
SELECT * FROM Classes;
SELECT * FROM Teachers;


-- Lấy tất cả thông tin sinh viên cùng với tên lớp và tên giáo viên của sinh viên đó .
SELECT 
    s.full_name AS student_name,
    l.class_name,
    t.full_name AS teacher
FROM
    ClassAssignments c
    JOIN Students s ON s.student_id = c.student_id
    JOIN Classes l ON c.class_id = l.class_id
    JOIN Teachers t ON c.teacher_id = t.teacher_id;
    
-- Tìm sinh viên có email chứa "ng" và sinh năm lớn hơn 2000.
SELECT 
    s.full_name AS student_name, s.email, s.date_of_birth
FROM
    students s
WHERE
    s.email LIKE '%ng%'
        AND YEAR(s.date_of_birth) > 2000;  -- không dùng trực tiếp date đc vì là kiểu DATE != number

-- Cập nhật tên lớp cho sinh viên có student_id = 2.
UPDATE ClassAssignments
SET class_id = (
    SELECT class_id FROM Classes WHERE class_name = 'Python Basics'
)
WHERE student_id = 2;

-- Xóa sinh viên có student_id = 3 và tất cả thông tin liên quan.
delete from students where student_id = 3;


-- Đếm số sinh viên trong từng lớp và chỉ hiển thị lớp có hơn 3 sinh viên.
SELECT 
    c.class_id,
    c.class_name,
    COUNT(cl.student_id) AS studentCount
FROM
    classes c
        JOIN
    classassignments cl ON c.class_id = cl.class_id
GROUP BY c.class_id
HAVING COUNT(cl.student_id) > 3;


-- -- Tìm giáo viên dạy nhiều lớp nhất.

SELECT 
    t.teacher_id,
    t.full_name AS teacher_name,
    COUNT(*) AS countClass
FROM
    teachers t
        JOIN
    classassignments cl ON t.teacher_id = cl.teacher_id
GROUP BY t.teacher_id
ORDER BY countClass DESC
LIMIT 1;

-- Lấy danh sách sinh viên và số lượng lớp tham gia của họ.
SELECT 
    s.full_name AS student_name,
    COUNT(ca.class_id) AS countClass
FROM
    students s
        JOIN
    classassignments ca ON s.student_id = ca.student_id
GROUP BY s.student_id;

-- Tìm lớp có tổng số sinh viên lớn hơn trung bình của tất cả các lớp.
-- dùng CTE - Common Table Expression

with class_student_count as (
select c.class_id, c.class_name, count(ca.student_id) as totalStudent
from classes c
join classassignments ca on c.class_id = ca.class_id
group by c.class_id, c.class_name ),
average_students as (
select avg(totalStudent) as avgStudent
from class_student_count)
select csc.class_id, csc.class_name, csc.totalStudent
 from class_student_count csc
join average_students avg on csc.totalStudent > avg.avgStudent;

-- Tìm giáo viên dạy sinh viên có student_id = 1

SELECT 
    t.teacher_id,
    t.full_name AS teacher_Name,
    s.full_name AS student_Name
FROM
    classassignments ca
        JOIN
    teachers t ON t.teacher_id = ca.teacher_id
        JOIN
    students s ON s.student_id = ca.student_id
WHERE
    ca.student_id = 1;


-- Lấy danh sách sinh viên sắp xếp theo ngày sinh từ sớm đến muộn.

SELECT 
    s.student_id, s.full_name AS student_Name, date_of_birth
FROM
    students s
ORDER BY date_of_birth;

-- Tìm sinh viên có tên bắt đầu bằng 'A' và tham gia ít nhất 2 lớp.
-- SELECT SUBSTRING_INDEX("www w3schools com", " ", -1);
SELECT 
    SUBSTRING_INDEX(full_name, ' ', - 1) as name,
    COUNT(*) AS lop
FROM
    students s
        JOIN
    classassignments ca ON ca.student_id = s.student_id
GROUP BY ca.student_id , full_name
HAVING COUNT(ca.class_id) >= 2
    AND SUBSTRING_INDEX(full_name, ' ', - 1) LIKE 'A%';



-- Tìm các giáo viên không dạy lớp nào.
select t.teacher_id, t.full_name
from teachers t
left join classassignments ca on ca.teacher_id = t.teacher_id -- Lấy tất cả giáo viên, kể cả khi không có bản ghi
where ca.class_id is null;

-- Lấy thông tin lớp và giáo viên cho những sinh viên có điểm trung bình lớn hơn 8.0.

alter table students
add average_score DECIMAL(4,2); -- 	Số thực, tổng 4 chữ số, 2 sau dấu chấm

SELECT DISTINCT
    s.full_name AS student_name,
    c.class_name,
    s.average_score,
    t.full_name AS teacher_name
FROM
    students s
        JOIN
    classassignments ca ON ca.student_id = s.student_id
        JOIN
    classes c ON c.class_id = ca.class_id
        JOIN
    teachers t ON t.teacher_id = ca.teacher_id
WHERE
    s.average_score > 8;
 
 
 -- Thống kê số lượng giáo viên và sinh viên theo từng lớp.
SELECT 
    c.class_name,
    COUNT(distinct( ca.teacher_id)) AS num_teacher,
    COUNT(distinct( ca.student_id)) AS num_student
FROM
    classes c
        JOIN
    classassignments ca ON c.class_id = ca.class_id
        JOIN
    teachers t ON t.teacher_id = ca.teacher_id
        JOIN
    students s ON s.student_id = ca.student_id
    group by c.class_id;


-- Lấy danh sách sinh viên có số lớp tham gia bằng số lớp tối đa.
 
SELECT 
    s.full_name AS student_name,                    
    COUNT(DISTINCT ca.class_id) AS total_classes         -- Tổng số lớp sinh viên này tham gia
FROM students s
JOIN classassignments ca ON ca.student_id = s.student_id -- Nối bảng phân công lớp để lấy lớp mà sinh viên tham gia
GROUP BY s.student_id, s.full_name                       -- Gom nhóm theo sinh viên để đếm số lớp của từng người
HAVING COUNT(DISTINCT ca.class_id) = (                   -- Lọc ra những sinh viên có số lớp tham gia là tối đa
    SELECT MAX(class_count)                              -- Tìm số lớp cao nhất mà một sinh viên đã tham gia
    FROM (
        SELECT student_id,                               -- Trong subquery: duyệt từng sinh viên
               COUNT(DISTINCT class_id) AS class_count   -- và đếm số lớp của họ
        FROM classassignments
        GROUP BY student_id ) as sub                            -- Gom theo sinh viên để đếm lớp của từng người
                                                 -- Đặt tên bảng phụ là "sub"
);

show global status like '%innodb_buffer_pool_read_requests%';
show global status like '%innodb_buffer_pool_reads%';
-- (requests - reads) *100/ requests. nếu nhỏ hơn 90% thì phải tối ưu
show create table students;
 explain analyze select *from students;
create index date_of_birth on students(date_of_birth);

alter table students alter index inx_studentDate invisible;
explain  select * from students where date_of_birth = '2001-05-20';
show index from students;
create tablespace `data_tbs` add datafile 'data1.ibd';
create table tabl1 (
id int primary key auto_increment,
name varchar(50)
) tablespace data_tbs;
