--BLOCOS ANONIMOS
--2
DECLARE
    v_numero NUMBER;
BEGIN
    SELECT DBMS_RANDOM.NORMAL INTO v_numero FROM DUAL;
    
    IF v_numero = 0 THEN
        DBMS_OUTPUT.PUT_LINE('O número é igual a zero.');
    ELSIF v_numero > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O número é maior que zero.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O número é menor que zero.');
    END IF;
END;

--3
DECLARE
    v_total_aumento NUMBER;
BEGIN
    SELECT SUM(salary) * 0.09
    INTO v_total_aumento
    FROM hr.employees;
    
    DBMS_OUTPUT.PUT_LINE('Valor total do aumento mensal: ' || ROUND(v_total_aumento, 2));
END;

--FUNCTIONS 
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
CREATE OR REPLACE FUNCTION listar_funcionarios RETURN CLOB
IS
    CURSOR c_func IS
        SELECT f.first_name || ' ' || f.last_name AS nome_funcionario,
               TO_CHAR(f.hire_date, 'DD/MM/YYYY') AS hire_date,
               f.phone_number, f.email,
               NVL(m.first_name || ' ' || m.last_name, 'Sem gerente') AS nome_gerente,
               NVL(d.department_name, 'Sem departamento') AS departamento,
               f.salary, NVL(f.commission_pct, 0) AS comissao
        FROM HR.employees f
        LEFT JOIN HR.employees m ON f.manager_id = m.employee_id
        LEFT JOIN HR.departments d ON f.department_id = d.department_id;

    v_resultado CLOB := '';
BEGIN
    FOR rec IN c_func LOOP
        v_resultado := v_resultado || 'Funcionário: ' || rec.nome_funcionario || CHR(10) ||
            'Data de Contratação: ' || rec.hire_date || CHR(10) ||
            'Telefone: ' || rec.phone_number || CHR(10) ||
            'Email: ' || rec.email || CHR(10) ||
            'Gerente: ' || rec.nome_gerente || CHR(10) ||
            'Departamento: ' || rec.departamento || CHR(10) ||
            'Salário: ' || TO_CHAR(rec.salary, 'FM999G999D00') || CHR(10) ||
            'Comissão: ' || TO_CHAR(rec.comissao, 'FM999G990D00') || CHR(10) ||
            '---------------------------' || CHR(10);
    END LOOP;

    RETURN v_resultado;
END;

SELECT listar_funcionarios() FROM dual;


--PROCEDURES
--1
CREATE OR REPLACE PROCEDURE retorna_nome(p_cod IN Pessoa.id%TYPE, p_nome OUT Pessoa.nome%TYPE) AS
BEGIN
   SELECT nome 
	INTO p_nome
    FROM Pessoa
    WHERE id = p_cod;

	EXCEPTION
        WHEN NO_DATA_FOUND THEN
        p_nome := 'Pessoa não encontrada :(';
END;

DECLARE
   p_nome Pessoa.nome%TYPE;
BEGIN
   retorna_nome(1, p_nome);
   DBMS_OUTPUT.PUT_LINE('Nome retornado: ' || p_nome);
END;

--2
CREATE OR REPLACE PROCEDURE tabuada(p_num IN NUMBER) AS
BEGIN
   FOR i IN 1..10 LOOP
      DBMS_OUTPUT.PUT_LINE(p_num || ' x ' || i || ' = ' || (p_num * i));
   END LOOP;
END;

BEGIN
   tabuada(2);  
END;

--3
CREATE OR REPLACE PROCEDURE e_bissexto AS
BEGIN
   DBMS_OUTPUT.PUT_LINE('Os seguintes anos são bissextos:');
 FOR p_ano IN 2000..2100 LOOP
   IF (MOD(p_ano,4) = 0 AND MOD(p_ano,100) != 0) OR (MOD(p_ano,400) = 0) THEN
     DBMS_OUTPUT.PUT_LINE(p_ano);
   END IF;
 END LOOP;
