-- NOTE! Instructions before running this script: insert the correct file path for the two files data/store.csv and data/past_contract.txt in 'load data' commands (lines 23 and 52)

-- Table initialization (necessary after any inserts executed to verify triggers)
DELETE FROM PastContract;
DELETE FROM Employee;
DELETE FROM OrderDetail;
DELETE FROM Inventory;
DELETE FROM Composition;
DELETE FROM Delivery;
DELETE FROM Store;
DELETE FROM Ingredient;
DELETE FROM Sandwich;
DELETE FROM Payment;
DELETE FROM Customer;
DELETE FROM Order;
DELETE FROM Rider;

SET GLOBAL local_infile = 1;

--
LOAD DATA LOCAL INFILE '*file_path*/data/store.csv'
INTO TABLE Locale
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

-- SELECT * FROM Locale;
-- DELETE FROM Locale;

--
INSERT INTO Employee VALUES
('E_1', 'Marco', 'Rossi', 'RSSMRC88A01F205Y', '3351234567', NULL, 'XP2345678', 'Cook', 'Permanent', '2021-03-15', NULL, 3000.50, 'Kitchen and Food Preparation', 'MI'),
('E_2', 'Luca', 'Bianchi', 'BCHLCA85P12H501X', '3351234568', 'BC23457AB', NULL, 'Quality Manager', 'Permanent', '2020-06-10', NULL, 2800.00, 'Kitchen and Food Preparation', 'RM'),
('E_3', 'Giulia', 'Verdi', 'VRDGLL93L01D548T', '3351234569', 'CD34567CD', 'ZT4567890', 'Assistant Cook', 'Fixed-term', '2022-01-01', '2023-12-31', 2500.75, 'Kitchen and Food Preparation', 'NA'),
('E_4', 'Sofia', 'Gallo', 'GLLSFA90A01C351Q', '3351234570', 'DE45678EF', 'AB5678901', 'Supply Manager', 'Fixed-term', '2023-04-01', '2025-03-31', 2200.00, 'Logistics and Warehouse', 'FI'),
('E_5', 'Alessandro', 'Neri', 'NRIALS79B03H501S', '3351234571', NULL, 'BD6789012', 'Warehouse Worker', 'Permanent', '2019-09-01', NULL, 2400.00, 'Logistics and Warehouse', 'PA'),
('E_6', 'Chiara', 'Morelli', 'MRLCHR92C16G273T', '3351234572', 'FG67890GH', 'CR7890123', 'Maintenance Worker', 'Fixed-term', '2023-02-01', '2024-01-31', 2300.50, 'Maintenance and Cleaning', 'TO'),
('E_7', 'Matteo', 'Romano', 'RMNMTE81D22H501V', '3351234573', 'GH78901IJ', 'DU8901234', 'Equipment Technician', 'Permanent', '2020-12-10', NULL, 1800.00, 'Maintenance and Cleaning', 'VE'),
('E_8', 'Ilaria', 'Conti', 'CNTLRA77H15L319U', '3351234574', 'HI89012KL', 'EJ9012345', 'Operations Manager', 'Permanent', '2018-07-01', NULL, 5000.00, 'Management and Supervision', 'BO'),
('E_9', 'Davide', 'Fontana', 'FNTDVD82M01B725X', '3351234575', 'IJ90123MN', NULL, 'Local Marketing Assistant', 'Fixed-term', '2023-05-15', '2025-05-14', 1900.25, 'Marketing and Promotion', 'CS'),
('E_10', 'Martina', 'Ricci', 'RCCMRT91T10G273P', '351234576', 'KL01234OP', 'GO1234567', 'Social Media Assistant', 'Permanent', '2021-11-01', NULL, 2100.00, 'Marketing and Promotion', 'LE'),
('E_11', 'Valerio', 'Caruso', 'CRSVLR86D22D761R', '3351234577', 'MN12345QR', NULL, 'Accounting Manager', 'Fixed-term', '2022-02-01', '2023-12-31', 3200.50, 'Administration', 'AN'),
('E_12', 'Giovanni', 'Santi', 'SNTGVN95L25F205Y', '3351234578', 'OP23456ST', 'IL3456789', 'Local Accountant', 'Permanent', '2020-10-01', NULL, 2800.00, 'Administration', 'CA');

-- SELECT * FROM Employee;
-- DELETE FROM Employee;

