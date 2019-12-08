CREATE SCHEMA FinalProject;

USE FinalProject;

-- Meal_Status Table
CREATE TABLE Meal_Status (
	MealStatus_ID 	varchar(3) NOT NULL,
    Meal_Status 	varchar(30),
    Meal_Amount 	decimal(30,2),
    PRIMARY KEY (MealStatus_ID)
);

INSERT INTO Meal_Status
	(MealStatus_ID, Meal_Status, Meal_Amount)
VALUES
('001', 'Free', 0.00),
('002', 'Reduced', 0.40),
('003', 'Full', 3.00);

SELECT *
FROM Meal_Status;

-- Meal_Options Table
CREATE TABLE Meal_Options (
	Meal_ID 	varchar(3) NOT NULL,
    Meal_Description 	varchar(255),
    PRIMARY KEY (Meal_ID)
);

INSERT INTO Meal_Options
	(Meal_ID, Meal_Description)
VALUES
	('001', 'Chicken Nuggets, Glazed Sweet Potatoes, Chilled Mixed Fruit, Choice of Milk'),
    ('002', 'Been Nachos, Corn Kernel, Apple Slices w/ Cinnamon, Choice of Milk'),
    ('003', 'PBJ w/ Cheesestick, Fresh Mango, Fresh Cucumber w/ Dip, Choice of Milk'),
    ('004', 'Chili Beef w/ Beans, Cornbread, Chilled Pears, Choice of Milk'),
    ('005', 'Deli Sandwich w/ Lettuce & Tomato, Mini Carrots, Fresh Grapes, Choice of Milk');

SELECT *
FROM Meal_Options;

-- Parent_Info Table
CREATE TABLE Parent_Info (
	Parent_ID 	varchar(6) NOT NULL,
    Parent_FirstName 	varchar(255) NOT NULL,
    Parent_LastName  	varchar(255),
    Address 	varchar(255),
    City 	varchar(255),
    State 	varchar(2),
    ZipCode 	varchar(30),
    PhoneNumber 	varchar(255),
    Email 	varchar(255),
    PRIMARY KEY (Parent_ID)
    );

INSERT INTO Parent_Info
	(Parent_ID, Parent_FirstName, Parent_LastName, Address, City, State, ZipCode, PhoneNumber, Email)
VALUES
('000001', 'Barbara', 'Walters', '1234 S. 38th Street', 'Kansas City', 'KS', 66106, 9134069238, 'barbara.walters@hotmail.com'),
('000002', 'John', 'Doe', '2147 N. 12th Street', 'Kansas City', 'MO', 64110, 8169837432, 'john.doe@yahoo.com'),
('000003', 'Christian', 'Smith', '314 Crenshaw Ave.', 'Kansas City', 'KS', 66101, 9134722890, 'c.smith314@gmail.com'),
('000004', 'Lucy', 'Gonzalez', '1801 E. 63rd Street', 'Kansas City', 'MO', 64130, 8168932646, 'luzgonzalez_14@yahoo.com'),
('000005', 'Joe', 'Brown', '650 Minnesota Ave.', 'Kansas City', 'KS', 66101, 9132624232, 'jo.brown43@hotmail.com'),
('000006', 'Eric', 'Martinez', '2123 Ruby Ave.', 'Kansas City', 'KS', 66106, 9137849324, 'eric_martinez@gmail.com');

SELECT *
FROM Parent_Info;

-- Student_Info Table
CREATE TABLE Student_Info (
	Student_ID 	varchar(6) NOT NULL,
    Parent_ID 	varchar(6) NOT NULL,
    Student_FirstName 	varchar(255) NOT NULL,
    Student_LastName 	varchar(255),
    Grade 	int(2),
    MealStatus_ID 	varchar(3) NOT NULL,
    PRIMARY KEY (Student_ID),
    FOREIGN KEY (Parent_ID) REFERENCES Parent_Info(Parent_ID),
    FOREIGN KEY (MealStatus_ID) REFERENCES Meal_Status(MealStatus_ID)
    );

INSERT INTO Student_Info
	(Student_ID, Parent_ID, Student_FirstName, Student_LastName, Grade, MealStatus_ID)
VALUES
('000001', '000003', 'Laura', 'Smith', 11, '001'),
('000002', '000005', 'Chris', 'Brown', 9, '003'),
('000003', '000002', 'Bill', 'Doe', 10, '002'),
('000004', '000001', 'Samantha', 'Walters', 11, '001'),
('000005', '000004', 'Jesse', 'Gonzalez', 9, '002'),
('000006', '000006', 'Salvador', 'Martinez', 12, '001'),
('000007', '000003', 'Jane', 'Doe', 12, '002');

SELECT *
FROM Student_Info;

-- Transactions Table
CREATE TABLE Transactions (
	Transaction_ID 	int(7) zerofill UNSIGNED auto_increment NOT NULL,
    Student_ID 	varchar(6) NOT NULL,
    Meal_ID 	varchar(3) NOT NULL,
    Transaction_Date 	Date,
    PRIMARY KEY (Transaction_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student_Info(Student_ID),
    FOREIGN KEY (Meal_ID) REFERENCES Meal_Options(Meal_ID)
);

INSERT INTO Transactions
	(Student_ID, Meal_ID, Transaction_Date)
VALUES
('000001', '004', '2019-11-14'),
('000003', '002', '2019-11-14'),
('000004', '001', '2019-11-14'),
('000006', '003', '2019-11-14'),
('000002', '001', '2019-11-14'),
('000003', '001', '2019-11-14'),
('000001', '005', '2019-11-15'),
('000005', '004', '2019-11-15'),
('000007', '003', '2019-11-15'),
('000003', '004', '2019-11-15');

SELECT *
FROM Transactions;

-- Payments Table
CREATE TABLE Payments (
	Payment_ID 	int(7) zerofill UNSIGNED auto_increment NOT NULL,
    Parent_ID 	varchar(6) NOT NULL,
    Student_ID 	varchar(6) NOT NULL,
    Amount 	decimal(30,2),
    Payment_Date 	Date,
    Payment_Method 	varchar(255),
    Processor 	varchar(255),
    Notes 	varchar(255),
    PRIMARY KEY (Payment_ID),
    FOREIGN KEY (Parent_ID) REFERENCES Parent_Info(Parent_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student_Info(Student_ID)
);

INSERT INTO Payments
	(Parent_ID, Student_ID, Amount, Payment_Date, Payment_Method)
VALUES
('000002', '000003', 1.00, '2019-11-11', 'Cash'),
('000002', '000003', 2.50, '2019-11-14', 'Cash'),
('000004', '000005', 3.00, '2019-11-15', 'Credit'),
('000002', '000007', 5.00, '2019-11-15', 'Cash'),
('000002', '000003', 10.00, '2019-11-15', 'Credit');

SELECT *
FROM Payments;