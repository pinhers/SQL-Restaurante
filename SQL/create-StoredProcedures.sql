-- Stored Procedures -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER //

-- Registar um novo pedido
CREATE PROCEDURE RegistrarReserva(
    IN p_ClienteID INT,
    IN p_DataReserva DATETIME,
    IN p_NumeroPessoas INT,
    IN p_EmpregadoID INT
)
BEGIN
    INSERT INTO Reservas (ClienteID, DataReserva, NumeroPessoas, EmpregadoID)
    VALUES (p_ClienteID, p_DataReserva, p_NumeroPessoas, p_EmpregadoID);
END //

-- Atualizar os dados de um cliente
CREATE PROCEDURE AtualizarCliente(
    IN p_ID INT,
    IN p_Nome VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_Telefone VARCHAR(15)
)
BEGIN
    UPDATE Clientes
    SET Nome = p_Nome,
        Email = p_Email,
        Telefone = p_Telefone
    WHERE ID = p_ID;
END //

-- Calcular o total de reservas de um determinado período
CREATE PROCEDURE TotalReservasPeriodo(
    IN p_DataInicio DATETIME,
    IN p_DataFim DATETIME
)
BEGIN
    SELECT COUNT(*) AS TotalReservas
    FROM Reservas
    WHERE DataReserva BETWEEN p_DataInicio AND p_DataFim;
END //

DELIMITER ;