--
LOAD DATA LOCAL INFILE '*file_path*/data/past_contract.txt'
INTO TABLE PastContract
FIELDS TERMINATED BY ',';

-- SELECT * FROM PastContract;
-- DELETE FROM PastContract;

--
INSERT INTO Ingredient VALUES
('I_1', 'Vegetable', 'Lettuce'),
('I_2', 'Vegetable', 'Zucchini'),
('I_3', 'Vegetable', 'Carrot'),
('I_4', 'Meat', 'Chicken'),
('I_5', 'Meat', 'Beef'),
('I_6', 'Meat', 'Pork'),
('I_7', 'Meat', 'Turkey'),
('I_8', 'Fish', 'Tuna'),
('I_9', 'Fish', 'Salmon'),
('I_10', 'Fish', 'Shrimp'),
('I_11', 'Fish', 'Cod'),
('I_12', 'Cheese', 'Mozzarella'),
('I_13', 'Cheese', 'Parmesan'),
('I_14', 'Cheese', 'Gorgonzola'),
('I_15', 'Cheese', 'Provolone'),
('I_16', 'Spices', 'Oregano'),
('I_17', 'Spices', 'Black Pepper'),
('I_18', 'Spices', 'Chili Pepper'),
('I_19', 'Spices', 'Curry'),
('I_20', 'Sauces', 'Mayonnaise'),
('I_21', 'Sauces', 'Ketchup'),
('I_22', 'Sauces', 'Mustard'),
('I_23', 'Sauces', 'BBQ Sauce'),
('I_24', 'Fruit', 'Avocado'),
('I_25', 'Fruit', 'Lime'),
('I_26', 'Fruit', 'Apple'),
('I_27', 'Fruit', 'Orange'),
('I_28', 'Condiments', 'EVO Oil'),
('I_29', 'Condiments', 'Chili Oil');

-- SELECT * FROM Ingredient;
-- DELETE FROM Ingredient;

