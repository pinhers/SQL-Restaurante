select * from Pratos;
select * from Ingredientes;
select * from PratoIngredientes;
select * from Clientes;
select * from Empregados;
select * from Pedidos;
select * from Reservas;

-- Listar todos os pratos disponíveis com os respetivos ingredientes
SELECT P.Nome AS Prato, GROUP_CONCAT(I.Nome) AS Ingredientes
FROM Pratos P
JOIN Ingredientes I ON I.ID = P.ID
GROUP BY P.Nome;

-- Listar as reservas realizadas num determinado período
SELECT * FROM Reservas
WHERE DataReserva BETWEEN '2024-01-01' AND '2024-12-31';

-- Listar os clientes que fizeram mais de um determinado número de reservas
SELECT C.Nome, COUNT(R.ID) AS NumeroReservas
FROM Clientes C
JOIN Reservas R ON C.ID = R.ClienteID
GROUP BY C.Nome
HAVING COUNT(R.ID) >= 2;

-- Listar os pratos de uma determinada categoria
SELECT * FROM Pratos
WHERE Categoria = 'Pizza';


-- Tentar inserir um novo pedido com quantidade maior do que a disponível (supondo que o prato hamburger tem ID 2)
-- Supondo que temos apenas 47 unidades de alface em estoque, e tentamos inserir um pedido de 47 unidades (cada hamburger tem 1 alface).
INSERT INTO Pedidos (ReservaID, PratoID, Quantidade) VALUES (1, 2, 48);


-- ----stored Procedures
CALL RegistrarReserva(1, '2019-03-15 19:00', 3, 1);
-- cliente, data, quantos, empregado

CALL AtualizarCliente(1, 'Updated Name', 'updated_email@example.com', '987654321');
CALL AtualizarCliente(2, 'Afonso', 'afonsoPinheiro@example.com', '987654321');

CALL TotalReservasPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');

-- --- cursor
CALL RelatorioPedidosPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');
