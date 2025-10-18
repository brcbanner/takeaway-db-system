##########################################################################
######################### DATABASE CREATION ##############################
##########################################################################

DROP DATABASE IF EXISTS SandwichDB;
CREATE DATABASE SandwichDB;
USE SandwichDB;

##########################################################################
######################### TABLE CREATION #################################
##########################################################################

############################### TABLE Store ###############################
DROP TABLE IF EXISTS Store;

CREATE TABLE Store (
    ProvinceCode CHAR(2) PRIMARY KEY,
    Region VARCHAR(20) NOT NULL,
    Province VARCHAR(25) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    PostalCode CHAR(5) NOT NULL,
    StreetNumber VARCHAR(10)
) ENGINE = INNODB;

############################### TABLE Employee ###############################
DROP TABLE IF EXISTS Employee;

CREATE TABLE IF NOT EXISTS Employee (
    EmployeeCode VARCHAR(10) PRIMARY KEY 
        CHECK (EmployeeCode REGEXP '^E_[0-9]+$'),
    Name VARCHAR(15) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    TaxCode CHAR(16) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    IDCardNumber CHAR(9) UNIQUE 
        CHECK (IDCardNumber IS NULL OR IDCardNumber REGEXP '^[A-Z]{2}[0-9]{5}[A-Z]{2}$'),
    PassportNumber CHAR(9) UNIQUE 
        CHECK (PassportNumber IS NULL OR PassportNumber REGEXP '^[A-Z]{2}[0-9]{7}$'),
    ProfessionalTitle VARCHAR(25) NOT NULL,
    ContractType VARCHAR(15) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Salary DECIMAL(6, 2) NOT NULL
        CHECK (Salary >= 0),
    Sector VARCHAR(40),
    StoreCode CHAR(2),
    FOREIGN KEY (StoreCode) 
        REFERENCES Store(ProvinceCode)
        ON UPDATE CASCADE 
) ENGINE = INNODB;

############################### TABLE PastContract ###############################
DROP TABLE IF EXISTS PastContract;

CREATE TABLE PastContract (
    EmployeeCode VARCHAR(10),
    StoreCode CHAR(2),
    StartDate DATE NOT NULL,
    EndDate DATE  NOT NULL,
    Salary DECIMAL(6, 2) NOT NULL
        CHECK (Salary >= 0),
    Sector VARCHAR(40) NOT NULL,
    PRIMARY KEY (EmployeeCode, StoreCode),
    FOREIGN KEY (EmployeeCode) 
        REFERENCES Employee(EmployeeCode)
        ON UPDATE CASCADE,
    FOREIGN KEY (StoreCode) 
        REFERENCES Store(ProvinceCode)
        ON UPDATE CASCADE
) ENGINE = INNODB;

############################### TABLE Ingredient ###############################
DROP TABLE IF EXISTS Ingredient;

CREATE TABLE Ingredient (
    IngredientCode VARCHAR(10) PRIMARY KEY
        CHECK (IngredientCode REGEXP '^I_[0-9]+$'),
    Category VARCHAR(30) NOT NULL,
    Name VARCHAR(20) UNIQUE NOT NULL
) ENGINE = INNODB;

############################### TABLE Inventory ###############################
DROP TABLE IF EXISTS Inventory;

