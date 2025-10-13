# Detailed Documentation: takeaway-db-system

This document provides an in-depth explanation of the project ..., which implements a management system for a database of piadines.

## 📚 Table of Contents

- [Conceptual Design](#conceptual-design)
    - [Request](#request)
    - [Requirements Analysis](#requirements-analysis)
    - [Requirements Gathering](#requirements-gathering)
        - [Data Requirements](#data-requirements)
        - [Operation Requirements](#operation-requirements)
    - [Conceptual Data Representation](#conceptual-data-representation)
    - [Documentation of the Conceptual Data Schema](#documentation-of-the-conceptual-data-schema)

- [Logical Design](#logical-design)
    - [E-R Schema Restructuring](#e-r-schema-restructuring)
        - [Redundancy Analysis](#redundancy-analysis)
        - [Removal of Generalizations](#removal-of-generalizations)
        - [Removal of Multivalued Attributes](#removal-of-multivalued-attributes)
        - [Selection of Primary Identifiers](#selection-of-primary-identifiers)
        - [Restructured Schema](#restructured-schema)
    - [Translation to the Relational Model](#translation-to-the-relational-model)
        - [Logical Schema](#logical-schema)

- [MySQL Implementation](#mysql-implementation)
    - [Procedures](#procedures)
        - [RemoveExpiredIngredients](#removeexpiredingredients)
        - [ListShopsWithLimitedIngredient](#listshopswithlimitedingredient)
        - [ChainMenu](#chainmenu)
        - [PrintOrderReceipt](#printorderreceipt)
        - [DailyDeliveryReport](#dailydeliveryreport)
        - [CreateCustomerOrderHistory](#createcustomerorderhistory)
        - [FindBest](#findbest)
    - [Functions](#functions)
        - [MonthlySalesTotal](#monthlysalestotal)
        - [CountPiadinePerOrder](#countpiadineperorder)

## CONCEPTUAL DESIGN

## Request
A chain of takeaway piadinerias, with locations distributed in the main cities of Italy, requires a well-organized database to manage data related to customers, orders, employees, inventory, and locations.

For each customer, personal information is recorded, including first name, last name, age, email, tax code, phone number, address, and optionally the floor.

The staff of each location is divided into different categories (for example, cleaning staff, sandwich preparers, packaging staff). For each employee, the first name, last name, phone number, and details of the documents required for hiring are stored. Additional information is also recorded for the staff, such as professional title, contract type (fixed-term or permanent), salary, department, contract period (for fixed-term contracts), and previous employment.

For self-employed workers, the situation is different: they have a VAT number and are not associated with a specific store.

Each worker, whether an employee or self-employed, can also be a customer.

The chain has only one location per city where it is present. Each location is registered via an address; it has its own staff and an inventory, consisting of the ingredients necessary for preparing the piadinas. Each food item is recorded with a unique code, name, category (e.g., meat, fish, vegetables, etc.), unit price, expiration date, and available quantity.

Piadinas are distinguished by a unique code, a name, a description, and a price. Each order, requested by a customer, is delivered by a courier from a specific location. Orders are recorded through a unique code and the total price of the order.

For delivery, there is a price that varies depending on the type of delivery (for “standard” the price does not change, while for “express” it increases by €3) and on the distance (each kilometer increases the price by €0.20).

Each order is associated with a transaction recorded with a payment code and payment method. For each phase of the order (request, delivery, and payment), date and time are recorded.

