SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM issue_status;
SELECT * FROM members;
SELECT * FROM return_status;

-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issue_status
WHERE issued_id = 'IS121';

DELETE FROM issue_status
WHERE issued_id = 'IS121';


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM issue_status
WHERE issued_emp_id = 'E101';



-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_member_id, COUNT(issued_id)
FROM issue_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1;



-- CTAS - CREAT TABLE AS SELECT
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_counts AS
	 (
	 SELECT b.isbn, b.book_title, COUNT(ist.issued_id)
	 FROM books b
	 JOIN issue_status ist ON b.isbn = ist.issued_book_isbn
	 GROUP BY b.isbn, b.book_title
	 );

SELECT * FROM book_counts;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * 
FROM books
WHERE category = "Classic";

    
-- Task 8: Find Total Rental Income by Category:

SELECT b.category, SUM(b.rental_price) total_rental
FROM books b
JOIN issue_status ist ON ist.issued_book_isbn = b.isbn
GROUP BY 1;


-- **Task 9: List Members Who Registered in the Last 180 Days:

SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days' ;


-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT e1.*,b.branch_id,e2.emp_name manager_name
FROM employee e1
JOIN branch b ON b.branch_id = e1.branch_id
JOIN employee e2 ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE book_value_more_than_7 AS
	(
	SELECT * 
	FROM books
	WHERE rental_price >= 7
	);

SELECT * FROM book_value_more_than_7;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT ist.issued_id, ist.issued_book_name, ist.issued_book_isbn
FROM return_status r
RIGHT JOIN issue_status ist ON r.issued_id = ist.issued_id
WHERE r.return_id IS NULL;

/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issue_status == members == return-status
-- i wont join the books table because the book title can be extracted from issue_Status table
-- filter the returned books
-- overdue > 30 days

SELEct * FROM members;
SELECT * FROM issue_status;
SELECT * FROM return_status;

SELECT 
	ist.issued_member_id, rst.return_id, m.member_name, ist.issued_book_name, ist.issued_date, 
	(CURRENT_DATE - ist.issued_date - 30) AS overdue_days
FROM issue_status ist
JOIN members m			
	ON ist.issued_member_id = m.member_id
LEFT JOIN return_status rst	
	ON rst.issued_id = ist.issued_id
WHERE rst.return_id IS NULL
	  AND (CURRENT_DATE - ist.issued_date) > 30;

-- 

/*    
Task 14: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM issue_status;
SELECT * FROM employee;
SELECT * FROM return_status;

SELECT b.branch_id,b.manager_id,e2.emp_name, COUNT(ist.issued_id) total_issues, COUNT(rst.return_id) total_returned, SUM(bk.rental_price) total_revenue
FROM branch b
JOIN employee e1 ON b.branch_id = e1.branch_id
JOIN issue_status ist ON e1.emp_id = ist.issued_emp_id
JOIN books bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status rst ON ist.issued_id = rst.issued_id
JOIN employee e2 ON b.manager_id = e2.emp_id
GROUP BY 1, 2, 3;

--

-- Task 15: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.


SELECT * FROM members;
SELECT * FROM issue_status;


CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issue_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    );


SELECT * FROM active_members;


-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


SELECT e.emp_name, b.branch_id, COUNT(ist.issued_id) books_issued
FROM employee e
JOIN branch b ON e.branch_id = b.branch_id
JOIN issue_status ist ON e.emp_id = ist.issued_emp_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;















