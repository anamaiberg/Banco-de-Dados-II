-- Parte I

--1
CREATE OR REPLACE FUNCTION converter_para_celsius (fahrenheit IN NUMBER) RETURN NUMBER 
IS
 celsius NUMBER(4,1);
BEGIN
 celsius := (fahrenheit - 32) / 1.8;
 RETURN celsius;
END converter_para_celsius;

SELECT converter_para_celsius(86) FROM dual;

--2
create table funcionarios as select * from hr.employees;
create table departamentos as select * from hr.departments;

CREATE OR REPLACE FUNCTION obtem_nome_e_dept(nr_matricula IN NUMBER) RETURN VARCHAR2
IS
  empFirstName funcionarios.first_name%TYPE;
  empLastName funcionarios.last_name%TYPE;
deptName departamentos.department_name%TYPE;
BEGIN
  SELECT first_name, last_name, department_name INTO empFirstName, empLastName, deptName
  FROM funcionarios JOIN departamentos
	ON funcionarios.DEPARTMENT_ID = departamentos.DEPARTMENT_ID
  WHERE funcionarios.EMPLOYEE_ID = nr_matricula;
  RETURN (empFirstName || ' ' || empLastName || ' - ' || deptName);
END obtem_nome_e_dept;

SELECT obtem_nome_e_dept(100) FROM dual;


-- Parte II

--1
CREATE OR REPLACE FUNCTION obtem_nome(empId IN NUMBER) RETURN VARCHAR2
IS
  empFirstName HR.EMPLOYEES.first_name%TYPE;
  empLastName HR.EMPLOYEES.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO empFirstName, empLastName
  FROM HR.EMPLOYEES
  WHERE EMPLOYEE_ID = empID;
  RETURN (empFirstName || ' ' || empLastName);
END obtem_nome;

SELECT obtem_nome(110) FROM dual;

--2
CREATE OR REPLACE FUNCTION obtem_salario(empId IN NUMBER) RETURN NUMBER
IS
  empSalary HR.EMPLOYEES.salary%TYPE;
BEGIN
  SELECT salary INTO empSalary
  FROM HR.EMPLOYEES
  WHERE EMPLOYEE_ID = empID;
  RETURN (empSalary);
END obtem_salario;

SELECT obtem_salario(110) FROM dual;

--3
CREATE OR REPLACE FUNCTION obtem_nome2(DeptId IN NUMBER) RETURN VARCHAR2
IS
  empFirstName HR.EMPLOYEES.first_name%TYPE;
  empLastName HR.EMPLOYEES.last_name%TYPE;
	deptName HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
  SELECT first_name, last_name, department_name INTO empFirstName, empLastName, deptName
  FROM HR.EMPLOYEES JOIN HR.DEPARTMENTS
	ON HR.EMPLOYEES.DEPARTMENT_ID = HR.DEPARTMENTS.DEPARTMENT_ID
  WHERE DEPARTMENTS.DEPARTMENT_ID = DeptId;
  RETURN (empFirstName || ' ' || empLastName || ' - ' || deptName);
END obtem_nome2;

SELECT obtem_nome2(10) FROM dual;

--4
CREATE OR REPLACE FUNCTION obtem_soma_salarios RETURN NUMBER
IS
  totalSalary NUMBER;
BEGIN
  SELECT SUM(salary)
  INTO totalSalary
  FROM HR.EMPLOYEES;

  RETURN totalSalary;
END obtem_soma_salarios;

SELECT obtem_soma_salarios() FROM dual;

--5
CREATE OR REPLACE FUNCTION obtem_aumento_salarios(deptID NUMBER) RETURN NUMBER
IS
  totalSalary NUMBER;
BEGIN
  SELECT SUM(salary) * 1.10
  INTO totalSalary
  FROM HR.EMPLOYEES JOIN HR.DEPARTMENTS
	ON HR.EMPLOYEES.DEPARTMENT_ID = HR.DEPARTMENTS.DEPARTMENT_ID
  WHERE DEPARTMENTS.DEPARTMENT_ID = deptId;
  RETURN totalSalary;
END obtem_aumento_salarios;

SELECT obtem_aumento_salarios(20) FROM dual;

--6