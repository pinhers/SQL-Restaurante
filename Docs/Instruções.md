### Consultas SQL

#### Listar todos os pratos disponíveis com os respetivos ingredientes

Este comando lista todos os pratos e os ingredientes associados:

```sql
SELECT P.Nome AS Prato, GROUP_CONCAT(I.Nome SEPARATOR ', ') AS Ingredientes
FROM Pratos P
JOIN PratoIngredientes PI ON P.ID = PI.PratoID
JOIN Ingredientes I ON PI.IngredienteID = I.ID
GROUP BY P.Nome;
```

#### Listar as reservas realizadas num determinado período

Este comando lista todas as reservas feitas dentro de um período específico:

```sql
SELECT * FROM Reservas
WHERE DataReserva BETWEEN '2024-01-01' AND '2024-12-31';
```

#### Listar os clientes que fizeram mais de um determinado número de reservas

Este comando lista os clientes que fizeram mais de um determinado número de reservas:

```sql
SELECT C.Nome, COUNT(R.ID) AS NumeroReservas
FROM Clientes C
JOIN Reservas R ON C.ID = R.ClienteID
GROUP BY C.Nome
HAVING COUNT(R.ID) >= 2;
```

#### Listar os pratos de uma determinada categoria

Este comando lista todos os pratos que pertencem a uma determinada categoria:

```sql
SELECT * FROM Pratos
WHERE Categoria = 'Pizza';
```

#### Inserir um novo pedido com quantidade maior do que a disponível

Este comando tenta inserir um novo pedido, supondo que o prato `Chicken Alfredo` tem `PratoID = 4` e a quantidade disponível do ingrediente principal é insuficiente. Isso acionará o gatilho de verificação de estoque:

```sql
INSERT INTO Pedidos (ReservaID, PratoID, Quantidade, Preco)
VALUES (1, 4, 25, 349.75);
```

### Stored Procedures

#### Registrar um novo pedido

Chame o procedimento armazenado `RegistrarPedido` para registrar um novo pedido:

```sql
CALL RegistrarPedido(1, 4, 3, 29.99);  -- n de reserva, qual prato, quantos, preco
```

#### Atualizar os dados de um cliente

Chame o procedimento armazenado `AtualizarCliente` para atualizar as informações de um cliente:

```sql
CALL AtualizarCliente(1, 'Afonso', 'afonsoPinheiro@example.com', '987654321');
```

#### Calcular o total de reservas de um determinado período

Chame o procedimento armazenado `TotalReservasPeriodo` para calcular o total de reservas feitas num período específico:

```sql
CALL TotalReservasPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');
```

### Cursor

#### Gerar um relatório que lista todos os pratos e a quantidade pedida de cada um num determinado período

Chame o procedimento armazenado `RelatorioPedidosPeriodo` para gerar um relatório com os pedidos feitos num determinado período:

```sql
CALL RelatorioPedidosPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');
```

### Exemplo Completo de Utilização

Aqui está um exemplo de como você pode utilizar os comandos acima em uma sequência lógica:

1. **Adicionar um cliente e um empregado:**

    ```sql
    INSERT INTO Clientes (Nome, Email, Telefone) VALUES ('Cliente Teste', 'cliente@teste.com', '123456789');
    INSERT INTO Empregados (Nome, Posicao, Salario) VALUES ('Empregado Teste', 'Garçom', 2000.00);
    ```

2. **Adicionar uma reserva:**

    ```sql
    INSERT INTO Reservas (ClienteID, DataReserva, NumeroPessoas, EmpregadoID)
    VALUES (1, '2024-07-15 19:00:00', 2, 1);
    ```

3. **Registrar um pedido:**

    ```sql
    CALL RegistrarPedido(1, 4, 3, 29.99);
    ```

4. **Atualizar um cliente:**

    ```sql
    CALL AtualizarCliente(1, 'Afonso', 'afonsoPinheiro@example.com', '987654321');
    ```

5. **Calcular o total de reservas num período:**

    ```sql
    CALL TotalReservasPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');
    ```

6. **Gerar um relatório de pedidos num período:**

    ```sql
    CALL RelatorioPedidosPeriodo('2024-01-01 00:00:00', '2024-12-31 23:59:59');
    ```
