--1
--Triggers estão sempre associados a uma tabela ou a uma view E a um comando que o dispara que pode ser INSERT, UPDATE e/ou DELETE.
--Ou seja, um trigger é um objeto que é automaticamente executado quando um comando é executado na tabela associada.

--2
--As variáveis OLD e NEW nos permitem acessar os dados das colunas antes e depois das alterações executadas pelo trigger. 
--No UPDATE, ambas as variáveis podem ser utilizadas. No INSERT, apenas o NEW e, no DELETE, apenas o OLD.
--Ex: :OLD.nomecoluna e :NEW.nomecoluna

--3
--A variável OLD pode ser utilizada com o UPDATE e com o DELETE.

--4
--Triggers fornecem extensões SQL que suportam declarações de variáveis e constantes, comentários, 
--instruções declarativas, testes condicionais, desvios e laços. Funciona como uma linguagem de programação tradicional, basicamente.

--5
CREATE OR REPLACE TRIGGER trg_historico_precos
AFTER UPDATE OF prd_valor ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO historico_precos (prd_codigo, data, prd_preco_antigo, prd_preco_novo, usuario_sistema) 
    VALUES (
        :OLD.prd_codigo, SYSDATE, :OLD.prd_valor, :NEW.prd_valor, USER);
END;
