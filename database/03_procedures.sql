-- 1 Remove expired ingredients
DROP PROCEDURE IF EXISTS RemoveExpiredIngredients;

DELIMITER $$
CREATE PROCEDURE RemoveExpiredIngredients()
BEGIN
    DELETE FROM Inventory
    WHERE ExpirationDate < CURDATE();
END $$
DELIMITER ;

/*
-- CASE 1: Only one case because there can be no errors
CALL RemoveExpiredIngredients();
*/

-- 2 Check the quantity of an ingredient against a certain limit for each store. Print stores that do not respect this limit and the available weight of the ingredient
DROP PROCEDURE IF EXISTS ListStoresWithLimitedIngredient;

DELIMITER $$
CREATE PROCEDURE ListStoresWithLimitedIngredient(LimitWeight DECIMAL(4,2), IngredientName VARCHAR(20))
BEGIN
    DECLARE CorrespondingIngredientCode VARCHAR(10);
    
    IF LimitWeight < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: The limit weight cannot be a negative number';
    END IF;

    SELECT IngredientCode INTO CorrespondingIngredientCode
    FROM Ingredient
    WHERE Name = IngredientName;

    IF CorrespondingIngredientCode IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: This ingredient does not belong to the chain''s ingredient list';
    ELSE
        SELECT Store, 
               AvailableWeight
        FROM Inventory
        WHERE AvailableWeight < LimitWeight
        AND Ingredient = CorrespondingIngredientCode;
    END IF;
END $$
DELIMITER ;

/*
-- CASE 1: Limit weight is negative
CALL ListStoresWithLimitedIngredient(-1, 'Tomato'); -- Error Code: 1644. Error: The limit weight cannot be a negative number

-- CASE 2: Ingredient name does not exist in the table
CALL ListStoresWithLimitedIngredient(10, 'Tomato'); -- Error Code: 1644. Error: This ingredient does not belong to the chain's ingredient list

-- CASE 3: Ingredient exists
CALL ListStoresWithLimitedIngredient(10, 'Gorgonzola'); -- Example: 'FI' , '9.50'
*/

-- 3 Print the chain's menu, i.e., list all sandwiches with ingredients and price
DROP PROCEDURE IF EXISTS ChainMenu;

DELIMITER $$
CREATE PROCEDURE ChainMenu()
BEGIN
    SELECT S.Name AS SandwichName, 
           GROUP_CONCAT(I.Name SEPARATOR ', ') AS RequiredIngredients, 
           S.Price
    FROM Sandwich S, Composition C, Ingredient I
    WHERE S.SandwichCode = C.Sandwich
    AND C.Ingredient = I.IngredientCode
    GROUP BY S.SandwichCode;
END $$
DELIMITER ;

/*
-- CASE 1: Only one case because there can be no errors
CALL ChainMenu();
*/

-- 4 Print the receipt of an order, identified by a code, only if it has been delivered. The receipt contains the order code, customer's first and last name, total order price, and payment information (method, date, time)
DROP PROCEDURE IF EXISTS PrintOrderReceipt;

DELIMITER $$
CREATE PROCEDURE PrintOrderReceipt(OrderCode VARCHAR(15))
BEGIN
    DECLARE OrderExists TINYINT;
    DECLARE OrderPrice DECIMAL(5,2);
    
    IF OrderCode NOT REGEXP '^O_[0-9]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: The order code format is invalid. Must be O_<positive number>';
    END IF;

    SELECT EXISTS(
        SELECT 1
        FROM Orders
        WHERE OrderID = OrderCode
    ) INTO OrderExists;

    IF OrderExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No order exists with this code';
    ELSE
        SELECT TotalOrderPrice INTO OrderPrice
        FROM Orders
        WHERE OrderID = OrderCode;

        IF OrderPrice = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: The order has not been delivered yet';
        ELSE
            SELECT OrderID, 
                   FirstName AS CustomerFirstName, 
                   LastName AS CustomerLastName, 
                   TotalOrderPrice, 
                   PaymentMethod, 
                   TransactionDate, 
                   TransactionTime
            FROM Orders O, Payment P, Customer C
            WHERE OrderID = OrderCode
              AND O.OrderID = P.Order
              AND P.Customer = C.CustomerCode;
        END IF;
    END IF;
END $$
DELIMITER ;

/*
-- CASE 1: Invalid order code format
CALL PrintOrderReceipt('abc');    -- Error Code: 1644. Error: The order code format is invalid. Must be O_<positive number>
CALL PrintOrderReceipt('123');    -- Error Code: 1644. Same message
CALL PrintOrderReceipt('O_abc');  -- Error Code: 1644. Same message
CALL PrintOrderReceipt('O_-123'); -- Error Code: 1644. Same message
CALL PrintOrderReceipt('O_123abc'); -- Error Code: 1644. Same message

-- CASE 2: Valid code but does not exist
CALL PrintOrderReceipt('O_200'); -- Error Code: 1644. Error: No order exists with this code

-- CASE 3: Valid code but order not yet delivered
CALL PrintOrderReceipt('O_31'); -- Error Code: 1644. Error: The order has not been delivered yet

-- CASE 4: Valid code and order delivered
CALL PrintOrderReceipt('O_30'); -- Example: 'O_30', 'Giovanni', 'Rossi', '14.25', 'Satispay', '2024-12-30', '10:45:00'
*/

