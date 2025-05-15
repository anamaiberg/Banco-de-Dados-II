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
