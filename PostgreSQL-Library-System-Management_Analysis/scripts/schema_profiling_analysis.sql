-- Library Management System

-- create branch table

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
	(
	branch_id			VARCHAR(10) PRIMARY KEY,
	manager_id			VARCHAR(10),
	branch_address		VARCHAR(55),
	contact_no			VARCHAR(10)
	);

-- create employee table

CREATE TABLE employee
	(
	emp_id				VARCHAR(10) PRIMARY KEY,
	emp_name			VARCHAR(25),
	emp_position		VARCHAR(15),
	salary				INT,
	branch_id			VARCHAR(15)
	);

-- create books table

CREATE TABLE books
	(	
	isbn				VARCHAR(20) PRIMARY KEY,
	book_title			VARCHAR(75),
	category			VARCHAR(10),
	rental_price		FLOAT,
	status				VARCHAR(15),
	author				VARCHAR(35),
	publisher			VARCHAR(50)
	);

-- create member table

CREATE TABLE members
	(
	member_id			VARCHAR(15) PRIMARY KEY,
	member_name			VARCHAR(25),
	member_address		VARCHAR(75),
	reg_date			DATE
	);

-- create issue table

CREATE TABLE issue_status
	(
	issued_id			VARCHAR(10) PRIMARY KEY,
	issued_member_id	VARCHAR(10),
	issued_book_name	VARCHAR(75),
	issued_date			DATE,
	issued_book_isbn	VARCHAR(25),
	issued_emp_id		VARCHAR(10)
	);

-- create return_status table

CREATE TABLE return_status
	(
	return_id			VARCHAR(10) PRIMARY KEY,
	issued_id			VARCHAR(10),
	return_book_name	VARCHAR(75),
	return_date			DATE,
	return_book_isbn	VARCHAR(25)
	);


-- Add Foreign key contraint to define the relationships between tables in the dataset:

ALTER TABLE issue_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issue_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issue_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employee(emp_id);


ALTER TABLE employee
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issue_status
FOREIGN KEY (issued_id)
REFERENCES issue_status(issued_id);


INSERT INTO issue_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;
SELECT * FROM issue_status;

SELECT CURRENT_DATE;


UPDATE return_status
SET return_date = return_date + INTERVAL '1 year'
WHERE EXTRACT(year FROM return_date) = 2024;

SELECT * FROM members;













	