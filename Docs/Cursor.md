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


## Procedimento `RelatorioPedidosPeriodo`

O procedimento a seguir é utilizado para gerar um relatório de pedidos de pratos dentro de um período específico.

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

    DECLARE cursor_pedidos CURSOR FOR
        SELECT P.Nome, SUM(PD.Quantidade) AS TotalQuantidade
        FROM Pedidos PD
        JOIN Reservas R ON R.ID = PD.ReservaID
        JOIN Pratos P ON P.ID = PD.PratoID
        WHERE R.DataReserva BETWEEN p_DataInicio AND p_DataFim
        GROUP BY P.Nome;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cursor_pedidos;

    read_loop: LOOP
        FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Saída dos resultados
        SELECT p_Nome AS Prato, p_QuantidadeTotal AS QuantidadeTotal;
    END LOOP;

    CLOSE cursor_pedidos;
END //

DELIMITER ;
```

### Explicação

1. **Declaração de Variáveis**:
   - `done`: Variável que indica se todas as linhas do cursor foram processadas.
   - `p_Nome`: Variável para armazenar o nome do prato durante a iteração do cursor.
   - `p_QuantidadeTotal`: Variável para armazenar a quantidade total de cada prato pedido.

2. **Cursor**:
   - Define um cursor (`cursor_pedidos`) que executa uma consulta para calcular a quantidade total de cada prato pedido dentro do intervalo de datas especificado (`p_DataInicio` e `p_DataFim`).
   - A consulta utiliza `JOIN`s para relacionar as tabelas `Pedidos`, `Reservas`, e `Pratos`, e agrupa os resultados pelo nome do prato.

3. **Handler**:
   - Define um manipulador (`CONTINUE HANDLER`) para lidar com a situação em que o cursor não encontra mais linhas para processar. Nesse caso, define `done` como `1`.

4. **Abrir o Cursor**:
   - Inicia a execução do cursor (`OPEN cursor_pedidos`), preparando-o para iterar sobre as linhas retornadas pela consulta.

5. **Loop**:
   - Utiliza um loop (`read_loop`) para iterar sobre as linhas retornadas pelo cursor.
   - `FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal`: Obtém os valores atuais do cursor e os armazena nas variáveis locais `p_Nome` e `p_QuantidadeTotal`.
   - Verifica se `done` é `1`, indicando que não há mais linhas para processar, e então sai do loop.

6. **Saída dos Resultados**:
   - Dentro do loop, seleciona os resultados desejados (`SELECT p_Nome AS Prato, p_QuantidadeTotal AS QuantidadeTotal;`), que neste caso são o nome do prato e a quantidade total.

7. **Fechar o Cursor**:
   - Finaliza o cursor (`CLOSE cursor_pedidos`) para liberar recursos após o término do loop.
