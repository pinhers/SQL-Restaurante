# Restaurante Database Schema

Este projeto define o esquema de uma base de dados para um restaurante, incluindo tabelas para clientes, empregados, ingredientes, pratos, reservas, pedidos e a relação entre pratos e ingredientes. Abaixo está a descrição de cada tabela e seus campos.

## Tabelas e Campos ([Tabelas](https://github.com/pinhers/SQL-Restaurante/blob/main/SQL/create-tables.sql))

### 1. Clientes
Tabela que armazena informações sobre os clientes do restaurante.

- **ID**: Identificador único do cliente (int, PK, AI).
- **Nome**: Nome do cliente (varchar(100), NOT NULL, UNIQUE).
- **Email**: Email do cliente (varchar(100), NOT NULL, UNIQUE).
- **Telefone**: Telefone do cliente (varchar(15), UNIQUE).

### 2. Empregados
Tabela que armazena informações sobre os empregados do restaurante.

- **ID**: Identificador único do empregado (int, PK, AI).
- **Nome**: Nome do empregado (varchar(100), NOT NULL, UNIQUE).
- **Posicao**: Posição/funcionário do empregado (varchar(50), NOT NULL, UNIQUE).
- **Salario**: Salário do empregado (decimal(10,2)).

### 3. Ingredientes
Tabela que armazena informações sobre os ingredientes utilizados no restaurante.

- **ID**: Identificador único do ingrediente (int, PK, AI).
- **Nome**: Nome do ingrediente (varchar(100), NOT NULL, UNIQUE).
- **QuantidadeEmStock**: Quantidade em estoque do ingrediente (int, NOT NULL).

### 4. Pratos
Tabela que armazena informações sobre os pratos oferecidos pelo restaurante.

- **ID**: Identificador único do prato (int, PK, AI).
- **Nome**: Nome do prato (varchar(100), NOT NULL, UNIQUE).
- **Descricao**: Descrição do prato (text).
- **Preco**: Preço do prato (decimal(10,2), NOT NULL).
- **Categoria**: Categoria do prato (varchar(50), NOT NULL).

### 5. Reservas
Tabela que armazena informações sobre as reservas feitas pelos clientes.

- **ID**: Identificador único da reserva (int, PK, AI).
- **ClienteID**: Identificador do cliente que fez a reserva (int, NOT NULL, FK).
- **DataReserva**: Data da reserva (varchar(50), NOT NULL, UNIQUE).
- **NumeroPessoas**: Número de pessoas na reserva (int, NOT NULL).
- **EmpregadoID**: Identificador do empregado responsável pela reserva (int, NOT NULL, FK).

### 6. Pedidos
Tabela que armazena informações sobre os pedidos feitos durante uma reserva.

- **ID**: Identificador único do pedido (int, PK, AI).
- **ReservaID**: Identificador da reserva associada ao pedido (int, NOT NULL, FK, UNIQUE).
- **PratoID**: Identificador do prato solicitado no pedido (int, NOT NULL, FK).
- **Quantidade**: Quantidade do prato solicitado (int, NOT NULL).
- **Preco**: Preço do pedido (decimal(10,2), NOT NULL).

### 7. PratoIngredientes
Tabela que relaciona os pratos com seus ingredientes.

- **PratoID**: Identificador do prato (int unsigned, NOT NULL, PK, FK, UNIQUE).
- **IngredienteID**: Identificador do ingrediente (int unsigned, NOT NULL, PK, FK, UNIQUE).
- **QuantidadePorPrato**: Quantidade do ingrediente usado por prato (int, NOT NULL).

## Restrições e Relações

- **Clientes**: Campos `Nome`, `Email` e `Telefone` são únicos.
- **Empregados**: Campos `Nome` e `Posicao` são únicos.
- **Ingredientes**: Campo `Nome` é único.
- **Pratos**: Campo `Nome` é único.
- **Reservas**: Campos `ClienteID` e `EmpregadoID` são chaves estrangeiras referenciando `Clientes(ID)` e `Empregados(ID)` respectivamente.
- **Pedidos**: Campos `ReservaID` e `PratoID` são chaves estrangeiras referenciando `Reservas(ID)` e `Pratos(ID)` respectivamente.
- **PratoIngredientes**: Campos `PratoID` e `IngredienteID` são chaves estrangeiras referenciando `Pratos(ID)` e `Ingredientes(ID)` respectivamente.