END;

EXEC e_bissexto()

--4
CREATE OR REPLACE PROCEDURE CALCULA_MEDIA (NR_MATRICULA NUMBER, NOME VARCHAR2, A1 NUMBER, A2 NUMBER, A3 NUMBER, A4 NUMBER) 
IS
 V_MAIOR NUMBER(3,1);
 V_MEDIA NUMBER(3,1);
 V_RESULTADO VARCHAR2(15);
BEGIN
 IF A1 > A2 THEN V_MAIOR := A1;
 ELSE V_MAIOR := A2;
 END IF;
 
 V_MEDIA := (V_MAIOR + A3 + A4)/3;

 IF V_MEDIA < 6 THEN V_RESULTADO := 'REPROVADO';
 ELSE V_RESULTADO := 'APROVADO';
 END IF;
 
 INSERT INTO ALUNO VALUES (NR_MATRICULA,NOME,A1,A2,A3,A4,V_MEDIA,V_RESULTADO);
END CALCULA_MEDIA;

BEGIN
   CALCULA_MEDIA (123, 'Ana', 9 , 10, 8, 6);  
END;

select*from aluno

--5
CREATE OR REPLACE PROCEDURE CALCULA_BONUS (P_ANO LUCRO.ANO%TYPE, P_MAT SALARIO.MATRICULA%TYPE) 
IS
 V_VL_LUCRO LUCRO.VALOR%TYPE;
V_VL_SALARIO SALARIO.SALARIO%TYPE;
 V_BONUS NUMBER(7,2);
BEGIN
 SELECT VALOR INTO V_VL_LUCRO FROM LUCRO
 WHERE ANO = P_ANO;
 
SELECT SALARIO INTO V_VL_SALARIO FROM SALARIO
WHERE MATRICULA = P_MAT;

 V_BONUS := V_VL_LUCRO * 0.01 + V_VL_SALARIO * 0.05;

 DBMS_OUTPUT.PUT_LINE ('Valor do Bonus: ' || V_BONUS);
END;

EXEC CALCULA_BONUS (2020,1001);


--STORED PROCEDURES
create table customers as 
select * from SH.customers WHERE ROWNUM = 200;

create table produtos as
select * from SH.products;

create table countries as
select * from SH.countries;

--1
CREATE OR REPLACE PROCEDURE ADD_CUSTOMER (
    p_first_name        CUSTOMERS.CUST_FIRST_NAME%TYPE,
    p_last_name         CUSTOMERS.CUST_LAST_NAME%TYPE,
    p_email             CUSTOMERS.CUST_EMAIL%TYPE,
    p_gender            CUSTOMERS.CUST_GENDER%TYPE,
    p_address           CUSTOMERS.CUST_STREET_ADDRESS%TYPE,
    p_postal_code       CUSTOMERS.CUST_POSTAL_CODE%TYPE,
    p_city              CUSTOMERS.CUST_CITY%TYPE,
    p_city_id           CUSTOMERS.CUST_CITY_ID%TYPE,
    p_state_province    CUSTOMERS.CUST_STATE_PROVINCE%TYPE,
    p_country_id        CUSTOMERS.COUNTRY_ID%TYPE
) IS
BEGIN
    INSERT INTO CUSTOMERS (CUST_FIRST_NAME, CUST_LAST_NAME, CUST_EMAIL, CUST_GENDER, CUST_STREET_ADDRESS, CUST_POSTAL_CODE, CUST_CITY, CUST_CITY_ID, CUST_STATE_PROVINCE, COUNTRY_ID) 
    VALUES (p_first_name, p_last_name, p_email, p_gender, p_address, p_postal_code, p_city, p_city_id, p_state_province, p_country_id);    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

