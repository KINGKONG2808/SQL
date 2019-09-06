USE DeptEmp
GO
/*INSERT INTO Department VALUES (10, 'Accounting', 'Melbourne')
INSERT INTO Department VALUES (20, 'Research', 'Adealide')
INSERT INTO Department VALUES (30, 'Sales', 'Sydney')
INSERT INTO Department VALUES (40, 'Operations', 'Perth')*/
INSERT INTO Employee(EmpNo, FName, LName, Job, HireDate, Salary, DepartmentNo) VALUES (1, 'John', 'Smith', 'Clerk', '12-17-1980', 800, 20)
INSERT INTO Employee(EmpNo, FName, LName, Job, HireDate, Salary, commission, DepartmentNo) VALUES (2, 'Peter', 'Allen', 'Salesman', '2-20-1981', 1600, 300, 30)
INSERT INTO Employee VALUES (3, 'Kate', 'Ward', 'Salesman', '2-20-1981', 1250, 500, 30)
INSERT INTO Employee(EmpNo, FName, LName, Job, HireDate, Salary, DepartmentNo) VALUES (4, 'Jack', 'Jones', 'Manager', '4-2-1981', 2975, 20)
INSERT INTO Employee VALUES (5, 'Joe', 'Martin', 'Salesman', '9-28-1981', 1250, 1400, 30)