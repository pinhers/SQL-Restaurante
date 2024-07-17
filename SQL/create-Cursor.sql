-- Cursoresy


DELIMITER //

-- Gerar um relatório que lista todos os pratos e a quantidade pedida de cada um num determinado período
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

        -- Output the results; you can modify this as needed
        SELECT p_Nome AS Prato, p_QuantidadeTotal AS QuantidadeTotal;
    END LOOP;

    CLOSE cursor_pedidos;
END //

DELIMITER ;