-- 5 Print a daily delivery report for a specific date (number of deliveries and total revenue)
DROP PROCEDURE IF EXISTS DailyDeliveryReport;

DELIMITER $$
CREATE PROCEDURE DailyDeliveryReport(ReportDate DATE)
BEGIN
    IF ReportDate > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: The date cannot be later than today';
    END IF;
    
    SELECT COUNT(D.DeliveryCode) AS NumberOfDeliveries, 
           SUM(O.TotalOrderPrice) AS TotalRevenue
    FROM Delivery D, Orders O
    WHERE D.DeliveryDate = ReportDate
      AND D.Order = O.OrderID;
END $$
DELIMITER ;

/*
-- CASE 1: Date is later than today
CALL DailyDeliveryReport('2025-02-01'); -- Error Code: 1644. Error: The date cannot be later than today

-- CASE 2: Date has no deliveries
CALL DailyDeliveryReport('2024-12-01'); -- Example: '0', 'NULL'

-- CASE 3: Date has deliveries
CALL DailyDeliveryReport('2024-12-02'); -- Example: '1', '15.50'
*/

-- 6 Create an order history for a specific customer
DROP PROCEDURE IF EXISTS CreateCustomerOrderHistory;

DELIMITER $$
CREATE PROCEDURE CreateCustomerOrderHistory(CustomerCode VARCHAR(10))
BEGIN
    IF CustomerCode NOT REGEXP '^C_[0-9]+$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: The customer code format is invalid. Must be CL_<positive number>';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = CustomerCode) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: The customer code does not exist';
    END IF;

    -- Dynamically create the view
    SET @sql = CONCAT(
        'CREATE OR REPLACE VIEW OrderHistory AS ',
        'SELECT O.OrderID, O.TotalOrderPrice, D.DeliveryDate, D.DeliveryTime ',
        'FROM Orders O, Delivery D ',
        'WHERE D.Customer = "', CustomerCode, '" ',
        'AND O.OrderID = D.Order ',
        'ORDER BY D.DeliveryDate DESC'
    );

    PREPARE ViewQuery FROM @sql;
    EXECUTE ViewQuery;
    DEALLOCATE PREPARE ViewQuery;
    
    SELECT 'OK! OrderHistory view created successfully' AS Message;
END $$
DELIMITER ;

/*
-- CASE 1: Invalid customer code format
CALL CreateCustomerOrderHistory('123'); -- Error Code: 1644. Error: The customer code format is invalid. Must be C_<positive number>
CALL CreateCustomerOrderHistory('abc'); -- Same message
CALL CreateCustomerOrderHistory('C_abc'); -- Same message
CALL CreateCustomerOrderHistory('C_-123'); -- Same message
CALL CreateCustomerOrderHistory('C_123abc'); -- Same message

-- CASE 2: Valid code but does not exist
CALL CreateCustomerOrderHistory('C_1000'); -- Error Code: 1644. Error: The customer code does not exist

-- CASE 3: Valid code and exists
CALL CreateCustomerOrderHistory('C_1'); -- OK! OrderHistory view created successfully
*/

-- 7 Select the top 3 among riders, stores, customers, and sandwiches
DROP PROCEDURE IF EXISTS FindTopPerformers;

DELIMITER $$
CREATE PROCEDURE FindTopPerformers()
BEGIN
    -- Rider with most deliveries
    SELECT R.RiderCode, 
           COUNT(D.DeliveryCode) AS TotalDeliveries
    FROM Rider R, Delivery D
    WHERE R.RiderCode = D.Rider
    GROUP BY R.RiderCode
    ORDER BY TotalDeliveries DESC
    LIMIT 3;

    -- Store with most orders
    SELECT S.ProvinceCode AS StoreProvince, 
           COUNT(D.DeliveryCode) AS TotalDeliveries
    FROM Store S, Delivery D
    WHERE S.ProvinceCode = D.Store
    GROUP BY StoreProvince
    ORDER BY TotalDeliveries DESC
    LIMIT 3;

    -- Customer with most orders
    SELECT C.CustomerCode, 
           COUNT(D.DeliveryCode) AS TotalDeliveredOrders
    FROM Customer C, Delivery D
    WHERE C.CustomerCode = D.Customer
    GROUP BY C.CustomerCode
    ORDER BY TotalDeliveredOrders DESC
    LIMIT 3;

    -- Most requested sandwich
    SELECT S.Name AS SandwichName, 
           COUNT(*) AS TotalSales
    FROM Sandwich S, OrderDetails OD
    WHERE S.SandwichCode = OD.Sandwich
    GROUP BY S.SandwichCode
    ORDER BY TotalSales DESC
    LIMIT 3;
END $$
DELIMITER ;

/*
-- CASE 1: Only one case because there can be no errors
CALL FindTopPerformers();
*/