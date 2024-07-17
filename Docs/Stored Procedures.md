# Restaurante Database ([Stored Procedures](https://github.com/pinhers/SQL-Restaurante/blob/main/SQL/create-StoredProcedures.sql))
### Stored Procedure: RegistrarReserva

```sql
DELIMITER //

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

DELIMITER ;
```

- **Objetivo:** Registra uma nova reserva na tabela `Reservas` com os dados fornecidos.

- **Parâmetros:**
  - `p_ClienteID`: ID do cliente que está fazendo a reserva.
  - `p_DataReserva`: Data e hora da reserva.
  - `p_NumeroPessoas`: Número de pessoas para a reserva.
  - `p_EmpregadoID`: ID do empregado responsável pela reserva.

- **Funcionamento:**
  - A stored procedure insere uma nova linha na tabela `Reservas` com os valores dos parâmetros fornecidos.

### Stored Procedure: AtualizarCliente

```sql
DELIMITER //

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

DELIMITER ;
```

- **Objetivo:** Atualiza os dados de um cliente na tabela `Clientes` com base no ID fornecido.

- **Parâmetros:**
  - `p_ID`: ID do cliente que será atualizado.
  - `p_Nome`: Novo nome do cliente.
  - `p_Email`: Novo e-mail do cliente.
  - `p_Telefone`: Novo telefone do cliente.

- **Funcionamento:**
  - A stored procedure executa um comando `UPDATE` na tabela `Clientes`, definindo os novos valores de `Nome`, `Email` e `Telefone` para o cliente com o ID especificado.

### Stored Procedure: TotalReservasPeriodo

```sql
DELIMITER //

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
```

- **Objetivo:** Calcula o total de reservas realizadas dentro de um período de datas específico.

- **Parâmetros:**
  - `p_DataInicio`: Data de início do período.
  - `p_DataFim`: Data de término do período.

- **Funcionamento:**
  - A stored procedure realiza uma consulta `SELECT COUNT(*)` na tabela `Reservas`, contando o número de registros onde a `DataReserva` está dentro do intervalo especificado pelos parâmetros `p_DataInicio` e `p_DataFim`.
  - Retorna o resultado como `TotalReservas`.

### Considerações Gerais

- **Utilização:** As stored procedures são úteis para encapsular lógica de banco de dados que precisa ser executada repetidamente, garantindo consistência e segurança nos dados.
  
- **Parâmetros:** Permitem que operações complexas sejam realizadas de forma mais simples, passando valores diretamente para dentro da lógica da procedure.

- **Segurança e Performance:** Podem contribuir para melhorar a segurança (prevenindo injeções SQL) e a performance (por exemplo, ao executar operações de atualização em lote de forma otimizada).
