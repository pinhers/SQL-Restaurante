USE Restaurante;



-- Clientes
INSERT INTO Clientes (Nome, Email, Telefone) VALUES
('João Silva', 'joao.silva@example.com', '123456789'),
('Maria Souza', 'maria.souza@example.com', '987654321'),
('Carlos Pereira', 'carlos.pereira@example.com', '555555555');

-- Empregados
INSERT INTO Empregados (Nome, Posicao, Salario) VALUES
('Ana Costa', 'Garçonete', 1500.00),
('Pedro Santos', 'Chef', 3000.00),
('Fernanda Lima', 'Gerente', 4000.00);

-- Ingredientes
INSERT INTO Ingredientes (Nome, QuantidadeEmStock) VALUES
('Tomate', 100),
('Alface', 50),
('Queijo', 200),
('Pão', 150);

-- Pratos
INSERT INTO Pratos (Nome, Descricao, Preco, Categoria) VALUES
('Salada Caprese', 'Salada de tomate, queijo e manjericão', 15.00, 'Salada'),
('Hambúrguer', 'Pão, carne, queijo e alface', 25.00, 'Lanche'),
('Pizza Margherita', 'Pizza com tomate, queijo e manjericão', 30.00, 'Pizza');

-- PratoIngredientes
INSERT INTO PratoIngredientes (PratoID, IngredienteID, QuantidadePorPrato) VALUES
(1, 1, 2), -- Salada Caprese: 2 tomates
(1, 3, 1), -- Salada Caprese: 1 queijo
(2, 4, 1), -- Hambúrguer: 1 pão
(2, 3, 1), -- Hambúrguer: 1 queijo
(2, 2, 1), -- Hambúrguer: 1 alface
(3, 1, 2), -- Pizza Margherita: 2 tomates
(3, 3, 1); -- Pizza Margherita: 1 queijo

-- Reservas
INSERT INTO Reservas (ClienteID, DataReserva, NumeroPessoas, EmpregadoID) VALUES
(1, '2024-07-20 19:00:00', 2, 1),
(2, '2024-07-21 20:00:00', 4, 2),
(3, '2024-07-22 18:00:00', 3, 3);

-- Pedidos
INSERT INTO Pedidos (ReservaID, PratoID, Quantidade) VALUES
(1, 1, 2), -- 2 Salada Caprese
(1, 2, 1), -- 1 Hambúrguer
(2, 3, 1), -- 1 Pizza Margherita
(3, 1, 1), -- 1 Salada Caprese
(3, 2, 2); -- 2 Hambúrgueres
