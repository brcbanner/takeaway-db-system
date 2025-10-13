# Detailed Documentation: takeaway-db-system

This document provides an in-depth explanation of the project ..., which implements a management system for a database of piadines.

## 📚 Table of Contents

- [Conceptual Design](#conceptual-design)
    - [Sample Owner Request](#sample-owner-request)
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

## Sample Owner Request
A chain of takeaway sandwich shops, which has locations in the main cities of Italy, needs a well-organized database to handle info about customers, orders, workers, inventory, and shops.

For each customer, their personal info is recorded, including first name, last name, age, email, tax code, phone number, _address_, and maybe the _floor_.

The staff at each _point of sale_ is divided into different categories (like cleaning staff, sandwich makers, packaging people). For each worker, the first name, last name, phone number, and _the details of documents needed for hiring_ are saved. Other useful info for staff is also stored, like professional title, type of contract (fixed-term or permanent), _salary_, work area, _contract period_ (for fixed-term contracts), and past employment. For _people who work independently_, it's a bit different: they have a VAT number and are not tied to a specific _store_.

Any worker, whether employed or independent, can also be a customer.

The chain has only one _store_ per city. Each _point of sale_ is recorded via an _address_; it has its own staff and an inventory made of the ingredients needed to make sandwiches. Every ingredient is tracked with a unique code, name, category (like meat, fish, vegetables, etc.), _unit price_, expiration date, and _available amount_.

Sandwiches themselves have a unique code, a name, a description, and a _price_. Each order, requested by a customer, is delivered by a rider from a specific _store_. Orders are tracked with a unique code and the _total order price_. Delivery has a _price_ that changes depending on the delivery type (for “standard” the price doesn’t change, for “express” it’s 3 euros more) and _distance_ (every kilometer increases the price by 20 cents). Each order is linked to a payment transaction with a payment code and method. For each stage of the order (request, delivery, and payment), date and time are recorded.

## Requirements Analysis
This text presents a number of ambiguities and imprecisions. At this stage, it is important to:

- **Avoid overly generic terms**, which make a concept unclear, and replace them with more meaningful ones or define them clearly 
  - `Address` → address including region, province, street (street or square), postal code, and street number  
  - `Floor` → floor number  
  - `Details of documents required for hiring` → tax code and ID card number, or alternatively passport number  
  - `Contract period` → employment start and end dates  
  - `Available amount` → available weight  
  - `Distance` → distance between the delivery address (customer residence) and the store from which the order is sent  

- **Simplify convoluted sentences** that make the text difficult to understand
  - `People who work independently` → freelance workers

- **Identify synonyms and homonyms** to clarify ambiguities
  - `Store` and `point of sale` → `location` 

- **Make references between terms explicit**
  - `Freelance workers` → riders

- **Indicate the unit of measurement** for all quantities 
  - `Unit price` → euro per kg or euro ??
  - `Available weight` → kilograms
  - `Distance` → kilometers
  - `Price` and `total order price` → euro

To clarify and understand the terms used, a glossary of terms is presented below.

| **Term** | **Description** | **Synonyms** | **Related terms** |
|-----------|-----------------|---------------|--------------------|
| `Distance` | Distance between the store and the delivery address, i.e., the customer's residence. | — | `Order` |
| `Documents for hiring` | Tax code and an identity document, i.e., ID card or passport. | — | `Worker`, `Store` |
| `Riders` | Workers of the chain, with a VAT number, who deliver the orders. | `Self-employed workers` | `Staff` |
| `Address` | Address of the customer or a store, including region, province, postal code, street/square, and street number. | — | `Customer`, `Order`, `Store` |
| `Workers` | Staff employed in each store, i.e., employees. Also includes self-employed ones. | `Staff`, `Employees` | `Store`, `Worker` |
| `Store` | A store of the chain. | `Location`, `Point of sale` | `Worker`, `Order` |
| `Contract period` | Start and end date of a work contract. | — | `Staff` |
| `Floor` | Number of the floor of an apartment. | — | `Customer` |
| `Available quantity` | Available weight. | — | `Ingredient` |
| `Street` | General term for indicating a street or square in an address. | — | `Address` |