--
INSERT INTO Inventory VALUES
('AN', 'I_1', 50.00, 3.99, '2025-01-10'),
('AN', 'I_2', 6.00, 2.50, '2025-01-15'),
('AN', 'I_3', 70.00, 1.89, '2025-02-01'),
('BO', 'I_4', 65.00, 24.50, '2025-01-20'),
('BO', 'I_5', 55.00, 5.10, '2025-02-10'),
('BO', 'I_6', 8.00, 4.20, '2025-03-10'),
('CA', 'I_7', 50.00, 6.00, '2025-02-25'),
('CA', 'I_8', 40.00, 7.50, '2025-01-25'),
('CA', 'I_9', 60.00, 5.30, '2025-02-05'),
('CS', 'I_10', 45.00, 38.00, '2025-01-30'),
('CS', 'I_11', 75.00, 4.99, '2025-03-01'),
('CS', 'I_12', 50.00, 6.25, '2025-02-10'),
('FI', 'I_13', 80.00, 3.59, '2025-03-15'),
('FI', 'I_14', 9.50, 2.95, '2025-03-05'),
('FI', 'I_15', 60.00, 45.00, '2025-04-10'),
('LE', 'I_16', 70.00, 1.99, '2025-01-18'),
('LE', 'I_17', 40.00, 6.50, '2025-02-01'),
('LE', 'I_18', 8.00, 1.89, '2025-01-30'),
('MI', 'I_19', 90.00, 4.40, '2025-03-05'),
('MI', 'I_20', 60.00, 3.99, '2025-02-25'),
('MI', 'I_1', 14.00, 2.99, '2025-03-15'),
('NA', 'I_2', 50.00, 37.50, '2025-01-10'),
('NA', 'I_23', 70.00, 3.00, '2025-02-20'),
('NA', 'I_4', 60.00, 2.75, '2025-01-20'),
('PA', 'I_5', 80.00, 5.99, '2025-02-10'),
('PA', 'I_6', 50.00, 4.50, '2025-02-25'),
('PA', 'I_7', 4.50, 6.10, '2025-03-15'),
('RM', 'I_3', 45.00, 8.00, '2025-01-15'),
('RM', 'I_9', 60.00, 5.50, '2025-02-25'),
('RM', 'I_10', 75.00, 4.95, '2025-01-25'),
('TO', 'I_1', 70.00, 46.25, '2025-03-25'),
('TO', 'I_12', 50.00, 6.99, '2025-02-15'),
('TO', 'I_13', 60.00, 7.50, '2025-04-10'),
('VE', 'I_14', 90.00, 1.89, '2025-02-05'),
('VE', 'I_15', 6.50, 5.00, '2025-03-20'),
('VE', 'I_16', 5.00, 3.75, '2025-03-05'),
('AN', 'I_17', 8.00, 5.60, '2025-01-18'),
('AN', 'I_18', 50.00, 6.20, '2025-02-01'),
('AN', 'I_19', 40.00, 4.85, '2025-02-25'),
('BO', 'I_20', 55.00, 4.70, '2025-03-10'),
('CA', 'I_21', 70.00, 5.40, '2025-01-05'),
('FI', 'I_2', 50.00, 4.80, '2025-03-01'),
('LE', 'I_23', 60.00, 3.49, '2025-02-05'),
('MI', 'I_24', 45.00, 4.80, '2025-01-12'),
('NA', 'I_25', 3.00, 2.85, '2025-01-01'),
('PA', 'I_26', 9.00, 2.45, '2025-02-01'),
('RM', 'I_27', 10.00, 3.75, '2025-01-30'),
('TO', 'I_28', 60.00, 5.25, '2025-02-15'),
('VE', 'I_29', 80.00, 47.99, '2025-03-10'),
('FI', 'I_1', 40.00, 2.79, '2025-02-20'),
('CS', 'I_2', 75.00, 4.40, '2025-03-20'),
('CS', 'I_3', 60.00, 6.25, '2025-03-25'),
('FI', 'I_4', 2.00, 5.99, '2025-01-30'),
('LE', 'I_5', 90.00, 6.75, '2025-03-25'),
('MI', 'I_6', 45.00, 3.30, '2025-01-15'),
('PA', 'I_2', 60.00, 5.90, '2025-02-15'),
('RM', 'I_8', 70.00, 5.00, '2025-02-10'),
('VE', 'I_9', 55.00, 5.40, '2025-04-01'),
('AN', 'I_10', 1.00, 5.80, '2025-02-15'),
('TO', 'I_11', 50.00, 7.10, '2025-03-01'),
('CA', 'I_3', 70.00, 8.20, '2025-04-05'),
('BO', 'I_2', 80.00, 9.10, '2025-03-25'),
('CS', 'I_17', 75.00, 6.99, '2025-01-20'),
('FI', 'I_22', 6.00, 3.49, '2025-01-12'),
('LE', 'I_13', 80.00, 42.99, '2025-02-28'),
('MI', 'I_2', 70.00, 4.40, '2025-04-01'),
('NA', 'I_3', 75.00, 5.49, '2025-01-25'),
('PA', 'I_21', 11.00, 4.55, '2025-03-20'),
('RM', 'I_29', 90.00, 3.65, '2025-02-10'),
('TO', 'I_20', 80.00, 6.50, '2025-03-15'),
('VE', 'I_1', 70.00, 5.60, '2025-04-10'),
('BO', 'I_12', 65.00, 5.30, '2025-02-05'),
('CA', 'I_13', 85.00, 3.99, '2025-03-10'),
('CS', 'I_24', 8.00, 4.99, '2025-04-10'),
('FI', 'I_5', 70.00, 6.25, '2025-03-05'),
('LE', 'I_6', 60.00, 7.10, '2025-02-28'),
('MI', 'I_7', 50.00, 34.99, '2025-02-05'),
('NA', 'I_8', 60.00, 4.25, '2025-01-05'),
('PA', 'I_9', 7.00, 3.59, '2025-02-25'),
('RM', 'I_20', 80.00, 4.10, '2025-01-15');

-- SELECT * FROM Inventory;
-- DELETE FROM Inventory;

--
INSERT INTO Sandwich VALUES
('S_1', 'Classic', 4.50, 'Mozzarella, beef and lettuce'),
('S_2', 'Vegan', 5.00, 'Zucchini, carrots and avocado'),
('S_3', 'Romagna Style', 6.00, 'Mozzarella, arugula and cured ham'),
('S_4', 'Caprese', 5.50, 'Mozzarella, tomato and basil'),
('S_5', 'Sweet Delight', 7.00, 'Nutella and coconut flakes'),
('S_6', 'Spicy', 6.50, 'Spicy salami, provolone and chili pepper'),
('S_7', 'Margherita', 5.00, 'Mozzarella and oregano'),
('S_8', 'Country Style', 6.50, 'Sausage, potatoes and BBQ sauce'),
('S_9', 'Spring', 5.75, 'Fresh seasonal vegetables and lime'),
('S_10', 'Special', 7.50, 'Burrata, sun-dried tomato and speck');

