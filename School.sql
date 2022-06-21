CREATE SCHEMA SCHOOL_MANAGEMENT;
SET SEARCH_PATH TO SCHOOL_MANAGEMENT;

CREATE TABLE school(
	School_ID INTEGER,
	School_Name	VARCHAR(50)	NOT NULL,
	City VARCHAR(20) NOT NULL,
	Address VARCHAR(150) NOT NULL,
	PRIMARY KEY(School_ID)
);

CREATE TABLE class1(
	Class_ID VARCHAR(9),
	Building_ID INTEGER	NOT NULL,
	Room_ID INTEGER	NOT NULL,
	Standard INTEGER	NOT NULL,
	Sections VARCHAR(1)	NOT NULL,
	School_ID INTEGER,
	FOREIGN KEY (School_ID) REFERENCES school(School_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (Class_ID),
	UNIQUE(School_ID,Building_ID,Room_ID)
);

CREATE TABLE student(
	Student_ID DECIMAL(12,0),
	Fname VARCHAR(20)	NOT NULL,
	Lname VARCHAR(20)	NOT NULL,
	DOB DATE	NOT NULL,
	Address VARCHAR(150),
	ContactNo DECIMAL(10,0),
	Year_Of_Joining INTEGER,
	Class_ID VARCHAR(9),
	TotalFees numeric(6,0),
	FeesPaid  numeric(6,0),
	PRIMARY KEY (Student_ID),
	FOREIGN KEY (Class_ID) REFERENCES class1(Class_ID)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE parent(
	Pan_No VARCHAR(10),
	Fname	VARCHAR(20) NOT NULL,
	Lname	VARCHAR(20) NOT NULL,
	Address	VARCHAR(30) NOT NULL,
	PRIMARY KEY (Pan_No)
);

CREATE TABLE relation(
	Parent VARCHAR(10),
	Student DECIMAL(12,0),
	FOREIGN KEY (Parent) REFERENCES parent(Pan_No)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (Student) REFERENCES student(Student_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY(Parent,Student)
);

CREATE TABLE parent_contact(
	Parent_ID VARCHAR(10),
	Contact_No numeric(10,0)	NOT NULL,
	FOREIGN KEY (Parent_ID) REFERENCES parent(Pan_No)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY(Parent_ID,Contact_No)
);

CREATE TABLE subject(
	Subject_ID VARCHAR(4),
	Sub_Name VARCHAR(20) NOT NULL,
	PRIMARY KEY(Subject_ID)
);

CREATE TABLE subject_class(
	Subject_ID VARCHAR(4),
	Class_ID VARCHAR(9),
	FOREIGN KEY(Subject_ID) REFERENCES subject(Subject_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(Class_ID) REFERENCES class1(Class_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY(Subject_ID,Class_ID)
);

CREATE TABLE examination(
	Exam_ID	VARCHAR(10),
	Subject_ID VARCHAR(4),
    Date_Exam DATE NOT NULL,
	FOREIGN KEY(Subject_ID) REFERENCES subject(Subject_ID)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Exam_ID)
);

CREATE TABLE result_exam(
	Exam_ID	VARCHAR(10),
	Student_ID	DECIMAL(12,0),
	Total_Marks	INTEGER NOT NULL,
	Mark_Scored	INTEGER CHECK(Mark_Scored>=0 AND Mark_Scored<=Total_Marks),
	FOREIGN KEY(Exam_ID) REFERENCES examination(Exam_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Student_ID) REFERENCES student(Student_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY(Exam_ID,Student_ID)
);

CREATE TABLE employee(
	PAN_No VARCHAR(10),
	Fname	VARCHAR(20) NOT NULL,
	Lname 	VARCHAR(20) NOT NULL,
	Designation	VARCHAR(50) NOT NULL,
	Address	VARCHAR(150) NOT NULL,
	Contact_No	numeric(10,0) NOT NULL,
	Salary	INTEGER NOT NULL,
	DOB	DATE NOT NULL,
	Gender	CHAR(1) CHECK (Gender in ('M','F','O')),
	School_ID	INTEGER,
	Incharge_ID	DECIMAL(4,0),
	UNIQUE(Incharge_ID),
	Teacher_ID	DECIMAL(5,0),
	Qualification	VARCHAR(30),
	Experience	INTEGER,
	UNIQUE(Teacher_ID)
	FOREIGN KEY (School_ID) REFERENCES school(School_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (PAN_No)
);

CREATE TABLE teaches(
	Teacher_ID	DECIMAL(5,0),
	Class_ID	VARCHAR(9),
	Subject_ID	VARCHAR(4),
	FOREIGN KEY(Subject_ID) REFERENCES subject(Subject_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Class_ID) REFERENCES class1(Class_ID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(Teacher_ID) REFERENCES Employee(Teacher_ID)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Teacher_ID,Class_ID,Subject_ID)
);

CREATE TABLE library1(
	Library_ID	DECIMAL(4,0),
	School_ID	INTEGER NOT NULL,
	Incharge_ID	Decimal(4,0) NOT NULL,
	FOREIGN KEY (School_ID) REFERENCES school(School_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (Incharge_ID) REFERENCES Employee(Incharge_ID)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Library_ID)
);

CREATE TABLE books(
	Book_Code	DECIMAL(9,0),
	Book_Description	VARCHAR(50) NOT NULL,
	Arrival_Date	DATE NOT NULL,
	Library_ID	DECIMAL(4,0) NOT NULL,
	FOREIGN KEY (Library_ID) REFERENCES library1(Library_ID)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Book_Code)
);

CREATE TABLE book_author(
	Book_Code	DECIMAL(9,0),
	Author	VARCHAR(20),
	FOREIGN KEY (Book_Code) REFERENCES books(Book_Code)
	ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(Book_Code,Author)
);

CREATE TABLE lab(
	Lab_Code	DECIMAL(4,0),
	Incharge_ID	DECIMAL(4,0),
	School_ID	INTEGER NOT NULL,
	FOREIGN KEY (School_ID) REFERENCES school(School_ID)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (Incharge_ID) REFERENCES employee(Incharge_ID)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Lab_Code)
);

CREATE TABLE instruments(
	Instrument_ID	INTEGER,
	Lab_Type	VARCHAR(10)	CHECK (Lab_Type in ('Physics','Chemistry','Computer')),
	Instrument_Name	VARCHAR(20),
	Chemical_Name	VARCHAR(20),
	Condition_Status	VARCHAR(20) NOT NULL,
	Lab_Code	DECIMAL(4,0),
	FOREIGN KEY (Lab_Code) REFERENCES lab(Lab_Code)
	ON DELETE SET NULL ON UPDATE CASCADE,
	PRIMARY KEY (Instrument_ID,Lab_Code)
)