-- 1 Calculate the total sales made in a given month and year
DROP FUNCTION IF EXISTS MonthlySalesTotal;

DELIMITER $$
CREATE FUNCTION MonthlySalesTotal(Month INT, Year INT) 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    IF Month < 1 OR Month > 12 THEN
        RETURN 'Error: The provided month must be between 1 and 12.';
    END IF;

    SELECT COALESCE(SUM(O.TotalOrderPrice), 0) INTO total
    FROM `Order` O, Delivery D
    WHERE O.OrderID = D.`Order`
      AND MONTH(D.DeliveryDate) = Month AND YEAR(D.DeliveryDate) = Year;

    RETURN CONCAT('Total sales for ', Month, '/', Year, ': ', total, ' EUR');
END $$
DELIMITER ;

/*
-- CASE 1: Month value is invalid
SELECT MonthlySalesTotal(13, 2024) AS Result; -- Error: The provided month must be between 1 and 12.

-- CASE 2: Valid month and year but no deliveries occurred
SELECT MonthlySalesTotal(11, 2024) AS Result; -- Total sales for 11/2024: 0.00 EUR

-- CASE 3: Valid month and year with deliveries
SELECT MonthlySalesTotal(12, 2024) AS Result; -- Total sales for 12/2024: 394.75 EUR
*/

-- 2 Calculate the number of sandwiches in an order
DROP FUNCTION IF EXISTS CountSandwichesInOrder;

DELIMITER $$
CREATE FUNCTION CountSandwichesInOrder(OrderCode VARCHAR(15)) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE total TINYINT UNSIGNED;
    
    IF NOT OrderCode REGEXP '^O_[0-9]+$' THEN
        RETURN 'Error: OrderCode is not in the correct format. Must be in the format O_<positive number>';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = OrderCode) THEN
        RETURN 'Error: No order exists with this code';
    END IF;

    SELECT COUNT(*) INTO total
    FROM OrderDetails
    WHERE `Order` = OrderCode;

    RETURN CONCAT('Number of sandwiches for order ', OrderCode, ': ', total);
END $$
DELIMITER ;

/*
-- CASE 1: Invalid OrderCode format
SELECT CountSandwichesInOrder('123');      -- Error: OrderCode is not in the correct format. Must be in the format O_<positive number>
SELECT CountSandwichesInOrder('abc');      -- Error: OrderCode is not in the correct format. Must be in the format O_<positive number>
SELECT CountSandwichesInOrder('O_abc');    -- Error: OrderCode is not in the correct format. Must be in the format O_<positive number>
SELECT CountSandwichesInOrder('O_-12');    -- Error: OrderCode is not in the correct format. Must be in the format O_<positive number>
SELECT CountSandwichesInOrder('O_12abc');  -- Error: OrderCode is not in the correct format. Must be in the format O_<positive number>

-- CASE 2: Valid OrderCode but does not exist
SELECT CountSandwichesInOrder('O_100');    -- Error: No order exists with this code

-- CASE 3: Valid OrderCode that exists
SELECT CountSandwichesInOrder('O_5');      -- Number of sandwiches for order O_5: 2
*/