-- SELECT * FROM Sandwich;
-- DELETE FROM Sandwich;

--
INSERT INTO Composition VALUES
('I_12', 'S_1'), ('I_5', 'S_1'), ('I_1', 'S_1'), ('I_17', 'S_1'), ('I_28', 'S_1'),
('I_2', 'S_2'), ('I_3', 'S_2'), ('I_24', 'S_2'), ('I_29', 'S_2'),
('I_12', 'S_3'), ('I_13', 'S_3'), ('I_6', 'S_3'), ('I_8', 'S_3'), ('I_11', 'S_3'), ('I_28', 'S_3'),
('I_12', 'S_4'), ('I_25', 'S_4'), ('I_16', 'S_4'), ('I_4', 'S_4'),
('I_15', 'S_5'), ('I_26', 'S_5'), ('I_27', 'S_5'),
('I_18', 'S_6'), ('I_15', 'S_6'), ('I_9', 'S_6'), ('I_29', 'S_6'), ('I_10', 'S_6'),
('I_12', 'S_7'), ('I_16', 'S_7'), ('I_7', 'S_7'), ('I_28', 'S_7'),
('I_6', 'S_8'), ('I_23', 'S_8'), ('I_14', 'S_8'), ('I_3', 'S_8'), ('I_22', 'S_8'),
('I_1', 'S_9'), ('I_24', 'S_9'), ('I_3', 'S_9'), ('I_10', 'S_9'), ('I_28', 'S_9'),
('I_12', 'S_10'), ('I_24', 'S_10'), ('I_19', 'S_10'), ('I_21', 'S_10'), ('I_20', 'S_10'), ('I_28', 'S_10');

-- SELECT * FROM Composition;
-- DELETE FROM Composition;

--
INSERT INTO Order (OrderID) VALUES
('O_1'),
('O_2'),
('O_3'),
('O_4'),
('O_5'),
('O_6'),
('O_7'),
('O_8'),
('O_9'),
('O_10'),
('O_11'),
('O_12'),
('O_13'),
('O_14'),
('O_15'),
('O_16'),
('O_17'),
('O_18'),
('O_19'),
('O_20'),
('O_21'),
('O_22'),
('O_23'),
('O_24'),
('O_25'),
('O_26'),
('O_27'),
('O_28'),
('O_29'),
('O_30'),
('O_31'),
('O_32'),
('O_33'),
('O_34'),
('O_35'),
('O_36'),
('O_37'),
('O_38'),
('O_39'),
('O_40');

-- SELECT * FROM Order;
-- DELETE FROM Order;

--
INSERT INTO OrderDetails VALUES
('O_1', 'S_1'), ('O_1', 'S_2'), ('O_1', 'S_3'),
('O_2', 'S_1'), ('O_2', 'S_4'),
('O_3', 'S_2'), ('O_3', 'S_5'), ('O_3', 'S_6'),
('O_4', 'S_3'),
('O_5', 'S_1'), ('O_5', 'S_4'),
('O_6', 'S_6'), ('O_6', 'S_7'), ('O_6', 'S_8'),
('O_7', 'S_9'), ('O_7', 'S_10'),
('O_8', 'S_4'), ('O_8', 'S_5'), ('O_8', 'S_6'),
('O_9', 'S_1'),
('O_10', 'S_1'), ('O_10', 'S_9'), ('O_10', 'S_10'),
('O_11', 'S_2'), ('O_11', 'S_5'),
('O_12', 'S_7'), ('O_12', 'S_10'),
('O_13', 'S_8'),
('O_14', 'S_1'), ('O_14', 'S_2'), ('O_14', 'S_4'),
('O_15', 'S_2'),
('O_16', 'S_1'), ('O_16', 'S_7'), ('O_16', 'S_3'),
('O_17', 'S_5'), ('O_17', 'S_8'),
('O_18', 'S_2'), ('O_18', 'S_7'), ('O_18', 'S_9'),
('O_19', 'S_4'),
('O_20', 'S_1'), ('O_20', 'S_3'), ('O_20', 'S_10'),
('O_21', 'S_5'),
('O_22', 'S_2'), ('O_22', 'S_6'),
('O_23', 'S_3'),
('O_24', 'S_9'), ('O_24', 'S_7'),
('O_25', 'S_1'), ('O_25', 'S_2'), ('O_25', 'S_8'),
('O_26', 'S_4'),
('O_27', 'S_3'), ('O_27', 'S_10'),
('O_28', 'S_5'), ('O_28', 'S_7'),
('O_29', 'S_1'),
('O_30', 'S_9'), ('O_30', 'S_4'),
('O_31', 'S_6'), ('O_31', 'S_3'), ('O_31', 'S_10'),
('O_32', 'S_2'),
('O_33', 'S_5'), ('O_33', 'S_4'),
('O_34', 'S_7'),
('O_35', 'S_6'), ('O_35', 'S_8'),
('O_36', 'S_1'), ('O_36', 'S_3'),
('O_37', 'S_9'),
('O_38', 'S_4'), ('O_38', 'S_7'),
('O_39', 'S_10'),
('O_40', 'S_2');

