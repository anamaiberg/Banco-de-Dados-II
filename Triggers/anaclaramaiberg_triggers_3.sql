--1
CREATE OR REPLACE TRIGGER decremento_estoque
AFTER INSERT ON ITEMPEDIDO
FOR EACH ROW
DECLARE qtd NUMBER;
BEGIN
  SELECT NVL(quantidade_estoque, 0) INTO qtd
  FROM PRODUTO
  WHERE codproduto = :NEW.codproduto;

  UPDATE PRODUTO
  SET quantidade_estoque = quantidade_estoque - :NEW.quantidade
  WHERE codproduto = :NEW.codproduto;
END;

--2
CREATE OR REPLACE TRIGGER decremento_estoque_log
BEFORE INSERT ON ITEMPEDIDO
FOR EACH ROW
DECLARE 
    qtd NUMBER;
	novo_codlog NUMBER;
BEGIN
  SELECT NVL(quantidade_estoque, 0) INTO qtd
  FROM PRODUTO
  WHERE codproduto = :NEW.codproduto;

  IF qtd <= 0 THEN
	SELECT NVL(MAX(codlog), 0) + 1 INTO novo_codlog
    FROM LOG;
      
	INSERT INTO LOG(codlog, data, descricao)
      VALUES(novo_codlog, SYSDATE, 'estoque insuficiente do produto' || :NEW.codproduto);
END IF;
END;

--3
CREATE OR REPLACE TRIGGER valor_log
BEFORE INSERT ON PEDIDO
FOR EACH ROW
DECLARE 
	novo_codlog NUMBER;
	nome_cliente CLIENTE.nome%TYPE;
    nascimento_cliente CLIENTE.datanascimento%TYPE;
    cpf_cliente CLIENTE.cpf%TYPE;
BEGIN
  IF :NEW.valortotal > 1000 THEN
	SELECT nome, datanascimento, cpf
    INTO nome_cliente, nascimento_cliente, cpf_cliente
    FROM CLIENTE
    WHERE codcliente = :NEW.codcliente;
        
	SELECT NVL(MAX(codlog), 0) + 1 INTO novo_codlog
    FROM LOG; 

	INSERT INTO LOG(codlog, data, descricao)
      VALUES(novo_codlog, SYSDATE, TO_CHAR(:NEW.valortotal, '9999.99') || nome_cliente || TO_CHAR(nascimento_cliente, 'DD/MM/YYYY') || cpf_cliente);
END IF;
END;

--4
CREATE OR REPLACE TRIGGER idade
BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
  IF :NEW.datanascimento > SYSDATE THEN
	raise_application_error(-20501, 'Não!?');
END IF;
END;

--5
CREATE OR REPLACE TRIGGER idade
BEFORE INSERT ON CLIENTE
FOR EACH ROW
DECLARE
  idade_anos NUMBER;
BEGIN
  idade_anos := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.datanascimento) / 12);

  IF idade_anos > 30 THEN
    :NEW.nome := 'Sr(a) ' || :NEW.nome;
  END IF;
END;
