-- Student List
CREATE VIEW StudentList AS
SELECT
	Student_ID AS 'StudentID',
    Student_FirstName AS 'First Name',
	Student_LastName AS 'Last Name',
	Grade
FROM Student_Info
ORDER BY
	Grade,
	Student_LastName,
	Student_FirstName;
    
SELECT * FROM StudentList;
    
-- Students and Meal Status
CREATE VIEW StudentMealStatus AS
SELECT
	s.Student_ID AS 'Student ID',
    s.Student_FirstName AS 'First Name',
	s.Student_LastName AS 'Last Name',
	ms.Meal_Status AS 'Meal Status'
FROM Student_Info s
JOIN Meal_Status ms
ON s.MealStatus_ID = ms.MealStatus_ID
ORDER BY
	ms.Meal_Status,
	s.Student_LastName,
	s.Student_FirstName;

SELECT * FROM StudentMealStatus;

-- Daily Transaction
DELIMITER $$
CREATE PROCEDURE DailyTransactions
(Transaction_Date Date)
BEGIN
SELECT
	COUNT(t.Transaction_ID) AS 'Number of Meals',
	COUNT(t.Transaction_ID) * 3 AS 'Total Meal Cost'
FROM Transactions t
WHERE t.Transaction_Date = Transaction_Date;
END$$
DELIMITER ;


CALL DailyTransactions('2019-11-14');

-- Total Free Meals
DELIMITER $$
CREATE PROCEDURE ReimbursementFree
(Transaction_Date Date)
BEGIN
SELECT
	ms.Meal_Status AS 'Meal Status',
	COUNT(t.Transaction_ID) AS 'Number of Meals',
	COUNT(t.Transaction_ID) * 3 AS 'Cost'
FROM Transactions t
JOIN Student_Info s
JOIN Meal_Status ms
ON t.Student_ID = s.Student_ID
AND s.MealStatus_ID = ms.MealStatus_ID
WHERE t.Transaction_Date = Transaction_Date
AND ms.Meal_Status = 'Free';
END$$
DELIMITER ;

CALL ReimbursementFree('2019-11-15');

-- Total Reduced Meals
DELIMITER $$
CREATE PROCEDURE ReimbursementReduced
(Transaction_Date Date)
BEGIN
SELECT
	ms.Meal_Status AS 'Meal Status',
	COUNT(t.Transaction_ID) AS 'Number of Meals',
	(COUNT(t.Transaction_ID) * 2.6) AS 'Cost'
FROM Transactions t
JOIN Student_Info s
JOIN Meal_Status ms
ON t.Student_ID = s.Student_ID
AND s.MealStatus_ID = ms.MealStatus_ID
WHERE t.Transaction_Date = Transaction_Date
AND ms.Meal_Status = 'Reduced';
END$$
DELIMITER ;

CALL ReimbursementReduced('2019-11-15');

-- Payment By Students
CREATE VIEW StudentPayments AS
SELECT
	Payment_ID AS 'Payment ID',
	Student_ID AS 'Student ID',
	Amount,
	Payment_Date AS 'Payment Date',
	Payment_Method AS 'Payment Method'
FROM Payments
ORDER BY Student_ID, Payment_Date;

SELECT * FROM StudentPayments;

-- Student Charges
CREATE VIEW StudentCharges AS
SELECT 
	t.Student_ID AS 'StudentID',
	s.Student_FirstName AS 'First Name',
	s.Student_LastName AS 'Last Name',
	ms.Meal_Status AS 'Meal Status',
	ms.Meal_Amount * COUNT(t.Transaction_ID) AS 'Charges'
FROM Transactions t
JOIN Student_Info s
JOIN Meal_Status ms
ON t.Student_ID = s.Student_ID
AND s.MealStatus_ID = ms.MealStatus_ID
GROUP BY t.Student_ID;

SELECT * FROM StudentCharges;

-- Student Balances
CREATE VIEW StudentBalances AS
SELECT
	s.Student_ID AS 'Student ID',
    s.Student_FirstName AS 'First Name',
	s.Student_LastName AS 'Last Name',
	sc.Charges AS 'Amount Charged',
	p.Amount AS 'Amount Paid',
	(sc.Charges)-(p.Amount) AS 'Balance'
FROM Student_Info s
JOIN StudentCharges sc
LEFT JOIN Payments p
ON s.Student_ID = sc.StudentID
AND sc.StudentID = p.Student_ID
GROUP BY s.Student_ID;

SELECT * FROM StudentBalances;