--2
CREATE OR REPLACE PROCEDURE UPDATE_PRODUCT_STATUS (p_prod_id produtos.PROD_ID%TYPE, p_new_status produtos.PROD_STATUS%TYPE) IS
BEGIN
    UPDATE produtos
    SET PROD_STATUS = p_new_status
    WHERE PROD_ID = p_prod_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Produto não encontrado.');
    END IF;
    COMMIT;
END;

--3
CREATE OR REPLACE FUNCTION GET_CUSTOMER_NAME (p_customer_id CUSTOMERS.CUST_ID%TYPE) RETURN VARCHAR2
IS
    v_first_name  CUSTOMERS.CUST_FIRST_NAME%TYPE;
    v_last_name   CUSTOMERS.CUST_LAST_NAME%TYPE;
BEGIN
    SELECT CUST_FIRST_NAME, CUST_LAST_NAME
    INTO v_first_name, v_last_name
    FROM CUSTOMERS
    WHERE CUST_ID = p_customer_id;

    RETURN v_first_name || ' ' || v_last_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Cliente não encontrado';
END;

--4
CREATE OR REPLACE PROCEDURE GET_CUSTOMER_PER_COUNTRY (p_country_id CUSTOMERS.COUNTRY_ID%TYPE, p_result OUT CLOB) IS
    CURSOR c_customers IS
        SELECT CUST_FIRST_NAME, CUST_LAST_NAME, CUST_EMAIL, CUST_GENDER, CUST_STREET_ADDRESS, CUST_POSTAL_CODE, CUST_CITY, CUST_CITY_ID, CUST_STATE_PROVINCE
        FROM CUSTOMERS
        WHERE COUNTRY_ID = p_country_id;

    v_linha VARCHAR2(1000);
BEGIN
    p_result := EMPTY_CLOB();

    FOR rec IN c_customers LOOP
        v_linha := rec.CUST_FIRST_NAME || ' ' || rec.CUST_LAST_NAME || ', ' || rec.CUST_EMAIL || ', ' || rec.CUST_GENDER || ', ' ||
                   rec.CUST_STREET_ADDRESS || ', ' || rec.CUST_POSTAL_CODE || ', ' || rec.CUST_CITY || ' (' || rec.CUST_CITY_ID || '), ' ||
                   rec.CUST_STATE_PROVINCE;

        p_result := p_result || v_linha || CHR(10);
    END LOOP;
END;

--5
CREATE OR REPLACE PROCEDURE SALES_REPORT (p_start_date IN  DATE, p_end_date IN  DATE, p_result OUT CLOB) IS
    CURSOR c_sales IS
        SELECT C.CUST_FIRST_NAME, C.CUST_LAST_NAME, SUM(S.AMOUNT_SOLD) AS total_spent
        FROM SH.CUSTOMERS C JOIN SH.SALES S 
    	ON C.CUST_ID = S.CUST_ID
        WHERE S.TIME_ID BETWEEN p_start_date AND p_end_date
        GROUP BY C.CUST_FIRST_NAME, C.CUST_LAST_NAME;

    v_linha VARCHAR2(1000);
BEGIN
    p_result := EMPTY_CLOB();

    FOR rec IN c_sales LOOP
        v_linha := rec.CUST_FIRST_NAME || ' ' || rec.CUST_LAST_NAME || ' - R$ ' || TO_CHAR(rec.total_spent, 'FM999G999G990D00');

        p_result := p_result || v_linha || CHR(10);
    END LOOP;
END;


--PACKAGES
-- 4
CREATE OR REPLACE PACKAGE RH AS
    
  FUNCTION a(empId IN NUMBER) RETURN VARCHAR2;
  
  FUNCTION b(empId IN NUMBER) RETURN NUMBER;

 PROCEDURE c(DeptId IN NUMBER, result OUT VARCHAR2);

  FUNCTION d RETURN NUMBER;

  PROCEDURE e(deptID IN NUMBER, totalSalary OUT NUMBER);

  PROCEDURE f(v_resultado OUT CLOB);

END RH;


