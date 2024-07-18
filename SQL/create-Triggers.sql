-- Triggers -------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER //

-- Atualizar a quantidade em stock de um ingrediente após um pedido
DELIMITER //

CREATE TRIGGER AtualizarQuantidadeEmStock
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE IngredienteID INT;
    DECLARE QuantidadePorPrato INT;
    
    DECLARE cur CURSOR FOR 
        SELECT PI.IngredienteID, PI.QuantidadePorPrato
        FROM PratoIngredientes PI
        WHERE PI.PratoID = NEW.PratoID;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO IngredienteID, QuantidadePorPrato;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE Ingredientes
        SET QuantidadeEmStock = QuantidadeEmStock - (QuantidadePorPrato * NEW.Quantidade)
        WHERE ID = IngredienteID;
    END LOOP;
    
    CLOSE cur;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER ImpedirPedidoSemEstoque
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE QuantidadeDisponivel INT;
    DECLARE IngredienteID INT;
    DECLARE QuantidadeNecessaria INT;
    DECLARE done INT DEFAULT 0;

    -- Cursor para percorrer todos os ingredientes necessários para o prato
    DECLARE cursor_ingredientes CURSOR FOR
        SELECT IngredienteID, QuantidadePorPrato
        FROM PratoIngredientes
        WHERE PratoID = NEW.PratoID;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cursor_ingredientes;

    read_loop: LOOP
        FETCH cursor_ingredientes INTO IngredienteID, QuantidadeNecessaria;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Verificar se há quantidade suficiente de cada ingrediente
        SELECT QuantidadeEmStock INTO QuantidadeDisponivel
        FROM Ingredientes
        WHERE ID = IngredienteID;

        IF QuantidadeDisponivel < QuantidadeNecessaria * NEW.Quantidade THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade insuficiente em estoque';
        END IF;
    END LOOP;

    CLOSE cursor_ingredientes;

    -- Verificar se o estoque final será negativo após a inserção do pedido
    IF EXISTS (
        SELECT 1
        FROM PratoIngredientes PI
        JOIN Ingredientes I ON PI.IngredienteID = I.ID
        WHERE PI.PratoID = NEW.PratoID AND I.QuantidadeEmStock - (PI.QuantidadePorPrato * NEW.Quantidade) < 0
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente para atender ao pedido';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER prevent_empty_strings_pratos_before_insert
BEFORE INSERT ON Pratos
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome não pode ser vazio';
    END IF;
    IF NEW.Descricao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Descricao não pode ser vazia';
    END IF;
    IF NEW.Categoria = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Categoria não pode ser vazia';
    END IF;
END //

DELIMITER //

CREATE TRIGGER prevent_empty_strings_pratos_before_update
BEFORE UPDATE ON Pratos
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome não pode ser vazio';
    END IF;
    IF NEW.Descricao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Descricao não pode ser vazia';
    END IF;
    IF NEW.Categoria = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Categoria não pode ser vazia';
    END IF;
END //

DELIMITER ;

-- Verificação para evitar campos de strings vazias na tabela Empregados
DELIMITER //
CREATE TRIGGER prevent_empty_strings_empregados_before_insert
BEFORE INSERT ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome não pode ser vazio';
    END IF;
    IF NEW.Posicao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Posicao não pode ser vazia';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_empregados_before_update
BEFORE UPDATE ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome não pode ser vazio';
    END IF;
    IF NEW.Posicao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Posicao não pode ser vazia';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER AtualizarPrecoTotal
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE preco_unitario DECIMAL(10, 2);
    SELECT Preco INTO preco_unitario FROM Pratos WHERE ID = NEW.PratoID;
    SET NEW.Preco = preco_unitario * NEW.Quantidade;
END //

DELIMITER ;
