DROP SCHEMA IF EXISTS Restaurante;
CREATE SCHEMA IF NOT EXISTS Restaurante;
USE Restaurante;

CREATE TABLE `Clientes` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Telefone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`),
  UNIQUE KEY `Email_UNIQUE` (`Email`),
  UNIQUE KEY `Telefone_UNIQUE` (`Telefone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Empregados` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Posicao` varchar(50) NOT NULL,
  `Salario` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`),
  UNIQUE KEY `Posicao_UNIQUE` (`Posicao`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Ingredientes` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `QuantidadeEmStock` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Pratos` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Descricao` text,
  `Preco` decimal(10,2) NOT NULL,
  `Categoria` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Reservas` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `DataReserva` varchar(50) NOT NULL,
  `NumeroPessoas` int NOT NULL,
  `EmpregadoID` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `DataReserva_UNIQUE` (`DataReserva`),
  KEY `ClienteID` (`ClienteID`),
  KEY `EmpregadoID` (`EmpregadoID`),
  CONSTRAINT `Reservas_ibfk_1` FOREIGN KEY (`ClienteID`) REFERENCES `Clientes` (`ID`),
  CONSTRAINT `Reservas_ibfk_2` FOREIGN KEY (`EmpregadoID`) REFERENCES `Empregados` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Pedidos` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ReservaID` int NOT NULL,
  `PratoID` int NOT NULL,
  `Quantidade` int NOT NULL,
  `Preco` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `ReservaID_UNIQUE` (`ReservaID`),
  KEY `PratoID` (`PratoID`),
  CONSTRAINT `Pedidos_ibfk_1` FOREIGN KEY (`ReservaID`) REFERENCES `Reservas` (`ID`),
  CONSTRAINT `Pedidos_ibfk_2` FOREIGN KEY (`PratoID`) REFERENCES `Pratos` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PratoIngredientes` (
  `PratoID` int unsigned NOT NULL,
  `IngredienteID` int unsigned NOT NULL,
  `QuantidadePorPrato` int NOT NULL,
  PRIMARY KEY (`PratoID`,`IngredienteID`),
  UNIQUE KEY `PratoID_UNIQUE` (`PratoID`),
  UNIQUE KEY `IngredienteID_UNIQUE` (`IngredienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
