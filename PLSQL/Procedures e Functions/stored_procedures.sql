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