-- SELECT * FROM OrderDetails;
-- DELETE FROM OrderDetails;

--
INSERT INTO Customer VALUES 
('C_1', 'Giovanni', 'Rossi', 'RSSGNN90A01H501Z', 25, 'giovanni.rossi@email.com', '3456781234', 'Marche', 'Ancona', 'Via Roma', '60100', '15', NULL),
('C_2', 'Maria', 'Bianchi', 'BNCMRA80A41A066Z', 34, 'maria.bianchi@email.com', '3445871234', 'Emilia Romagna', 'Bologna', 'Viale Trieste', '40100', '8', 1),
('C_3', 'Luca', 'Verdi', 'VRDLUC75C26E858H', 29, 'luca.verdi@email.com', '3384569876', 'Sardinia', 'Cagliari', 'Piazza Yenne', '09100', '3', 2),
('C_4', 'Giulia', 'Esposito', 'ESPGUL85A43D325Y', 22, 'giulia.esposito@email.com', '3312345678', 'Calabria', 'Cosenza', 'Corso Mazzini', '87100', '10', 5),
('C_5', 'Marco', 'Ferrari', 'FRRMRC92D18A404V', 31, 'marco.ferrari@email.com', '3456667788', 'Tuscany', 'Florence', 'Piazza della Signoria', '50100', '4', 1),
('C_6', 'Laura', 'Russo', 'RSLLRA88S48A407O', 28, 'laura.russo@email.com', '3489901234', 'Apulia', 'Lecce', 'Via Benedetto Croce', '73100', '12', 3),
('C_7', 'Davide', 'Galli', 'GLLDVE94M10F205V', 40, 'davide.galli@email.com', '3334455667', 'Lombardy', 'Milan', 'Via Montenapoleone', '20100', '20', 2),
('C_8', 'Sara', 'Romano', 'RMNSRA87L50G704N', 36, 'sara.romano@email.com', '3352224558', 'Campania', 'Naples', 'Corso Umberto', '80100', '18', 1),
('C_9', 'Alessandro', 'Mancini', 'MNCALS92H01H501C', 45, 'alessandro.mancini@email.com', '3384443333', 'Sicily', 'Palermo', 'Via Libertà', '90100', '25', 4),
('C_10', 'Francesca', 'Giacomini', 'GCMFNC81P58Z404F', 27, 'francesca.giacomini@email.com', '3205566778', 'Lazio', 'Rome', 'Piazza del Popolo', '00100', '5', 2),
('C_11', 'Paolo', 'De Santis', 'DSTPLR72D20D794X', 38, 'paolo.desantis@email.com', '3458899776', 'Piedmont', 'Turin', 'Via Po', '10100', '7', NULL),
('C_12', 'Luisa', 'Grimaldi', 'GRMLSU76M35D486V', 33, 'luisa.grimaldi@email.com', '3297082333', 'Veneto', 'Venice', 'Campo Santa Margherita', '30100', '13', 1),
('C_13', 'Carlo', 'Giordano', 'GRDLCR84P03D084W', 32, 'carlo.giordano@email.com', '3310054321', 'Marche', 'Ancona', 'Viale della Vittoria', '60100', '8', 2),
('C_14', 'Elena', 'Monti', 'MNTLNA90A12Z404C', 26, 'elena.monti@email.com', '3388877665', 'Emilia Romagna', 'Bologna', 'Via Ugo Bassi', '40100', '5', 4),
('C_15', 'Simone', 'Pace', 'PCESMN77B30H642D', 41, 'simone.pace@email.com', '3206674456', 'Sardinia', 'Cagliari', 'Via Roma', '09100', '9', 2),
('C_16', 'Valeria', 'Martini', 'MRTLRA85D42L404X', 29, 'valeria.martini@email.com', '3453344556', 'Calabria', 'Cosenza', 'Via degli Annunziati', '87100', '6', NULL),
('C_17', 'Michele', 'Ricci', 'RCCMCL70B19F258V', 35, 'michele.ricci@email.com', '3443355667', 'Tuscany', 'Florence', 'Piazza Santa Maria Novella', '50100', '17', 3),
('C_18', 'Angela', 'Morandi', 'MRDNGV90M10V656N', 22, 'angela.morandi@email.com', '3334457788', 'Apulia', 'Lecce', 'Viale della Resistenza', '73100', '5', 2),
('C_19', 'Francesco', 'Perri', 'PRRFNC92A07B635E', 27, 'francesco.perri@email.com', '3458877665', 'Lombardy', 'Milan', 'Corso Buenos Aires', '20100', '10', 1),
('C_20', 'Stefania', 'Lupi', 'LPSTFN80T41Z907A', 28, 'stefania.lupi@email.com', '3345554432', 'Campania', 'Naples', 'Via Toledo', '80100', '22', 3),
('C_21', 'Riccardo', 'Lombardi', 'LMBRCI72L20E203X', 32, 'riccardo.lombardi@email.com', '3337788999', 'Sicily', 'Palermo', 'Corso Vittorio Emanuele', '90100', '6', 1),
('C_22', 'Nina', 'De Rosa', 'DSRNNA88L90A944V', 30, 'nina.derosa@email.com', '3335544332', 'Lazio', 'Rome', 'Piazza Navona', '00100', '18', 2),
('C_23', 'Fabio', 'Silvestri', 'SLVFBG79M12D278R', 46, 'fabio.silvestri@email.com', '3473322112', 'Piedmont', 'Turin', 'Piazza Castello', '10100', '14', 4),
('C_24', 'Giorgia', 'Bellini', 'BLLGRG93M03H491M', 24, 'giorgia.bellini@email.com', '3296678899', 'Veneto', 'Venice', 'Via Garibaldi', '30100', '11', NULL),
('C_25', 'Stefano', 'Pinto', 'PTNSFN92S04F156M', 25, 'stefano.pinto@email.com', '3322448666', 'Marche', 'Ancona', 'Via Manzoni', '60100', '20', NULL),
('C_26', 'Isabella', 'Russo', 'RSUSLL85C31A135W', 36, 'isabella.russo@email.com', '3387734222', 'Emilia Romagna', 'Bologna', 'Via Irnerio', '40100', '16', 3),
('C_27', 'Fabiana', 'Paolillo', 'PLLFBV88L99D524J', 31, 'fabiana.paolillo@email.com', '3347765321', 'Sardinia', 'Cagliari', 'Via Dante', '09100', '7', 2),
('C_28', 'Nicola', 'Gazzetta', 'GZZNCL80A10I403A', 29, 'nicola.gazzetta@email.com', '3354433221', 'Calabria', 'Cosenza', 'Via Panebianco', '87100', '13', 4),
('C_29', 'Silvia', 'Rossi', 'RSSLVA81P60C601B', 38, 'silvia.rossi@email.com', '3385502233', 'Tuscany', 'Florence', 'Viale dei Mille', '50100', '11', 3);

