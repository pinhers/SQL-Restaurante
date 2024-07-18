## Triggers para Atualização e Validação

### 1. Atualizar a Quantidade em Stock de um Ingrediente Após um Pedido

**Objetivo:** Atualiza a quantidade em estoque de um ingrediente após a inserção de um pedido.

```sql
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
```

### 2. Impedir Pedido sem Estoque

**Objetivo:** Impede a inserção de um pedido se não houver ingredientes suficientes em estoque.

```sql
DELIMITER //

CREATE TRIGGER ImpedirPedidoSemEstoque
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE QuantidadeDisponivel INT;
    DECLARE IngredienteID INT;
    DECLARE QuantidadeNecessaria INT;
    DECLARE done INT DEFAULT 0;

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

        SELECT QuantidadeEmStock INTO QuantidadeDisponivel
        FROM Ingredientes
        WHERE ID = IngredienteID;

        IF QuantidadeDisponivel < QuantidadeNecessaria * NEW.Quantidade THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade insuficiente em estoque';
        END IF;
    END LOOP;

    CLOSE cursor_ingredientes;

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
```

### 3. Prevenir Strings Vazias na Tabela Pratos

**Objetivo:** Impede a inserção ou atualização de pratos com campos obrigatórios vazios.

```sql
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
```

### 4. Prevenir Strings Vazias na Tabela Empregados

**Objetivo:** Impede a inserção ou atualização de empregados com campos obrigatórios vazios.

```sql
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
```

### 5. Atualizar Preço Total de um Pedido

**Objetivo:** Atualiza o preço total de um pedido antes da inserção com base no preço unitário do prato e na quantidade pedida.

```sql
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
```

### 6. Prevenir Preços Negativos na Tabela Pratos

**Objetivo:** Impede a inserção ou atualização de pratos com preço negativo.

```sql
DELIMITER //

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
```

### 7. Prevenir Strings Vazias na Tabela Ingredientes

**Objetivo:** Impede a inserção ou atualização de ingredientes com campos obrigatórios vazios.

```sql
DELIMITER //

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
```

### 8. Prevenir Strings Vazias na Tabela Clientes

**Objetivo:** Impede a inserção ou atualização de clientes com campos obrigatórios vazios.

```sql
DELIMITER //

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
```

### 9. Prevenir Strings Vazias na Tabela Reservas

**Objetivo:** Impede a inserção ou atualização de reservas com campos obrigatórios vazios.

```sql
DELIMITER //

CREATE TRIGGER prevent_empty_strings_reservas_before_insert
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.DataReserva = '' THEN
        SIGNAL SQL

STATE '45000'
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
```

### 10. Prevenir Quantidades ou Preços Nulos ou Negativos na Tabela Pedidos

**Objetivo:** Impede a inserção ou atualização de pedidos com quantidades ou preços nulos ou negativos.

```sql
DELIMITER //

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
```

### 11. Prevenir Quantidades nulas ou negativas na Tabela PratoIngredientes

**Objetivo:** Impede a inserção ou atualização de quantidades nulas ou negativas na tabela `PratoIngredientes`.

```sql
DELIMITER //

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
```

### 12. Prevenir Estoque Negativo na Tabela Ingredientes

**Objetivo:** Impede a inserção ou atualização de ingredientes com estoque negativo.

```sql
DELIMITER //

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
```

### 13. Prevenir Salários Negativos na Tabela Empregados

**Objetivo:** Impede a inserção ou atualização de empregados com salários negativos.

```sql
DELIMITER //

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
```
