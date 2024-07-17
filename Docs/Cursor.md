### Procedimento Armazenado com Cursor

O procedimento `RelatorioPedidosPeriodo` utiliza um cursor para iterar sobre os resultados de uma consulta que calcula a quantidade total de cada prato pedido dentro de um intervalo de datas específico.

```sql
DELIMITER //

CREATE PROCEDURE RelatorioPedidosPeriodo(
    IN p_DataInicio DATETIME,
    IN p_DataFim DATETIME
)
BEGIN
    -- Declarações das variáveis locais
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
        -- Fetch para obter os valores atuais do cursor
        FETCH cursor_pedidos INTO p_Nome, p_QuantidadeTotal;

        -- Verifica se não há mais linhas para ler
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Saída dos resultados (pode ser modificado conforme necessário)
        SELECT p_Nome AS Prato, p_QuantidadeTotal AS QuantidadeTotal;
    END LOOP;

    -- Fechar o cursor
    CLOSE cursor_pedidos;
END //

DELIMITER ;
```

### Considerações

- **Performance:** O uso de cursores pode impactar o desempenho em grandes conjuntos de dados. Considere otimizações alternativas dependendo da complexidade e do volume de dados.
  
- **Modificações:** A estrutura do loop e o que é feito com os resultados (`SELECT`, armazenamento em tabela, etc.) podem ser ajustados conforme os requisitos específicos do relatório.