-- SELECT * FROM Customer;
-- DELETE FROM Customer;

--
INSERT INTO Payment VALUES
('P_1', 'CreditCard', '2024-12-01', '12:00:00', 'C_1', 'O_1'),
('P_2', 'Paypal', '2024-12-02', '14:30:00', 'C_2', 'O_2'),
('P_3', 'Satispay', '2024-12-03', '15:45:00', 'C_3', 'O_3'),
('P_4', 'CreditCard', '2024-12-04', '16:15:00', 'C_4', 'O_4'),
('P_5', 'Paypal', '2024-12-05', '10:00:00', 'C_5', 'O_5'),
('P_6', 'Satispay', '2024-12-06', '17:30:00', 'C_6', 'O_6'),
('P_7', 'CreditCard', '2024-12-07', '18:00:00', 'C_7', 'O_7'),
('P_8', 'Paypal', '2024-12-08', '11:30:00', 'C_8', 'O_8'),
('P_9', 'Satispay', '2024-12-09', '19:00:00', 'C_1', 'O_9'),
('P_10', 'CreditCard', '2024-12-10', '13:00:00', 'C_10', 'O_10'),
('P_11', 'Paypal', '2024-12-11', '20:00:00', 'C_11', 'O_11'),
('P_12', 'Satispay', '2024-12-12', '09:00:00', 'C_12', 'O_12'),
('P_13', 'CreditCard', '2024-12-13', '14:15:00', 'C_13', 'O_13'),
('P_14', 'Paypal', '2024-12-14', '11:30:00', 'C_14', 'O_14'),
('P_15', 'Satispay', '2024-12-15', '16:45:00', 'C_15', 'O_15'),
('P_16', 'CreditCard', '2024-12-16', '10:15:00', 'C_16', 'O_16'),
('P_17', 'Paypal', '2024-12-17', '13:00:00', 'C_17', 'O_17'),
('P_18', 'Satispay', '2024-12-18', '17:00:00', 'C_18', 'O_18'),
('P_19', 'CreditCard', '2024-12-19', '12:00:00', 'C_19', 'O_19'),
('P_20', 'Paypal', '2024-12-20', '19:00:00', 'C_20', 'O_20'),
('P_21', 'Satispay', '2024-12-21', '09:00:00', 'C_21', 'O_21'),
('P_22', 'CreditCard', '2024-12-22', '14:30:00', 'C_22', 'O_22'),
('P_23', 'Paypal', '2024-12-23', '16:00:00', 'C_23', 'O_23'),
('P_24', 'Satispay', '2024-12-24', '18:30:00', 'C_24', 'O_24'),
('P_25', 'CreditCard', '2024-12-25', '12:30:00', 'C_25', 'O_25'),
('P_26', 'Paypal', '2024-12-26', '09:30:00', 'C_26', 'O_26'),
('P_27', 'Satispay', '2024-12-27', '15:00:00', 'C_27', 'O_27'),
('P_28', 'CreditCard', '2024-12-28', '13:30:00', 'C_28', 'O_28'),
('P_29', 'Paypal', '2024-12-29', '16:00:00', 'C_29', 'O_29'),
('P_30', 'Satispay', '2024-12-30', '10:45:00', 'C_1', 'O_30');

