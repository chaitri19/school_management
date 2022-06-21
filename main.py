import psycopg2
from config import config
from datetime import datetime

def connect():
    connection=None
    try:
        params=config()
        print("Connecting to PostgreSQL Database")
        connection = psycopg2.connect(**params)

        crsr=connection.cursor()

        setSearchPath(crsr)

        print("Inserting a new record to student table")
        insert_student(crsr)

        print("Updating a fees paid by student in student table ")
        update_studentfees(crsr)

        print("Deleting a record of student")
        delete_student(crsr);

        print("Executing percentage function")
        percent(crsr)

        print("Students with minimum marks in maximum subjects are:")
        query(crsr)
        connection.commit()
        crsr.close()
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)
    finally:
        if connection is not None:
            connection.close()
            print("Database Connection terminated")

def setSearchPath(c):
    try:
        sql_select = """SET search_path TO school_management"""
        c.execute(sql_select)
        print("Changed Search Path successfully")
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)

def insert_student(c):
    try:
        sql_select="""INSERT INTO school_management.student VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        x = input('Enter the student id of new student:')
        a1 = int(x)
        x = input('Enter the first name of new student:')
        a2 = x
        x = input('Enter the last name of new student:')
        a3 = x
        x = input('Enter the Date of Birth of new student:')
        a4 = x
        x = input('Enter residential address of new student:')
        a5 = x
        x = input('Enter contact number of new student:')
        a6 = int(x)
        x = input('Enter year of admission of new student:')
        a7 = int(x)
        x = input('Enter class id of new student:')
        a8 = x
        x = input('Enter total fees to be paid by new student:')
        a9 = int(x)
        x = input('Enter fees paid by new student till now:')
        a10 = int(x)
        t1=(a1,a2, a3, a4, a5, a6, a7, a8, a9, a10)
        c.execute(sql_select,t1)
        print("Record inserted successfully")
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)

def update_studentfees(c):
    try:
        sql_select="""UPDATE school_management.student SET feespaid = %s WHERE student_id = %s"""
        t1=(2000,202101100019)
        c.execute(sql_select,t1)
        print("Record updated successfully")
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)

def delete_student(c):
    try:
        sql_select="""DELETE from school_management.student WHERE student_id = %s"""
        x = input('Enter the student id whose record is to be removed:')
        #t1= 202101100019
        t1=int(x)
        c.execute(sql_select , (t1,))
        print("Record deleted successfully")
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)

def percent(c):
    try:
        #sid=202101100002
        x = input('Enter the student id whose percentage is to be calculated:')
        sid = int(x)
        c.callproc('percentage', [sid, ])
        per=c.fetchall()
        print("Percentage of student with id=",sid ," is:" ,per[0][0])
    except(Exception, psycopg2.DatabaseError) as err:
        print(err)

def query(c):
    try:
        sql = "SELECT fname,lname,student_id FROM school_management.student NATURAL JOIN (SELECT * FROM (SELECT student_id,COUNT(*) FROM (SELECT * FROM school_management.student_mark_comparison where (mark_scored=min )) as R5 GROUP BY student_id) as R4 JOIN (SELECT MAX(count) FROM (SELECT student_id,COUNT(*) FROM (SELECT * FROM school_management.student_mark_comparison where (mark_scored=min )) as R GROUP BY student_id) as R1)as R2 ON (R2.max=R4.count)) as R6 "
        c.execute(sql)
        rs = c.fetchall()
        for r in rs:
            print(r[0]," ",r[1]," ",r[2])

    except(Exception, psycopg2.DatabaseError) as err:
        print(err)


connect()