--1
CREATE OR REPLACE TRIGGER trg_historico_precos
AFTER UPDATE OF prd_valor ON produtos
FOR EACH ROW
BEGIN
    IF :old.prd_valor <> :new.prd_valor THEN
        INSERT INTO historico_precos (prd_codigo, data, prd_preco_antigo, prd_preco_novo, usuario_sistema) 
        VALUES (:OLD.prd_codigo, SYSDATE, :OLD.prd_valor, :NEW.prd_valor, USER);
    END IF;
END;

--2
CREATE OR REPLACE TRIGGER trg_produtos_excluidos
AFTER DELETE ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO historico_produtos_excluidos (prd_codigo, prd_descricao, prd_qtd, prd_preco_venda, dtDatetime, usuario) 
    VALUES (:OLD.prd_codigo, :OLD.prd_descricao, :OLD.prd_qtd_estoque, :OLD.prd_valor, SYSDATE, USER);
END;

--3
CREATE OR REPLACE TRIGGER trg_produtos_atualizados
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO produtos_atualizados (prd_codigo, prd_dt_atualizacao, prd_qtd_anterior, prd_qtd_atualizada, prd_valor, usuario) 
    VALUES (:OLD.prd_codigo, SYSDATE, :OLD.prd_qtd_estoque, :NEW.prd_qtd_estoque, :OLD.prd_valor, USER);
    IF :NEW.prd_qtd_estoque = 0 THEN
        INSERT INTO produtos_em_falta (prd_codigo, prd_dt_falta, prd_qtd_estoque, prd_falta, prd_descricao, prd_status) 
        VALUES (:OLD.prd_codigo, sysdate, :OLD.prd_qtd_estoque, :OLD.prd_falta, :OLD.prd_descricao, NULL);
        UPDATE orcamentos_produtos
        SET orp_status = NULL
        WHERE prd_codigo = :OLD.prd_codigo
    END IF;
END;
