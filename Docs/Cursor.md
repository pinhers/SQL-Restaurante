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

### Explicação Concisa

- **Declaração de Variáveis:** São definidas as variáveis `done`, `p_Nome`, e `p_QuantidadeTotal` para armazenar temporariamente os resultados do cursor.
  
- **Cursor (`DECLARE cursor_pedidos CURSOR FOR ...`):** Define um cursor que executa uma consulta para calcular a quantidade total de cada prato pedido dentro do intervalo de datas especificado.

- **Handler (`DECLARE CONTINUE HANDLER ...`):** Define um manipulador para lidar com a situação em que o cursor não encontra mais linhas para processar.

- **Abrir o Cursor (`OPEN cursor_pedidos`):** Inicia a execução do cursor, preparando-o para interagir sobre as linhas retornadas pela consulta.

- **Loop (`read_loop: LOOP ... END LOOP`):** Utiliza um loop para iterar sobre as linhas retornadas pelo cursor. Dentro do loop:
  - `FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal`: Obtém os valores atuais do cursor e os armazena nas variáveis locais.
  - Verifica se não há mais linhas para processar (`IF done THEN LEAVE read_loop;`).
  - Seleciona (`SELECT`) os resultados desejados, que neste caso são o nome do prato e a quantidade total.

- **Fechar o Cursor (`CLOSE cursor_pedidos`):** Finaliza o cursor para liberar recursos após o término do loop.