CREATE TABLE Inventory (
    StoreCode CHAR(2),
    IngredientCode VARCHAR(10),
    AvailableWeight DECIMAL(4, 2) NOT NULL
        CHECK (AvailableWeight >= 0),
    UnitPrice DECIMAL(4, 2) NOT NULL
        CHECK (UnitPrice >= 0),
    ExpirationDate DATE NOT NULL,
    PRIMARY KEY (StoreCode, IngredientCode),
    FOREIGN KEY (StoreCode) 
        REFERENCES Store(ProvinceCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (IngredientCode) 
        REFERENCES Ingredient(IngredientCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = INNODB;

############################### TABLE Sandwich ###############################
DROP TABLE IF EXISTS Sandwich;

CREATE TABLE Sandwich (
    SandwichCode VARCHAR(5) PRIMARY KEY 
        CHECK (SandwichCode REGEXP '^S_[0-9]+$'),
    Name VARCHAR(20) UNIQUE NOT NULL,
    Price DECIMAL(4, 2) NOT NULL
        CHECK (Price >= 0),
    Description VARCHAR(50) NOT NULL
) ENGINE = INNODB;

############################### TABLE Composition ###############################
DROP TABLE IF EXISTS Composition;

CREATE TABLE Composition (
    IngredientCode VARCHAR(10),
    SandwichCode VARCHAR(5),
    PRIMARY KEY (IngredientCode, SandwichCode),
    FOREIGN KEY (IngredientCode) 
        REFERENCES Ingredient(IngredientCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (SandwichCode) 
        REFERENCES Sandwich(SandwichCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = INNODB;

############################### TABLE Order ###############################
DROP TABLE IF EXISTS Order;

CREATE TABLE Order (
    OrderID VARCHAR(15) PRIMARY KEY 
        CHECK (OrderID REGEXP '^O_[0-9]+$'),
    TotalOrderPrice DECIMAL(5, 2) DEFAULT 0
) ENGINE = INNODB;

############################### TABLE OrderDetails ###############################
DROP TABLE IF EXISTS OrderDetails;

CREATE TABLE OrderDetails (
    OrderID VARCHAR(15),
    SandwichCode VARCHAR(5),
    PRIMARY KEY (OrderID, SandwichCode),
    FOREIGN KEY (OrderID) 
        REFERENCES Order(OrderID)
        ON UPDATE CASCADE,
    FOREIGN KEY (SandwichCode) 
        REFERENCES Sandwich(SandwichCode)
        ON UPDATE CASCADE
) ENGINE = INNODB;

############################### TABLE Customer ###############################
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    CustomerCode VARCHAR(10) PRIMARY KEY 
        CHECK (CustomerCode REGEXP '^C_[0-9]+$'),
    Name VARCHAR(15) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    TaxCode CHAR(16) UNIQUE NOT NULL,
    Age TINYINT UNSIGNED NOT NULL,
    Email VARCHAR(70) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Region VARCHAR(20) NOT NULL,
    Province VARCHAR(25) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    PostalCode CHAR(5) NOT NULL,
    StreetNumber VARCHAR(10) NOT NULL,
    FloorNumber TINYINT UNSIGNED NULL
) ENGINE = INNODB;

############################### TABLE Payment ###############################
DROP TABLE IF EXISTS Payment;

CREATE TABLE Payment (
    PaymentID VARCHAR(15) PRIMARY KEY 
        CHECK (PaymentID REGEXP '^P_[0-9]+$'),
    PaymentMethod ENUM('CreditCard', 'Paypal', 'Satispay') NOT NULL,
    TransactionDate DATE NOT NULL,
    TransactionTime TIME NOT NULL,
    CustomerCode VARCHAR(10),
    OrderID VARCHAR(15),
    FOREIGN KEY (CustomerCode) 
        REFERENCES Customer(CustomerCode)
        ON UPDATE CASCADE,
    FOREIGN KEY (OrderID) 
        REFERENCES `Order`(OrderID)
        ON UPDATE CASCADE,
    CONSTRAINT UniquePaymentPerOrder UNIQUE (OrderID)
) ENGINE = INNODB;

############################### TABLE Rider ###############################
DROP TABLE IF EXISTS Rider;

CREATE TABLE Rider (
    RiderCode VARCHAR(10) PRIMARY KEY 
        CHECK (RiderCode REGEXP '^R_[0-9]+$'),
    Name VARCHAR(15) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    TaxCode CHAR(16) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    IDCardNumber CHAR(9) UNIQUE 
        CHECK (IDCardNumber IS NULL OR IDCardNumber REGEXP '^[A-Z]{2}[0-9]{5}[A-Z]{2}$'),
    PassportNumber CHAR(9) UNIQUE 
        CHECK (PassportNumber IS NULL OR PassportNumber REGEXP '^[A-Z]{2}[0-9]{7}$'),
    VATNumber CHAR(11) UNIQUE NOT NULL
) ENGINE = INNODB;

############################### TABLE Delivery ###############################
DROP TABLE IF EXISTS Delivery;

CREATE TABLE Delivery (
    DeliveryID VARCHAR(15) PRIMARY KEY 
        CHECK (DeliveryID REGEXP '^D_[0-9]+$'),
    DeliveryMethod ENUM('Standard', 'Express') NOT NULL,
    Distance DECIMAL(4, 2) 
        CHECK (Distance >= 0 AND Distance <= 20),
    DeliveryDate DATE NOT NULL,
    DeliveryTime TIME NOT NULL,
    OrderID VARCHAR(15),
    CustomerCode VARCHAR(10),
    RiderCode VARCHAR(10),
    StoreCode CHAR(2),
    FOREIGN KEY (OrderID) 
        REFERENCES Order(OrderID)
        ON UPDATE CASCADE,
    FOREIGN KEY (CustomerCode) 
        REFERENCES Customer(CustomerCode)
        ON UPDATE CASCADE,
    FOREIGN KEY (RiderCode) 
        REFERENCES Rider(RiderCode)
        ON UPDATE CASCADE,
    FOREIGN KEY (StoreCode) 
        REFERENCES Store(ProvinceCode)
        ON UPDATE CASCADE,
    CONSTRAINT UniqueDeliveryPerOrder UNIQUE (OrderID)
) ENGINE = INNODB;