-- SELECT * FROM Payment;
-- DELETE FROM Payment;

--
INSERT INTO Rider VALUES
('R_1', 'Alessandro', 'Martini', 'MRTLSN82A01Z404V', '3287564356', 'AB12345CD', NULL, '12345678901'),
('R_2', 'Marco', 'Rossi', 'RSSMRC85T10Z404C', '3284561327', NULL, 'PP2345678', '23456789012'),
('R_3', 'Francesco', 'Bianchi', 'BNCFNC76A21A403N', '3298765432', 'BC23456DE', 'PS3456789', '34567890123'),
('R_4', 'Giuseppe', 'Esposito', 'ESPGPP73B45Z789Q', '3403456789', NULL, 'TS4567890', '45678901234'),
('R_5', 'Simone', 'Verdi', 'VRDSMN78A23D738H', '3412345678', NULL, 'TU5678901', '56789012345'),
('R_6', 'Carlo', 'Gianluca', 'GLCNLC72C11F023V', '3499876543', NULL, 'LO6789012', '67890123456'),
('R_7', 'Luca', 'Ferrari', 'FRRLCA79P15Z404P', '3406789012', 'EF34567FG', 'MJ7890123', '78901234567'),
('R_8', 'Dario', 'Lombardi', 'LMBDRI65A07D484Q', '3383456789', 'GH45678HI', NULL, '89012345678'),
('R_9', 'Andrea', 'Ricci', 'RCCAND84S99F258P', '3352123456', 'IJ56789KL', 'BG9012345', '90123456789'),
('R_10', 'Lucia', 'Galli', 'GLLLCA80L12A502P', '3369876543', NULL, 'DR0123456', '01234567890');

