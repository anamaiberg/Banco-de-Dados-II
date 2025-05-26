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
