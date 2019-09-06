USE DeptEmp
GO
CREATE TABLE Department(
    DepartmentNo INT NOT NULL PRIMARY KEY,
    DepartmentName VARCHAR(25) NOT NULL,
    LOCATION VARCHAR(25) NOT NULL
)
GO
CREATE TABLE Employee(
    EmpNo INT NOT NULL PRIMARY KEY,
    FName VARCHAR(15) NOT NULL,
    LName VARCHAR(15) NOT NULL,
    Job VARCHAR(25) NOT NULL,
    HireDate DATETIME NOT NULL,
    Salary NUMERIC NOT NULL,
    Commission NUMERIC,
    DepartmentNo INT,
    CONSTRAINT FK_DepartmentNo FOREIGN KEY(DepartmentNo) REFERENCES Department(DepartmentNo)
)