---- CONSTRAINTS

-- Check that, for each order, payment occurs before delivery --> *CR1*
DROP TRIGGER IF EXISTS CheckPaymentBeforeDelivery;

DELIMITER $$
CREATE TRIGGER VerifyPaymentBeforeDelivery
BEFORE INSERT ON Delivery
FOR EACH ROW
BEGIN
    DECLARE payment_datetime DATETIME;

    SELECT CONCAT(PaymentDate, ' ', PaymentTime) 
    INTO payment_datetime
    FROM Payment
    WHERE OrderID = NEW.OrderID;

    IF payment_datetime IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Payment for this order does not exist';
    END IF;

    IF payment_datetime >= CONCAT(NEW.DeliveryDate, ' ', NEW.DeliveryTime) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Payment must be made before delivery';
    END IF;
END $$
DELIMITER ;

-- Check that StartDate <= EndDate --> *CR2*
DROP TRIGGER IF EXISTS CheckStartEndDatesPastContract;

DELIMITER $$
CREATE TRIGGER CheckStartEndDatesPastContract
BEFORE INSERT ON PastContract
FOR EACH ROW
BEGIN
    IF NEW.StartDate > NEW.EndDate THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Contract start date must be earlier than end date';
    END IF;
END $$
DELIMITER ;

-- Check that StartDate <= EndDate when EndDate exists --> *CR2*
DROP TRIGGER IF EXISTS CheckStartEndDatesEmployee;

DELIMITER $$
CREATE TRIGGER CheckStartEndDatesEmployee
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.StartDate > NEW.EndDate AND NEW.EndDate IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Contract start date must be earlier than end date';
    END IF;
END $$
DELIMITER ;

-- Check that there is no EndDate if contract is permanent --> *CR3*
DROP TRIGGER IF EXISTS CheckEndDatePermanentContract;

DELIMITER $$
CREATE TRIGGER CheckEndDatePermanentContract
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.ContractType = 'Permanent' AND NEW.EndDate IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: End date of a permanent contract must be null';
    END IF;
END $$
DELIMITER ;

-- Check that there is an EndDate if contract is temporary --> *CR4*
DROP TRIGGER IF EXISTS CheckEndDateTemporaryContract;

DELIMITER $$
CREATE TRIGGER CheckEndDateTemporaryContract
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.ContractType = 'Temporary' AND NEW.EndDate IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: End date of a temporary contract cannot be null';
    END IF;
END $$
DELIMITER ;

-- Check that each employee has at least one of IDCardNumber or PassportNumber --> *CR5*
DROP TRIGGER IF EXISTS CheckEmployeeDocuments;

DELIMITER $$
CREATE TRIGGER CheckRiderDocuments
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.IDCardNumber IS NULL AND NEW.PassportNumber IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: At least one of ID card number or passport number must be present';
    END IF;
END $$
DELIMITER ;

-- Clients cannot exist with Client.Province != Store.Province (similarly for Region) --> *CR6*
DROP TRIGGER IF EXISTS CheckClientProvinceRegionStore;

DELIMITER $$
CREATE TRIGGER CheckClientProvinceRegionStore
BEFORE INSERT ON Client
FOR EACH ROW
BEGIN
    DECLARE storeProvince VARCHAR(25);
    DECLARE storeRegion VARCHAR(20);

    SELECT Region, Province
    INTO storeRegion, storeProvince
    FROM Store
    WHERE Store.Province = NEW.Province;
    
    IF storeProvince IS NULL OR storeRegion != NEW.Region THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: This cannot be a client because they are not located in the same province as any store';
    END IF;
END $$
DELIMITER ;

-- Verify correctness
/*
INSERT INTO Store VALUES ('CT', 'Sicily', 'Catania', 'Corso Italia', '95100', '25');

-- CASE 1 (Client.Province != Store.Province and Client.Region != Store.Region) --> Managed error
INSERT INTO Client VALUES ('CL_1', 'Giuseppe', 'Verdi', 'VRDGPP80A01H501U', 35, 'giuseppe.verdi@email.com', '3331234567', 'Lazio', 'Rome', 'Via Nazionale', '00100', '101', 2);

-- CASE 2 (Client.Province != Store.Province and Client.Region = Store.Region) --> Managed error
INSERT INTO Client VALUES ('CL_2', 'Maria', 'Rossi', 'RSSMRA70A55B319Z', 28, 'maria.rossi@email.com', '3401234567', 'Sicily', 'Palermo', 'Via Libertà', '90100', '50', 1);

-- CASE 3 (Client.Province = Store.Province and Client.Region = Store.Region) --> Valid insertion
INSERT INTO Client VALUES ('CL_3', 'Luca', 'Giorgio', 'GRGLCU85C04A001Z', 30, 'luca.giorgio@email.com', '3207654321', 'Sicily', 'Catania', 'Viale Rapisardi', '95100', '15', 3);

-- CASE 4 (Client.Province = Store.Province and Client.Region != Store.Region) assumed not to happen
*/

-- DELETE FROM Store
-- DELETE FROM Client

---- OPERATIONS

-- Calculate total price of an order
DROP TRIGGER IF EXISTS CalculateTotalOrderPrice;

DELIMITER $$
CREATE TRIGGER CalculateTotalOrderPrice
AFTER INSERT ON Delivery
FOR EACH ROW
BEGIN
    DECLARE piadinasPrice DECIMAL(5, 2);
    DECLARE deliveryPrice DECIMAL(5, 2);
    DECLARE distanceCost DECIMAL(5, 2);

    SELECT SUM(Piadina.Price)
    INTO piadinasPrice
    FROM OrderDetail
    JOIN Piadina ON OrderDetail.PiadinaID = Piadina.PiadinaID
    WHERE OrderDetail.OrderID = NEW.OrderID;

    SET deliveryPrice = 
        CASE NEW.DeliveryMethod
            WHEN 'Express' THEN 3.00
            ELSE 0.00
        END;

    SET distanceCost = NEW.Distance * 0.20;

    UPDATE OrderTable
    SET TotalOrderPrice = IFNULL(piadinasPrice, 0) + IFNULL(deliveryPrice, 0) + IFNULL(distanceCost, 0)
    WHERE OrderID = NEW.OrderID;
END $$
DELIMITER ;

-- Test functionality
/*
# Initialize tables
DELETE FROM OrderDetail;
DELETE FROM Piadina;
DELETE FROM Delivery;
DELETE FROM OrderTable;

# Insert piadinas
INSERT INTO Piadina VALUES ('PD_1', 'Margherita', 4.50, 'Piadina with tomato and mozzarella'), ('PD_2','Vegetarian', 5.00, 'Vegetarian piadina with grilled vegetables');

# Insert an order
INSERT INTO OrderTable (OrderID) VALUES ('O_1');

# Associate piadinas with the order
INSERT INTO OrderDetail VALUES ('O_1', 'PD_1'), ('O_1', 'PD_2');

# Associate delivery with the order
INSERT INTO Delivery (DeliveryID, DeliveryMethod, Distance, DeliveryDate, DeliveryTime, OrderID)
VALUES ('DL_1','Express', 5.00, '2025-01-01', '14:00:00', 'O_1');

# Verify correctness
SELECT * FROM OrderTable WHERE OrderID = 'O_1';

# Re-initialize tables
DELETE FROM OrderDetail;
DELETE FROM Piadina;
DELETE FROM Delivery;
DELETE FROM OrderTable;
*/