CREATE OR REPLACE PACKAGE BODY RH AS
    
  FUNCTION a(empId IN NUMBER) RETURN VARCHAR2
    IS
      empFirstName HR.EMPLOYEES.first_name%TYPE;
      empLastName HR.EMPLOYEES.last_name%TYPE;
    BEGIN
      SELECT first_name, last_name INTO empFirstName, empLastName
      FROM HR.EMPLOYEES
      WHERE EMPLOYEE_ID = empID;
      RETURN (empFirstName || ' ' || empLastName);
    END;

	FUNCTION b(empId IN NUMBER) RETURN NUMBER
        IS
          empSalary HR.EMPLOYEES.salary%TYPE;
        BEGIN
          SELECT salary INTO empSalary
          FROM HR.EMPLOYEES
          WHERE EMPLOYEE_ID = empID;
          RETURN (empSalary);
        END;

	PROCEDURE c(DeptId IN NUMBER, result OUT VARCHAR2) IS
      empFirstName HR.EMPLOYEES.first_name%TYPE;
      empLastName HR.EMPLOYEES.last_name%TYPE;
      deptName HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    BEGIN
      SELECT first_name, last_name, department_name
      INTO empFirstName, empLastName, deptName
      FROM HR.EMPLOYEES
      JOIN HR.DEPARTMENTS
        ON HR.EMPLOYEES.DEPARTMENT_ID = HR.DEPARTMENTS.DEPARTMENT_ID
      WHERE HR.DEPARTMENTS.DEPARTMENT_ID = DeptId
        AND ROWNUM = 1;
    
      result := empFirstName || ' ' || empLastName || ' - ' || deptName;
    END;

	FUNCTION d RETURN NUMBER
        IS
          totalSalary NUMBER;
        BEGIN
          SELECT SUM(salary)
          INTO totalSalary
          FROM HR.EMPLOYEES;
        
          RETURN totalSalary;
        END;

    PROCEDURE e(deptID IN NUMBER, totalSalary OUT NUMBER) IS
    BEGIN
      SELECT SUM(salary) * 1.10
      INTO totalSalary
      FROM HR.EMPLOYEES JOIN HR.DEPARTMENTS
    	ON HR.EMPLOYEES.DEPARTMENT_ID = HR.DEPARTMENTS.DEPARTMENT_ID
      WHERE DEPARTMENTS.DEPARTMENT_ID = deptId;
    END;

    PROCEDURE f(v_resultado OUT CLOB) IS
        CURSOR c_func IS
            SELECT f.first_name || ' ' || f.last_name AS nome_funcionario,
                   TO_CHAR(f.hire_date, 'DD/MM/YYYY') AS hire_date,
                   f.phone_number, f.email,
                   NVL(m.first_name || ' ' || m.last_name, 'Sem gerente') AS nome_gerente,
                   NVL(d.department_name, 'Sem departamento') AS departamento,
                   f.salary, NVL(f.commission_pct, 0) AS comissao
            FROM HR.employees f
            LEFT JOIN HR.employees m ON f.manager_id = m.employee_id
            LEFT JOIN HR.departments d ON f.department_id = d.department_id;
    BEGIN
        v_resultado := EMPTY_CLOB();
        FOR rec IN c_func LOOP
            v_resultado := v_resultado || 'Funcionário: ' || rec.nome_funcionario || CHR(10) ||
                'Data de Contratação: ' || rec.hire_date || CHR(10) ||
                'Telefone: ' || rec.phone_number || CHR(10) ||
                'Email: ' || rec.email || CHR(10) ||
                'Gerente: ' || rec.nome_gerente || CHR(10) ||
                'Departamento: ' || rec.departamento || CHR(10) ||
                'Salário: ' || TO_CHAR(rec.salary, 'FM999G999D00') || CHR(10) ||
                'Comissão: ' || TO_CHAR(rec.comissao, 'FM999G990D00') || CHR(10) ||
                '---------------------------' || CHR(10);
        END LOOP;
    
        RETURN;
    END;
 
END RH;