-- SELECT * FROM Rider;
-- DELETE FROM Rider;

--
INSERT INTO Delivery VALUES
('D_1', 'Standard', 4.50, '2024-12-02', '13:00:00', 'O_1', 'C_1', 'R_1', 'MI'),
('D_2', 'Express', 7.25, '2024-12-03', '15:30:00', 'O_2', 'C_2', 'R_2', 'RM'),
('D_3', 'Standard', 5.10, '2024-12-04', '12:30:00', 'O_3', 'C_3', 'R_3', 'NA'),
('D_4', 'Express', 3.80, '2024-12-05', '18:00:00', 'O_4', 'C_4', 'R_4', 'FI'),
('D_5', 'Standard', 6.20, '2024-12-06', '16:45:00', 'O_5', 'C_5', 'R_5', 'PA'),
('D_6', 'Express', 5.50, '2024-12-07', '14:15:00', 'O_6', 'C_6', 'R_6', 'TO'),
('D_7', 'Standard', 7.00, '2024-12-08', '10:30:00', 'O_7', 'C_7', 'R_7', 'VE'),
('D_8', 'Express', 6.50, '2024-12-09', '12:00:00', 'O_8', 'C_8', 'R_8', 'BO'),
('D_9', 'Standard', 4.80, '2024-12-10', '16:00:00', 'O_9', 'C_1', 'R_9', 'CS'),
('D_10', 'Express', 8.00, '2024-12-11', '17:30:00', 'O_10', 'C_10', 'R_10', 'LE'),
('D_11', 'Standard', 3.90, '2024-12-12', '11:15:00', 'O_11', 'C_11', 'R_1', 'AN'),
('D_12', 'Express', 6.10, '2024-12-13', '13:00:00', 'O_12', 'C_12', 'R_2', 'CA'),
('D_13', 'Standard', 5.40, '2024-12-14', '14:00:00', 'O_13', 'C_13', 'R_3', 'MI'),
('D_14', 'Express', 7.70, '2024-12-15', '12:30:00', 'O_14', 'C_14', 'R_4', 'RM'),
('D_15', 'Standard', 3.60, '2024-12-16', '16:45:00', 'O_15', 'C_15', 'R_1', 'NA'),
('D_16', 'Express', 6.80, '2024-12-17', '17:00:00', 'O_16', 'C_16', 'R_6', 'FI'),
('D_17', 'Standard', 5.30, '2024-12-18', '14:00:00', 'O_17', 'C_17', 'R_7', 'PA'),
('D_18', 'Express', 4.70, '2024-12-19', '15:15:00', 'O_18', 'C_18', 'R_8', 'TO'),
('D_19', 'Standard', 6.00, '2024-12-20', '16:45:00', 'O_19', 'C_19', 'R_9', 'VE'),
('D_20', 'Express', 7.50, '2024-12-21', '18:00:00', 'O_20', 'C_20', 'R_10', 'FI'),
('D_21', 'Standard', 5.60, '2024-12-22', '11:30:00', 'O_21', 'C_21', 'R_1', 'CS'),
('D_22', 'Express', 4.40, '2024-12-23', '13:00:00', 'O_22', 'C_22', 'R_2', 'LE'),
('D_23', 'Standard', 6.40, '2024-12-24', '14:30:00', 'O_23', 'C_23', 'R_3', 'AN'),
('D_24', 'Express', 5.20, '2024-12-25', '16:15:00', 'O_24', 'C_24', 'R_1', 'FI'),
('D_25', 'Standard', 7.10, '2024-12-26', '13:30:00', 'O_25', 'C_25', 'R_5', 'MI'),
('D_26', 'Express', 6.60, '2024-12-27', '15:00:00', 'O_26', 'C_26', 'R_6', 'RM'),
('D_27', 'Standard', 5.30, '2024-12-28', '14:45:00', 'O_27', 'C_27', 'R_7', 'NA'),
('D_28', 'Express', 7.80, '2024-12-29', '17:00:00', 'O_28', 'C_28', 'R_8', 'FI'),
('D_29', 'Standard', 5.00, '2024-12-30', '18:30:00', 'O_29', 'C_29', 'R_9', 'PA'),
('D_30', 'Express', 6.30, '2024-12-31', '19:00:00', 'O_30', 'C_1', 'R_1', 'TO');

-- SELECT * FROM Delivery;
-- DELETE FROM Delivery;