-- Triggers -------------------------------------------------------------------------------------------------------------------------------------------------
DELIMITER //

-- Atualizar a quantidade em stock de um ingrediente após um pedido
CREATE TRIGGER AtualizarQuantidadeEmStock
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Ingredientes I
    JOIN PratoIngredientes PI ON I.ID = PI.IngredienteID
    SET I.QuantidadeEmStock = I.QuantidadeEmStock - (PI.QuantidadePorPrato * NEW.Quantidade)
    WHERE PI.PratoID = NEW.PratoID;
END //

-- Impedir a inserção de um pedido se não houver ingredientes suficientes
CREATE TRIGGER ImpedirPedidoSemEstoque
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE QuantidadeDisponivel INT;
    SELECT SUM(PI.QuantidadePorPrato * NEW.Quantidade) INTO QuantidadeDisponivel
    FROM PratoIngredientes PI
    WHERE PI.PratoID = NEW.PratoID;

    IF QuantidadeDisponivel IS NULL OR QuantidadeDisponivel > (SELECT QuantidadeEmStock FROM Ingredientes WHERE ID = (SELECT IngredienteID FROM PratoIngredientes WHERE PratoID = NEW.PratoID)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade insuficiente em estoque';
    END IF;
END //

DELIMITER ;



DELIMITER //
-- prevenir strings vazias antes de insert e update
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

DELIMITER ;

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

DELIMITER //
-- prevenir entrada de dados negativos antes de insert e update
CREATE TRIGGER prevent_negative_price_before_insert
BEFORE INSERT ON Pratos
FOR EACH ROW
BEGIN
    IF NEW.Preco < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço do prato não pode ser negativo';
    END IF;
END //

CREATE TRIGGER prevent_negative_price_before_update
BEFORE UPDATE ON Pratos
FOR EACH ROW
BEGIN
    IF NEW.Preco < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço do prato não pode ser negativo';
    END IF;
END //

DELIMITER ;


DELIMITER //
-- prevenir strings vazias antes de insert e update
CREATE TRIGGER prevent_empty_strings_ingredientes_before_insert
BEFORE INSERT ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do ingrediente não pode ser vazio';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_ingredientes_before_update
BEFORE UPDATE ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do ingrediente não pode ser vazio';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir strings vazias antes de insert e update
CREATE TRIGGER prevent_empty_strings_clientes_before_insert
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do cliente não pode ser vazio';
    END IF;
    IF NEW.Email = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email do cliente não pode ser vazio';
    END IF;
    IF NEW.Telefone = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Telefone do cliente não pode ser vazio';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_clientes_before_update
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do cliente não pode ser vazio';
    END IF;
    IF NEW.Email = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email do cliente não pode ser vazio';
    END IF;
    IF NEW.Telefone = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Telefone do cliente não pode ser vazio';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir strings vazias antes de insert e update
CREATE TRIGGER prevent_empty_strings_empregados_before_insert
BEFORE INSERT ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do empregado não pode ser vazio';
    END IF;
    IF NEW.Posicao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Posição do empregado não pode ser vazia';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_empregados_before_update
BEFORE UPDATE ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do empregado não pode ser vazio';
    END IF;
    IF NEW.Posicao = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Posição do empregado não pode ser vazia';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir strings vazias antes de insert e update
CREATE TRIGGER prevent_empty_strings_reservas_before_insert
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.DataReserva = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data da reserva não pode ser vazia';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_reservas_before_update
BEFORE UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.DataReserva = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data da reserva não pode ser vazia';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir strings vazias antes de insert e update
CREATE TRIGGER prevent_empty_strings_pedidos_before_insert
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    IF NEW.Quantidade IS NULL OR NEW.Quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade do pedido deve ser maior que zero';
    END IF;
    IF NEW.Preco IS NULL OR NEW.Preco <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Preço do pedido deve ser maior que zero';
    END IF;
END //

CREATE TRIGGER prevent_empty_strings_pedidos_before_update
BEFORE UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    IF NEW.Quantidade IS NULL OR NEW.Quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade do pedido deve ser maior que zero';
    END IF;
    IF NEW.Preco IS NULL OR NEW.Preco <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Preço do pedido deve ser maior que zero';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir a entrada de dados NULL ou negativos antes de insert e update
CREATE TRIGGER prevent_null_or_negative_quantidadeprato_before_insert
BEFORE INSERT ON PratoIngredientes
FOR EACH ROW
BEGIN
    IF NEW.QuantidadePorPrato IS NULL OR NEW.QuantidadePorPrato <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'QuantidadePorPrato deve ser maior que zero';
    END IF;
END //

CREATE TRIGGER prevent_null_or_negative_quantidadeprato_before_update
BEFORE UPDATE ON PratoIngredientes
FOR EACH ROW
BEGIN
    IF NEW.QuantidadePorPrato IS NULL OR NEW.QuantidadePorPrato <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'QuantidadePorPrato deve ser maior que zero';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir a entrada de dados negativos antes de insert e update
CREATE TRIGGER prevent_negative_stock_before_insert
BEFORE INSERT ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.QuantidadeEmStock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A quantidade em estoque não pode ser negativa';
    END IF;
END //

CREATE TRIGGER prevent_negative_stock_before_update
BEFORE UPDATE ON Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.QuantidadeEmStock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A quantidade em estoque não pode ser negativa';
    END IF;
END //

DELIMITER ;

DELIMITER //
-- prevenir a entrada de dados negativos antes de insert e update
CREATE TRIGGER prevent_negative_salary_before_insert
BEFORE INSERT ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Salario < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser negativo';
    END IF;
END //

CREATE TRIGGER prevent_negative_salary_before_update
BEFORE UPDATE ON Empregados
FOR EACH ROW
BEGIN
    IF NEW.Salario < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O salário não pode ser negativo';
    END IF;
END //

DELIMITER ;
