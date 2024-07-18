# Restaurante Database ([Cursor](https://github.com/pinhers/SQL-Restaurante/blob/main/SQL/create-Cursor.sql))

```sql
DELIMITER //

CREATE PROCEDURE RelatorioPedidosPeriodo(
    IN p_DataInicio DATETIME,
    IN p_DataFim DATETIME
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE p_Nome VARCHAR(100);
    DECLARE p_QuantidadeTotal INT;

    -- Cursor para selecionar os pratos e a quantidade total pedida de cada um
    DECLARE cursor_pedidos CURSOR FOR
        SELECT P.Nome, SUM(PD.Quantidade) AS TotalQuantidade
        FROM Pedidos PD
        JOIN Reservas R ON R.ID = PD.ReservaID
        JOIN Pratos P ON P.ID = PD.PratoID
        WHERE R.DataReserva BETWEEN p_DataInicio AND p_DataFim
        GROUP BY P.Nome;

    -- Handler para tratar quando não houver mais linhas para buscar
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Abrir o cursor
    OPEN cursor_pedidos;

    -- Loop para ler os resultados do cursor
    read_loop: LOOP
        FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal;

        -- Verifica se não há mais linhas para ler
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Saída dos resultados
        SELECT p_Nome AS Prato, p_QuantidadeTotal AS QuantidadeTotal;
    END LOOP;

    -- Fechar o cursor
    CLOSE cursor_pedidos;
END //

DELIMITER ;
```

### Explicação

- **Declaração de Variáveis:** São definidas as variáveis `done`, `p_Nome`, e `p_QuantidadeTotal` para armazenar temporariamente os resultados do cursor.
  
- **Cursor (`DECLARE cursor_pedidos CURSOR FOR ...`):** Define um cursor que executa uma consulta para calcular a quantidade total de cada prato pedido dentro do intervalo de datas especificado.

- **Handler (`DECLARE CONTINUE HANDLER ...`):** Define um manipulador para lidar com a situação em que o cursor não encontra mais linhas para processar.

- **Abrir o Cursor (`OPEN cursor_pedidos`):** Inicia a execução do cursor, preparando-o para interagir sobre as linhas retornadas pela consulta.

- **Loop (`read_loop: LOOP ... END LOOP`):** Utiliza um loop para iterar sobre as linhas retornadas pelo cursor. Dentro do loop:
  - `FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal`: Obtém os valores atuais do cursor e os armazena nas variáveis locais.
  - Verifica se não há mais linhas para processar (`IF done THEN LEAVE read_loop;`).
  - Seleciona (`SELECT`) os resultados desejados, que neste caso são o nome do prato e a quantidade total.

- **Fechar o Cursor (`CLOSE cursor_pedidos`):** Finaliza o cursor para liberar recursos após o término do loop.

```sql
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
```
1. **Declaração do Cursor (`DECLARE cursor_ingredientes CURSOR FOR ...`)**:
   - Um cursor é uma estrutura que permite percorrer linhas de um resultado de consulta, uma a uma.
   - Neste caso, `cursor_ingredientes` é o nome do cursor que irá armazenar o resultado da consulta `SELECT` que busca os ingredientes (`IngredienteID`) e a quantidade necessária por prato (`QuantidadePorPrato`) da tabela `PratoIngredientes` para um prato específico (`PratoID = NEW.PratoID`).

2. **Handler (`DECLARE CONTINUE HANDLER FOR NOT FOUND ...`)**:
   - `DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;` define um manipulador que sinaliza quando não há mais linhas para serem recuperadas pelo cursor (`NOT FOUND` indica que a consulta não retornou mais linhas).

3. **Abertura do Cursor (`OPEN cursor_ingredientes;`)**:
   - Abre o cursor `cursor_ingredientes`, iniciando a iteração pelos resultados da consulta.

4. **Loop de Leitura (`read_loop: LOOP ... END LOOP;`)**:
   - `LOOP` inicia um laço de repetição.
   - `FETCH cursor_ingredientes INTO IngredienteID, QuantidadeNecessaria;` recupera os valores do cursor para as variáveis `IngredienteID` e `QuantidadeNecessaria`.
   - `IF done THEN LEAVE read_loop; END IF;` verifica se não há mais linhas a serem lidas (`done` é sinalizado pelo handler) e termina o loop se for o caso.

5. **Verificação de Quantidade em Estoque (`IF QuantidadeDisponivel < QuantidadeNecessaria * NEW.Quantidade THEN ... END IF;`)**:
   - Para cada ingrediente recuperado, verifica-se se a quantidade em estoque (`QuantidadeEmStock`) é suficiente para atender à quantidade necessária (`QuantidadeNecessaria`) multiplicada pela quantidade do prato (`NEW.Quantidade`).

6. **Sinalização de Erro (`SIGNAL SQLSTATE '45000' ...`)**:
   - Se a quantidade em estoque não for suficiente, o código sinaliza um erro (`SIGNAL`) com o estado SQL `45000` e uma mensagem de erro personalizada (`MESSAGE_TEXT = 'Quantidade insuficiente em estoque'`).

7. **Fechamento do Cursor (`CLOSE cursor_ingredientes;`)**:
   - Ao final do processamento, o cursor é fechado para liberar os recursos.
