/*--1
SELECT * FROM Department
--2
SELECT * FROM Employee
--3
SELECT EmpNo, FName, LName FROM Employee
WHERE FName = 'Kate'
--4
SELECT FName+' '+LName AS 'Fullname', Salary, Salary*0.1 AS 'Tang luong' FROM Employee
--5
SELECT FName, LName, HireDate FROM Employee
WHERE YEAR(Hiredate)='1981'
ORDER BY LName ASC
--6
SELECT AVG(salary) AS 'TB Luong', MAX(salary) AS 'Luong Cao Nhat', MIN(salary) AS 'Luong Thap Nhat' FROM Employee
GROUP BY DepartmentNo
--7
SELECT DepartmentNo, COUNT(*) AS 'So Nguoi'
FROM Employee
GROUP BY DepartmentNo
--8
SELECT Department.DepartmentNo, Department.DepartmentName,
       Employee.FName+' '+Employee.LName AS 'Fullname', Employee.Job, Employee.Salary
FROM Department INNER JOIN Employee ON Department.DepartmentNo=Employee.DepartmentNo
--9
SELECT COUNT(*) AS 'TongNguoi', Employee.DepartmentNo INTO SoNguoi FROM Employee
GROUP BY Employee.DepartmentNo
SELECT Department.DepartmentNo, Department.DepartmentName, Department.LOCATION, SoNguoi.TongNguoi
FROM Department INNER JOIN SoNguoi ON Department.DepartmentNo = SoNguoi.DepartmentNo*/